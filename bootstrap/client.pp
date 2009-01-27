#
# This is a simple puppet manifest that bootstraps the lab master.
# Some of this should probably be done in a package but chicken and eggs abound.
#
include puppet   
$ntphost = "ntp.endpoint.com"
exec { "set_time":
    path    => "/usr/sbin",
    command => "ntpdate -u $ntphost || ntpdate -u $ntphost",
} 
