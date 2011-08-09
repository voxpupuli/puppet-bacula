class nagios::pagerduty {

  $api_key = '9eff325092fc012ebc8412313d009e57'

  # pagerduty script dependencies
  package { ["libwww-perl", "libcrypt-ssleay-perl"]:
    ensure => present,
  }
  
  file { "/usr/local/bin/pagerduty_nagios.pl":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "0755",
    source  => "puppet:///modules/nagios/pagerduty_nagios.pl",
    require =>  Package["libwww-perl", "libcrypt-ssleay-perl"],
  }

  @nagios_contact { "pagerduty":
    ensure => present,
    alias  => "PagerDuty Pseudo-Contact",
    service_notification_period   => "24x7",
    host_notification_period      => "24x7",
    service_notification_options  => "w,u,c,r",
    host_notification_options     => "d,r",
    service_notification_commands => "notify-service-by-pagerduty",
    host_notification_commands    => "notify-host-by-pagerduty",
    target                        => '/etc/nagios3/conf.d/nagios_contact.cfg',
    pager                         => $service_key,
  }

  nagios_command { "notify-service-by-pagerduty":
    ensure       => present,
    command_name => "notify-service-by-pagerduty":
    command_line => "/usr/local/bin/pagerduty_nagios.pl enqueue -f pd_nagios_object=service",
    target       => '/etc/nagios/conf.d/nagios_commands.cfg',
    notify       => Service[$nagios::params::nagios_service],
  }


  nagios_command { "notify-host-by-pagerduty":
    command_name => "notify-host-by-pagerduty",
    command_line => "/usr/local/bin/pagerduty_nagios.pl enqueue -f pd_nagios_object=host",
  }

  cron { "pagerduty cron":
    command => "/usr/local/bin/pagerduty_nagios.pl flush",
    require => File["/usr/local/bin/pagerdity_nagios.pl"],
  }
}
