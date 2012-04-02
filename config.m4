dnl config.m4 for extension php_rrd
dnl Comments in this file start with the string 'dnl'.

PHP_ARG_WITH(rrd, for rrdtool support,
[  --with-rrd[=DIR]          Include rrdtool support (requires rrdtool >= 1.3.x)])

AC_ARG_WITH(rrd-binary,
[AC_HELP_STRING([--with-rrd-binary][=PATH], [rrd binary dir path, mostly for testing (default=$PATH)])],
[AC_PATH_PROG(RRDTOOL_BIN, rrdtool, no, $withval)],
[AC_PATH_PROG(RRDTOOL_BIN, rrdtool, no, $PATH)])

AC_SUBST(RRDTOOL_BIN)
if test -f $srcdir/tests/rrdtool-bin.inc.in; then
  AC_OUTPUT(tests/rrdtool-bin.inc)
  AC_OUTPUT(tests/data/Makefile)
fi

if test "$PHP_RRD" != "no"; then
  if test "$PHP_RRD" != "yes"; then
    AC_MSG_CHECKING(if rrdtool specified path is valid)
    if test -r "$PHP_RRD/include/rrd.h"; then
      RRDTOOL_INCDIR=$PHP_RRD/include
      RRDTOOL_LIBDIR=$PHP_RRD/$PHP_LIBDIR
      AC_MSG_RESULT([yes])
    else
      AC_MSG_RESULT([no])
      AC_MSG_ERROR([The specified RRDTool path is invalid or the installation is incomplete
      Please specify another path or reinstall the rrdtool distribution])
    fi
  else
    AC_MSG_CHECKING([for rrdtool header files in default paths])
    for i in /usr /usr/local /usr/local/rrdtool /opt; do
      test -r $i/include/rrd.h && RRDTOOL_LIBDIR=$i/$PHP_LIBDIR && RRDTOOL_INCDIR=$i/include
    done
    if test -z "$RRDTOOL_INCDIR"; then
      AC_MSG_RESULT([not found])
      AC_MSG_ERROR([Please reinstall the rrdtool distribution])
    else
      AC_MSG_RESULT(found in $RRDTOOL_INCDIR)
    fi
  fi

  dnl Finish the setup

  PHP_ADD_INCLUDE($RRDTOOL_INCDIR)

  PHP_CHECK_LIBRARY(rrd, rrd_create,
  [
    PHP_ADD_LIBRARY_WITH_PATH(rrd, $RRDTOOL_LIBDIR, RRD_SHARED_LIBADD)
    AC_DEFINE(HAVE_RRDTOOL, 1, [ ])
  ], [
    AC_MSG_ERROR([wrong rrd lib version or lib not found])
  ], [
    -L$RRDTOOL_LIBDIR
  ])

  dnl save temporary LDFLAGS, necessary for PHP_CHECK_FUNC
  old_LDFLAGS=$LDFLAGS
  LDFLAGS="$LDFLAGS -L$RRDTOOL_LIBDIR"

  dnl rrd_graph_v is available in 1.3.0+
  PHP_CHECK_FUNC(rrd_graph_v, rrd)
  if test "$ac_cv_func_rrd_graph_v" != yes; then
    AC_MSG_ERROR([rrd lib version seems older than 1.3.0, update to 1.3.0+])
  fi

  dnl rrd_lastupdate_r available in 1.4.0+
  PHP_CHECK_FUNC(rrd_lastupdate_r, rrd)

  LDFLAGS=$old_LDFLAGS

  PHP_NEW_EXTENSION(rrd, rrd.c rrd_graph.c rrd_create.c rrd_update.c rrd_info.c, $ext_shared)
  PHP_SUBST(RRD_SHARED_LIBADD)
fi
