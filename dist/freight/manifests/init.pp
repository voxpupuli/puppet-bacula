# Class: freight
#
# This class installs and configures a local APT repo using freight
#
# Parameters:
# - The $freight_vhost_name choses a virtual host name for the repo
# - The $freight_docroot chooses a docroot to serve the repo out of
#     (used for the vhost and for freight config)
# - The $freight_gpgkey is the gpg key used to sign the repository
# - The $freight_group is used to define the group for the docroot and libdir
# - The $freight_libdir is where the freight stores the debs, before
#     hard-linking them into the vhost docroot
#
# Actions:
# - Install appropriate apache vhost for freight instance
# - Add rcrowley's repository key so freight can be apt-installed
# - Install, configure and setup freight instance
# - Installs gpg-agent for signing packages
#
# Requires:
# - The apache class and vhost definition
#
# Sample Usage:
#   class { 'freight':
#     freight_vhost_name  => 'freight.somewhere.com',
#     freight_docroot     => '/var/www/html',
#     freight_gpgkey      => 'me@somewhere.com',
#     freight_group       => 'release',
#     freight_libdir      => '/var/lib/freight',
#   }
#
class freight ($freight_vhost_name, $freight_docroot, $freight_gpgkey, $freight_group, $freight_libdir, $freight_manage_dirs = true) {
  include apache

  package { 'freight':
    ensure  => present,
    require => Apt::Source["rcrowley.list"],
  }

  if ! defined(Package["gnupg-agent"]) {
    package { 'gnupg-agent':
      ensure  => present,
    }
  }

  if ($freight_manage_dirs) {
    file { [$freight_docroot, $freight_libdir]:
      ensure    => directory,
      group     => $freight_group,
      require   => Group[$freight_group],
    }
  }

  file { '/etc/freight.conf':
    ensure    => present,
    content   => template('freight/freight.conf.erb'),
    require   => Package['freight'],
  }

  apache::vhost { "${freight_vhost_name}-the-sequel":
    servername  => $freight_vhost_name,
    priority    => '10',
    port        => '80',
    docroot     => $freight_docroot,
    require     => File[$freight_docroot],
  }

  apt::source { "rcrowley.list":
    uri           => "http://packages.rcrowley.org/",
    require       => Exec["rcrowley_key"],
  }

  exec { "import rcrowley apt key":
    user    => root,
    alias   => "rcrowley_key",
    command => "/usr/bin/wget -q -O - http://packages.rcrowley.org/pubkey.gpg | apt-key add -",
    unless  => "/usr/bin/apt-key list | grep -q 7DF49CEF",
    before  => Exec["apt-get update"];
  }

  exec { "start gpg-agent":
    user      => root,
    alias     => "gpg-exec",
    command   => "/bin/bash -c 'eval \$(gpg-agent --daemon)'",
    unless    => "/usr/bin/pgrep -u root gpg-agent",
    require   => Package["gnupg-agent"],
  }
}

