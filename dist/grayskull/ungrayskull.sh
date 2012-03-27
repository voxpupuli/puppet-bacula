#!/bin/sh

JARFILE="~grayskull/grayskull-latest.jar"
USER="grayskull"
JARGS="-c ~grayskull/config.ini"

PATH="/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin"

set -e

if [ $# -lt 1 ]
then
	echo "Remove nodes from Grayskull."
	echo
	echo "$(basename $0) host1 [host2] [host4] [...]"
	exit 3
fi

if [ "$(id -u)" -ne 0 ]
then
	RUNWITH="sudo"
else
	RUNWITH=""
fi

${RUNWITH} su -l $USER -c "java -jar ${JARFILE} deactivate ${JARGS} $@"

exit $?
