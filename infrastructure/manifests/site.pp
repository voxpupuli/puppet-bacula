$cacti_password='password'
$mysql_rootpw = 'password'
$mysql_monitor_username = 'user'
$mysql_monitor_password = 'password'
$mysql_monitor_hostname = 'localhost'
# disable some stuff
include avahi::disable
      , bluetooth::disable 
      , cups::disable
      , hal::disable
# configure some stuff
include git
#      , cacti
      , apache::ssl
#     , bind::server # does not work
      , motd
      , php
      , ruby
      , vim
      , dbus
      , yum
#$my_admins =['dan', 'teyo', 'luke']
