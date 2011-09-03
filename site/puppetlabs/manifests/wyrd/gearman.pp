class puppetlabs::wyrd::gearman {

  include nagios::params

  package { $::nagios::params::nagios_plugin_packages: ensure => installed; }

}

