#!/bin/bash
#
#!
#! PROD WEBAPP SERVER IDS:
#!       range is from 1024-2047!!
#!
#!       FREEABLE:
#!               DeCOM 2007 server real breckenridge 10.40.16.118
#!               sessiondb 2010 server real stowe 10.40.16.116
#!               DeCOM 2042 server real bristol 10.40.16.51
#!               sessiondb 2016 server real telluride 10.40.16.111
#!
#!
#!
#!       1050 server real hoodoo 10.40.16.61
#!       1055 server real nordic 10.40.16.64
#!       2001 server real banff 10.40.16.103
#!       2002 server real arapahoe 10.40.16.88
#!       2003 server real powder 10.40.16.168
#!       2004 server real brighton 10.40.16.110
#!       2005 server real mammoth 10.40.16.113
#!       2013 server real snowbird 10.40.16.104
#!       2014 server real solitude 10.40.16.105
#!       2015 server real taos 10.40.16.107
#!       2017 server real teton 10.40.16.102
#!       2019 server real whistler 10.40.16.108
#!       2020 server real whitewater 10.40.16.109
#!       2022 server real squaw 10.40.16.114
#!       2039 server real brianhead 10.40.16.57
#!       2040 server real wolfmtn 10.40.16.49
#!       2041 server real arrowhead 10.40.16.48
#!       2043 server real snowshoe 10.40.16.42
#!       2044 server real durango 10.40.16.43
#!       2045 server real cuchara 10.40.16.44
#!       2046 server real beavermtn 10.40.16.46
#!       2047 server real copper 10.40.16.56
#!
#

for port in `seq 80 95` 98 99 ; do echo "port $port server-id $1"; echo "port $port group-id 1 1"; done
