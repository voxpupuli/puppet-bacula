# Class: server::debian
#
#   class description goes here.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class server::debian {

  # daemon name
  $nsdname = 'nsd3'

  package{ $nsdname:
    ensure => present,
  }

  service{ $nsdname:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['nsd3'],
  }

  #file{ [ 'somefiles']:
  #}
}
