# Class: postfix
#
# This class installs and configures parameters for Postfix
#
# Parameters:
# rootmail = who you want root mail to go to.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postfix( $rootmail = 'root@puppetlabs.com' ) {

  include postfix::params

  package { $postfix::params::postfix_package:
    alias  => 'postfix',
    ensure => installed,
    notify => Service[$postfix::params::postfix_service],
  }

  service { $postfix::params::postfix_service:
    name       => 'postfix',
    ensure     => running,
    hasrestart => true,
    enable     => true,
    require => Package[$postfix::params::postfix_package],
  }

  file{ $postfix::params::postfix_maincf:
    owner   => 'root',
    mode    => '0644',
    content => template( $postfix::params::postfix_maincf_erb ),
    require => Package[$postfix::params::postfix_package],
    notify  => Service[$postfix::params::postfix_service],
  }


  # Sort out aliases and put it in a predictable location
  file{ $postfix::params::postfix_alias_files:
    owner   => $postfix::params::postfix_user,
    group   => $postfix::params::postfix_group,
    mode    => '0644',
    content => template( 'postfix/aliases' ),
    require => Package[$postfix::params::postfix_package],
    notify  => Exec['postfix_newaliases']
  }

  file{ '/etc/aliases':
    ensure  => link,
    target  => $postfix::params::postfix_alias_files,
    force   => true,
    require => File[ $postfix::params::postfix_alias_files ],
  }

  exec{ 'postfix_newaliases':
    command     => $postfix::params::postfix_newaliases,
    refreshonly => true,
    require     => [ Package[$postfix::params::postfix_package],
                     File[$postfix::params::postfix_alias_files] ],
  }

}
