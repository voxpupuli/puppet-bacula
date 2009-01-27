#!/bin/bash

for myfile in /var/lib/interchange/ctier/torrents/* 
do
        if [ $1 = 'client' ] 
        then
                #ON CLIENT (IE blades)
                bittorrent-console --display_interval 28800 --check_hashes --max_upload_rate 0 --upnp --save_in /var/www/html/images/items $myfile &
        else
                #ON CHIRRIPO (IE standby)
                bittorrent-console --display_interval 28800 --no_check_hashes --max_upload_rate 0 --upnp --save_in /var/www/html/images/items $myfile & 
        fi
done
