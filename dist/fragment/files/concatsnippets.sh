#!/bin/bash

# Script to concat files to a config file.
#
# Given a directory like this:
# /path/to/conf.d
# |-- snippets
# |   |-- 00_named.conf
# |   |-- 10_domain.net
# |   `-- zz_footer
#
# The script supports a test option that will build the concat file to a temp location and 
# use /usr/bin/cmp to verify if it should be run or not.  This would result in the concat happening
# twice on each run but gives you the option to have an unless option in your execs to inhibit rebuilds.
# 
# Without the test option and the unless combo your services that depend on the final file would end up 
# restarting on each run, or in other manifest models some changes might get missed.
#
# OPTIONS:
#  -o	The file to create from the sources
#  -d	The directory where the snippets are kept
#  -t	Test to find out if a build is needed, basically concats the files to a temp
#       location and compare with what's in the final location, return codes are designed
#       for use with unless on an exec resource
#  -n	Sort the output numerically rather than the default alpha sort
#
# the command: 
#
#   concatsnippets.sh -o /path/to/conffile.cfg -d /path/to/conf.d
#
# creates /path/to/conf.d/snippets.concat and copies the resulting 
# file to /path/to/conffile.cfg.  The files will be sorted alphabetically
# pass the -n switch to sort numerically.
# 
# The script does error checking on the various dirs and files to make
# sure things don't fail.

OUTFILE=""
DIRPATH=""
TEST=""
SORTARG="-z"

while getopts "o:p:tn" options; do
	case $options in
		o ) OUTFILE=$OPTARG;;
		p ) DIRPATH=$OPTARG;;
		n ) SORTARG="-zn";;
		t ) TEST="true";;
		* ) echo "Specify output file with -o and snippet directory with -d"
		    exit 1;;
	esac
done

TARGET="${DIRPATH}/${OUTFILE}"
SNIPPETS="${TARGET}.snippets"
CONCAT="${SNIPPETS}/snippets.concat"

# do we have -o?
if [ x${OUTFILE} = "x" ]; then
	echo "Please specify an output file with -o"
	exit 1
fi

# do we have -d?
if [ x${DIRPATH} = "x" ]; then
	echo "Please snippet directory with -p"
	exit 1
fi

# can we write to -o?
if [ -a ${TARGET} ]; then
	if [ ! -w ${TARGET} ]; then
		echo "Cannot write to ${TARGET}"
		exit 1
	fi
else
	if [ ! -w `dirname ${DIRPATH}}` ]; then
		echo "Cannot write to `dirname ${DIRPATH}` to create ${TARGET}}"
		exit 1
	fi
fi

# do we have a snippets subdir inside the work dir?
if [ ! -d "${SNIPPETS}" ]  && [ ! -x "${SNIPPETS}" ]; then
	echo "Cannot access the snippets directory"
fi

# find all the files in the snippets directory, sort them numerically and concat to snippets.concat in the working dir
find /tmp/test/fragment.snippets -type f |grep -v snippets.concat|sort |xargs cat > ${CONCAT}

if [ x${TEST} = "x" ]; then
	# This is a real run, copy the file to outfile
	/bin/cp ${CONCAT} ${TARGET}
	RETVAL=$?
else
	# Just compare the result to outfile to help the exec decide
	/usr/bin/cmp ${TARGET} ${CONCAT}
	RETVAL=$?
fi

exit $RETVAL
