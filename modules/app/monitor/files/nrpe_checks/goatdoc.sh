#!/bin/bash

HOSTNAME=`hostname -s`
BOX_MODEL=`dmidecode |grep 'Product Name'|head -n1|awk '{print $3,$4,$5,$6,$7,$8,$9,$10}'`
SERIAL=`dmidecode |grep 'Serial Number'|head -n1|awk '{print $3,$4,$5}'`
IFS=$'\x0a'
x=0;
for type in `free -g |grep -E 'Mem|Swap'`; do
	if [ $x -eq '0' ]; then 
	        MEM=`echo $type|awk '{print $2}'`Phy.;	
	else   
	        MEM=$MEM/`echo $type|awk '{print $2}'`Swap;	
	fi
	let x=($x+1);
done

x=1;
for int in `netstat -rn |awk '{print $8}' |grep eth|sort|uniq`; do
        hw=`/sbin/ifconfig $int |grep HWaddr|awk '{print $5}'`
        ip=`/sbin/ifconfig $int |grep 'inet addr:'|awk '{print $2}'| cut -d : -f 2`
	swport=`wget --no-check-certificate -qO- https://dash.backcountry.com/FesINV/?hostip=$ip`
        INTS="${INTS}${x}: $int::$ip - $hw - $swport<br>";
        let x=($x+1);
done

INTS="${INTS}'''GW: '''`/sbin/ip route show |grep default`"

let CPU_COUNT=(`cat /proc/cpuinfo |grep 'physical id'|tail -n 1|awk '{print $4}'`+1)
CPU_COUNT=$CPU_COUNT"x`cat /proc/cpuinfo |grep 'model name'|tail -n 1|awk '{print $4,$5,$6,$7,$8,$9,$10}'` @ `cat /proc/cpuinfo |grep 'cpu MHz'|tail -n 1 |awk '{print $4}'` MHz";
OS=`cat /etc/redhat-release`
UPTIME=`uptime |awk '{print $3,$4,$5}'`
DISKSPACE=`df -h / |tail -n 1|awk '{print $3,"Avail.",($4),"on",$5}'`
HOST_CACTI_ID=`wget --no-check-certificate -qO- https://cacti.backcountry.com/server_id.php?host=$HOSTNAME`
HOST_CACTI_CPU_ID=`wget --no-check-certificate -qO- https://cacti.backcountry.com/get_cpu_graph.php?id=$HOST_CACTI_ID`

echo "{{Server 
| ServerName = $HOSTNAME 
| ServerLocation = ViaWest
| ServerModel = $BOX_MODEL::S/N: $SERIAL
| ServerUptime = $UPTIME
| ServerAlias = `hostname`  
| ServerCPUInfo = $CPU_COUNT
| ServerOS = $OS
| ServerRAM = $MEM
| ServerHD = $DISKSPACE
| ServerIPInfo = $INTS
| ServerDescr = 
| ServerGroups = 
| ServerEscInfo = 
| ServerCactiID = $HOST_CACTI_ID
| CactiLoadID = $HOST_CACTI_CPU_ID 
}}
";
