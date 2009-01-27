#!/bin/sh

. ~interch/etc/server-list.sh
for i in $rodb_servers angelfire
do
	echo $i
	#scp /tmp/20080930-add-woot_displayed-to-READONLYDBs.sql $i:/tmp/
	#ssh $i "su - postgres -c 'psql -f /tmp/20080930-add-woot_displayed-to-READONLYDBs.sql bcs'"
	#scp /tmp/20080930-add-duration-to-woot-items-RODBS.sql $i:/tmp/
	ssh $i "psql -U bcs -f /tmp/20080930-add-duration-to-woot-items-RODBS.sql bcs"
	#echo 'select * from woot_displayed limit 1;' | ssh $i 'psql -U bcs bcs'
done
