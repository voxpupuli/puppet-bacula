# Class: nagios
#
# This class installs and configures Nagios
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nagios {
  include nagios::params

  Package{
    ensure  => installed,
  }
  package { "nagios-plugins":
  }
  package {[ "nagios-moreplugs",
	     # allow for restarting of services via eventhandlers
             "nagios-eventhandlers",
	     "nagios-plugins-filerc",
	     # Empowering Media's TCP port monitoring
             "nagios-plugins-ports",
	     # Empowering Media's TCP rouge process monitoring
	     "nagios-plugins-rogue",
	     "perl-Nagios-Plugin",
	     "perl-Config-Tiny",
            ]:
    require => Package["nagios-plugins",
  }
  package { "nagios-of-plugins":
    require => [ Package["perl-Config-Tiny"], 
                 Package["perl-Nagios-Plugin"], 
               ],
  }
  File{
    ensure   => present,
    replace  => true,
    owner    => 'root',
    group    => 'nagios',
    mode     => '0550',
    require  => Package["nagios-plugins"],
  }
  # track check_iptables
  file { "check_iptables":
    name  => "/usr/${libfolder}/nagios/plugins/check_iptables",
    replace    => true,
    mode       => '0550',
    source     => "puppet:///nagios/check_iptables.sh",
  }
  # track check_clamav
  file { "check_clamav":
    name   => "/usr/${libfolder}/nagios/plugins/check_clamav",
    source => "puppet:///nagios/check_clamav.sh",
  }
  # track check_memory
  file { "check_memory":
    name   => "/usr/${libfolder}/nagios/plugins/check_memory",
    source => "puppet:///nagios/check_memory.pl",
  }
  # track check_replication
  file { "check_replication.pl":
    name   => "/usr/${libfolder}/nagios/plugins/check_replication.pl",
    source => "puppet:///nagios/check_replication.pl",
  }
  file { "check_replication.sh":
    name   => "/usr/${libfolder}/nagios/plugins/check_replication.sh",
    source => "puppet:///nagios/check_replication.sh",
  }
}
