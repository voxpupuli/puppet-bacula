#! /bin/bash

user=<%= user %>
group=<%= group %>
dir=<%= dir %>
name=<%= name %>

/usr/bin/find ${dir}/${name}/files ${dir}/${name}/tmp -exec chown $user:$group {} \; 
/usr/bin/find ${dir}/${name}/files ${dir}/${name}/tmp -exec chmod 755 {} \;
/usr/bin/find ${dir}/${name}/public ${dir}/${name}/log -exec chown $user:$group {} \; 
/usr/bin/find ${dir}/${name}/public ${dir}/${name}/log -exec chmod 755 {} \;

