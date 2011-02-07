#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.67])
AC_INIT(Zcode, 1.0, [ivan@vucica.net])
AC_CONFIG_SRCDIR([Zcode_main.m])
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

# Detect whether clang is installed.  If so, use it instead.
AC_PROG_CC([clang gcc cc])
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

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([GNUmakefile.preamble
                 check/GNUmakefile.preamble])
AC_OUTPUT
