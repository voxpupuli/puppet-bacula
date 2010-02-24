#!/bin/bash

IPTABLES=iptables
IPTABLES_DATA=/etc/sysconfig/$IPTABLES
IPTABLES_CONFIG=/etc/sysconfig/${IPTABLES}-config
IPV=${IPTABLES%tables} # ip for ipv4 | ip6 for ipv6
PROC_IPTABLES_NAMES=/proc/net/${IPV}_tables_names
VAR_SUBSYS_IPTABLES=/var/lock/subsys/$IPTABLES

# Check if iptable module is loaded
if [ ! -f "$VAR_SUBSYS_IPTABLES" ]; then
	echo $"CRITICAL - Firewall is not running"
	exit 2
fi

# Check if firewall is configured (has tables)
if [ ! -e "$PROC_IPTABLES_NAMES" ]; then
	echo $"CRITICAL - Firewall is not configured"
	exit 2
fi
tables=`cat $PROC_IPTABLES_NAMES 2>/dev/null`
if [ -z "$tables" ]; then
        echo $"CRITICAL - Firewall is not configured"
        exit 2
fi

# else everything is ok
echo $"OK - Firewall is running"
exit 0
