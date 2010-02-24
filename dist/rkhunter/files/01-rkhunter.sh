#!/bin/sh
/bin/nice -n 19 /usr/local/bin/rkhunter --cronjob --pkgmgr RPM --update --rwo | /usr/bin/logger -p authpriv.notice -t `/bin/hostname -s`" Rootkit Hunter"
exit 0
