class puppetlabs::wyrd::gearman {

  include nagios::params

  package { "$nagios_plugin_packages": ensure => installed; }


}
