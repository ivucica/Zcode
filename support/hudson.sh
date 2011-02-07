#!/usr/bin/env bash
#
# CI server build script.
#

set -ex

HOME=$(dirname $PWD); export HOME
. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh

make distclean || true
./autotools.sh
./configure
make distclean
make
make check

