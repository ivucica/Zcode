#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.67])
AC_INIT(Zcode, 1.0, [ivan@vucica.net])
AC_CONFIG_SRCDIR([IDE/Zcode_main.m])
AC_CONFIG_HEADERS([config.h])

# We need GNUstep
AC_PATH_PROG(GNUSTEP_CONFIG, gnustep-config, no)
if test -z "$GNUSTEP_MAKEFILES"; then
  if test "$GNUSTEP_CONFIG" = "no"; then
    AC_MSG_ERROR([GNUSTEP_MAKEFILES not set and gnustep-config not found.])
  fi
  GNUSTEP_MAKEFILES=`"$GNUSTEP_CONFIG" --variable=GNUSTEP_MAKEFILES`
fi
AC_SUBST(GNUSTEP_MAKEFILES)

# Checks for programs.
AC_CHECK_PROGS(MAKE, gnumake gmake make, no)
if test x$MAKE = xno; then
  AC_MSG_ERROR([No acceptable version of GNU make was found.])
fi
AC_PROG_SED
AC_PROG_GREP

# Detect whether gcc-4.6 or clang is installed.  If so, use it instead.
AC_PROG_CC([gcc-4.6 clang gcc cc])
SET_CC="CC = $CC"
SET_CPP="CPP = $CPP"
AC_SUBST(SET_CC)
AC_SUBST(SET_CPP)

# We need to add a path to objc/objc.h for clang.
ADDITIONAL_INCLUDE_DIRS=
AC_CHECK_HEADER(objc/objc.h,, [
  
  # Use gcc's objc/objc.h
  AC_PATH_PROG(GCC, gcc, no)
  if test x$GCC = xno; then
    AC_MSG_ERROR([No gcc found (needed for objc/objc.h)])
  fi

  AC_MSG_CHECKING([for gcc's Objective-C system includes])
  printf '#include <objc/objc.h>\n' >conftest.h
  GCC_OBJC_SYSINCLUDE_DIR=`$GCC -E conftest.h |$GREP 'objc/objc\.h\"' |$SED -n -e '1{
  		s/^# [0-9]* "//
		s/".*//
		s/\/objc\/objc\.h//
		p
	}'`
  result=$?
  rm -f conftest.h
  if test $result -ne 0; then
    AC_MSG_ERROR([problem when trying to find])
  fi
  AC_MSG_RESULT($GCC_OBJC_SYSINCLUDE_DIR)
  ADDITIONAL_INCLUDE_DIRS="$ADDITIONAL_INCLUDES -I$GCC_OBJC_SYSINCLUDE_DIR"
])
AC_SUBST(ADDITIONAL_INCLUDE_DIRS)

# GNUSTEP_MAKE_IFELSE(source, action-if-success [, action-if-failure])
# -------------------------------------------------------------------
m4_define([GNUSTEP_MAKE_IFELSE],
  [{ mkdir -p conftest.d
     cat > conftest.d/test.m <<__END
$1
__END
     cat > conftest.d/GNUmakefile <<__END

ifeq (\$(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := \$(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
ifeq (\$(GNUSTEP_MAKEFILES),)
 \$(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif


include \$(GNUSTEP_MAKEFILES)/common.make

VERSION = 1.0
PACKAGE_NAME = TestProg
APP_NAME = TestProg

TestProg_OBJC_FILES=test.m

$SET_CC
$SET_CPP
ADDITIONAL_INCLUDE_DIRS = $ADDITIONAL_INCLUDE_DIRS
include \$(GNUSTEP_MAKEFILES)/aggregate.make
include \$(GNUSTEP_MAKEFILES)/application.make
__END
     echo "+++ Next test: " >&AS_MESSAGE_LOG_FD
     cat conftest.d/test.m >&AS_MESSAGE_LOG_FD
     echo "Running make in conftest.d" >&AS_MESSAGE_LOG_FD
     $MAKE -C conftest.d >&AS_MESSAGE_LOG_FD 2>&AS_MESSAGE_LOG_FD
     gnustep_make_result=$?
     rm -rf conftest.d

     if test $gnustep_make_result -eq 0 ; then
       :; $2
     else
       :; $3
     fi }])

# Check for NSViewController
AC_MSG_CHECKING([for NSViewController])
GNUSTEP_MAKE_IFELSE([
#import <AppKit/AppKit.h>
#import <AppKit/NSViewController.h>

NSViewController* vc;
main() { return 0; }
],[
  AC_DEFINE([HAVE_NSVIEWCONTROLLER_H], 1, [Define to 1 if GNUstep-base has NSViewController.])
  AC_MSG_RESULT([found])
],[
  AC_MSG_RESULT([not found])
])


 
# Check for buggy name of NSTexturedRoundedBezelStyle,
# that is, NSTexturedRoundBezelStyle
AC_MSG_CHECKING([for NSTexturedRoundBezelStyle])
GNUSTEP_MAKE_IFELSE([
#import <AppKit/AppKit.h>
main() { NSGradientType testVariable = NSTexturedRoundBezelStyle; return 0; }
],[
  AC_DEFINE([HAVE_NSTEXTUREDROUNDBEZELSTYLE], 1, [Define to 1 if NSTexturedRoundBezelStyle is defined. Older GNUstep versions had a bug with having this defined, instead of NSTexturedRoundedBezelStyle.])
  AC_MSG_RESULT([old gnustep])
],[
  AC_MSG_RESULT([newer gnustep])
])


# Check for missing NSNibOwner in older GNUstep
AC_MSG_CHECKING([for NSNibOwner])
GNUSTEP_MAKE_IFELSE([
#import <AppKit/AppKit.h>
main() { NSString *testVariable = NSNibOwner; return 0; }
],[
  AC_DEFINE([HAVE_NSNIBOWNER], 1, [Define to 1 if NSNibOwner is properly defined.])
  AC_MSG_RESULT([found])
],[
  AC_MSG_RESULT([not found])
])



# Check for compiler not allowing 'inner for loop'
AC_MSG_CHECKING([for c99])
GNUSTEP_MAKE_IFELSE([
#import <AppKit/AppKit.h>
main() { for(int i = 0; i<0; i++); return 0; }
],[
  AC_MSG_RESULT([default])
],[
  AC_MSG_RESULT([not default, passing argument])
  ADDITIONAL_CFLAGS="$ADDITIONAL_CFLAGS -std=c99"
  ADDITIONAL_OBJCFLAGS="$ADDITIONAL_OBJCFLAGS -std=c99"
  AC_SUBST(ADDITIONAL_CFLAGS)
  AC_SUBST(ADDITIONAL_OBJCFLAGS)
])




AC_CONFIG_FILES([GNUmakefile.preamble
                 check/GNUmakefile.preamble])
AC_OUTPUT
