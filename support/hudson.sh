#!/usr/bin/env bash
#
# CI server build script.
#

set -ex

abort() {
	printf 'hudson.sh: ' 2>&1
	printf "$@" 2>&1
	exit 1
}

find_usable_make() {
	for MAKE in gnumake gmake make :
	do
		if command -v $MAKE >/dev/null
		then
			break
		fi
	done
	if [[ $MAKE = : ]]
	then
		abort "Could not find an acceptable 'make'"
	fi
}

ensure_we_have_clang() {
	if ! command -v clang >/dev/null
	then
		abort "No 'clang' in path."
	fi
}

cache_and_unpack() {
	local url="$1"
	local name=$(basename "$url")
	if ! [[ -f "../$name" ]]
	then
		curl "$url" > "../$name"
	fi
	tar xzf "../$name"
}

#
# For reproducible builds, we use a gnustep-make specific to this workspace.
#
set_up_gnustep() {
	ensure_we_have_clang
	export HOME=`dirname $PWD`
	rm -rf ~/GNUstep
	mkdir -p ~/GNUstep/GNUstep/Library

	local GM=gnustep-make-2.4.0
	cache_and_unpack "ftp://ftp.gnustep.org/pub/gnustep/core/$GM.tar.gz"
	( cd $GM
	  CC=clang CPP="clang -E" CXX="clang++" ./configure \
		--prefix=$HOME/GNUstep/GNUstep \
		--with-config-file=$HOME/GNUstep/etc/GNUstep.conf \
		--with-library-combo=gnu-gnu-gnu \
		--enable-absolute-install-paths
	  $MAKE 
	  $MAKE install
	  )
	rm -rf $GM
	. ~/GNUstep/GNUstep/System/Library/Makefiles/GNUstep.sh

	local GB=gnustep-base-1.21.1
	cache_and_unpack "ftp://ftp.gnustep.org/pub/gnustep/core/$GB.tar.gz"
	( cd $GB
          ./configure
          $MAKE
          $MAKE install
	  )
	rm -rf $GB

	local GG=gnustep-gui-0.19.0
	cache_and_unpack "ftp://ftp.gnustep.org/pub/gnustep/core/$GG.tar.gz"
	( cd $GG
          ./configure
          $MAKE
          $MAKE install
	  )
	rm -rf $GG
}

build_it() {
	export HOME=`dirname $PWD`
	. ~/GNUstep/GNUstep/System/Library/Makefiles/GNUstep.sh

	$MAKE distclean || true
	./configure
	$MAKE clean
	$MAKE
	$MAKE check
}

find_usable_make
case "$1" in
--install)	
	set_up_gnustep
	;;
--build)
	build_it
	;;
*)
	abort "Not sure what to do with '$1'"
esac
