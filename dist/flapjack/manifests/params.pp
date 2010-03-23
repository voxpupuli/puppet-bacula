# Class: flapjack::params
#
# This class configures Flapjack's parameters
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class flapjack::params {

  case $operatingsystem {
     "ubuntu": {
        $flapjack_admin_packages = [ "libxml2-dev", "libsqlite3-dev", "libxslt1-dev", "libopenssl-ruby" ]
     }
     "centos": {
     }
  }

}

