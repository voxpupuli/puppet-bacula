#! /bin/bash

user=<%= user %>
group=<%= group %>
dir=<%= approot %>
name=<%= name %>
p="${dir}/${name}"

chown -R $user:$group "${p}/log/" "${p}/public/" "${p}/tmp/" "${p}/files/" 
/usr/bin/find "${p}/log/" "${p}/public/" "${p}/tmp/" "${p}/files/" -type f -exec chmod 644 {} \;
/usr/bin/find "${p}/log/" "${p}/public/" "${p}/tmp/" "${p}/files/" -type d -exec chmod 755 {} \;

chmod 755 ${dir}/${name}/public/dispatch.*
