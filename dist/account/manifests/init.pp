class account {
  resources { user: purge => true, noop => true }
  file {'/usr/local/bin/setpass.rb':
    source => 'puppet:///modules/account/setpass.rb',
    mode => '0755',
    owner => 'root',
    group => 'root',
  }
}
