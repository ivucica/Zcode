#!/usr/bin/env bash
#
# CI server build script.
#
# Right now this assumes that 'dpkg' is the package manager.
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

cache_and_unpack() {
       local url="$1"
       local name=$(basename "$url")
       if ! [[ -f "../$name" ]]
       then
               curl "$url" > "../$name"
       fi
       tar xzf "../$name"
}

declare -a MAKE_OPTS
detect_clang() {
	MAKE_OPTS=()
	if command -v clang >/dev/null
	then
		MAKE_OPTS+=( "CC=clang" "CPP=clang -E" "CXX=clang++" "LD=clang" )

		# Steal gcc's objc runtime
		OBJC_RUNTIME_PATH=$(dirname $(dirname $(dpkg -S objc/objc.h |awk '{print $2}' |sort |head -n 1)))
		MAKE_OPTS+=( "OBJCFLAGS+= -I$OBJC_RUNTIME_PATH" )
	fi
}

invoke_make() {
	"$MAKE" "${MAKE_OPTS[@]}" "$@"
}

build_it() {
	HOME=$(dirname $PWD); export HOME
	. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
	find_usable_make
	detect_clang

	invoke_make distclean || true
	./configure
	invoke_make clean
	invoke_make
	invoke_make check
}

build_it
exit $?
