# sudo class
class sudo {

  include concat::setup

  if $operatingsystem != "Darwin" {
    package { "sudo": ensure => installed }
  }

  concat::fragment { 
    'sudoers-header':
      order   => '00',
      mode    => '0440',
      target  => '/tmp/sudoers',
      content => template("sudo/sudoers.erb"),
  }

  concat { '/tmp/sudoers':
    mode   => '0440',
    notify => Exec["check-sudoers"],
  }

  exec { "check-sudoers":
    command => $operatingsystem ? {
      freebsd => "/usr/local/sbin/visudo -cf /tmp/sudoers && cp /tmp/sudoers /usr/local/etc/sudoers",
      default => "/usr/sbin/visudo -cf /tmp/sudoers && cp /tmp/sudoers /etc/sudoers",
    },
    refreshonly => true,
  }

  file{ "/etc/sudoers": 
    owner => "root", 
    group => "root", 
    mode => "440",
  }

}
