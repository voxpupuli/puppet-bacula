class account::master {
  File { mode => '0755', owner => 'root', group => 'root' }
  file {
    '/usr/local/bin/setpass.rb': source => 'puppet:///modules/account/setpass.rb';
    '/etc/puppet/userpw': recurse => true, mode => '0600';
  }
  package {'mkpasswd': ensure => installed, }
}
