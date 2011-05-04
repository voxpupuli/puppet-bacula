class virtual::nagioscontacts {

  @nagios_contactgroup { 'admins':
    alias => 'admins',
    #members => [ 'jamtur01', 'zach' ],
    members => 'jamtur01,zach,ben',
    ensure => present,
    target => '/etc/nagios3/conf.d/nagios_contactgroup.cfg',
  }

  @nagios_contact { 'jamtur01':
    alias => 'jamtur01',
    contact_name => 'jamtur01',
    email => 'james@puppetlabs.com',
    host_notification_commands => 'notify-host-by-email',
    service_notification_commands => 'notify-service-by-email',
    service_notification_period => '24x7',
    host_notification_period => '24x7',
    service_notification_options => 'w,u,c,r',
    host_notification_options => 'd,r',
    target => '/etc/nagios3/conf.d/nagios_contact.cfg',
    ensure => present,
  }

 @nagios_contact { 'zach':
    alias => 'zach',
    contact_name => 'zach',
    email => 'zach@puppetlabs.com',
    host_notification_commands => 'notify-host-by-email',
    service_notification_commands => 'notify-service-by-email',
    service_notification_period => '24x7',
    host_notification_period => '24x7',
    service_notification_options => 'w,u,c,r',
    host_notification_options => 'd,r',
    target => '/etc/nagios3/conf.d/nagios_contact.cfg',
    ensure => present,
  }

 @nagios_contact { 'ben':
    alias => 'ben',
    contact_name => 'ben',
    email => 'ben@puppetlabs.com',
    host_notification_commands => 'notify-host-by-email',
    service_notification_commands => 'notify-service-by-email',
    service_notification_period => '24x7',
    host_notification_period => '24x7',
    service_notification_options => 'w,u,c,r',
    host_notification_options => 'd,r',
    target => '/etc/nagios3/conf.d/nagios_contact.cfg',
    ensure => present,
  }

  @nagios_contact { 'teyo':
    alias => 'teyo',
    contact_name => 'teyo',
    email => 'teyo@puppetlabs.com',
    host_notification_commands => 'notify-host-by-email',
    service_notification_commands => 'notify-service-by-email',
    service_notification_period => '24x7',
    host_notification_period => '24x7',
    service_notification_options => 'w,u,c,r',
    host_notification_options => 'd,r',
    target => '/etc/nagios3/conf.d/nagios_contact.cfg',
    ensure => present,
  }
}
