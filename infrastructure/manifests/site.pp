# disable some stuff
include avahi::disable
      , bluetooth::disable 
      , cups::disable
      , hal::disable
# configure some stuff
include git
      , apache:ssl
#     , bind::server # does not work
      , motd
      , php
      , ruby
      , vim
$my_admins =['dan', 'teyo', 'luke']
