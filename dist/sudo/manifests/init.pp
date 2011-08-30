# sudo class
class sudo {

  include concat::setup
  include sudo::params
  $visudo_cmd   = $::sudo::params::visudo_cmd
  $sudoers_file = $::sudo::params::sudoers_file
  $sudoers_tmp  = $::sudo::params::sudoers_tmp

  if $operatingsystem != "Darwin" {
    package { "sudo": ensure => installed }
  }

  concat::fragment {
    'sudoers-header':
      order   => '00',
      mode    => '0440',
      target  => $sudoers_tmp,
      content => template("sudo/sudoers.erb"),
  }

  concat { $sudoers_tmp:
    mode   => '0440',
    notify => Exec["check-sudoers"],
  }

  exec { "check-sudoers":
    command     => "$::sudo::params::visudo_cmd -cf $sudoers_tmp && cp $sudoers_tmp $sudoers_file",
    refreshonly => true,
  }

  file{ "$sudoers_file":
    owner => "root",
    group => "0",
    mode  => "440",
  }

}

