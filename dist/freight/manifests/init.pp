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
class freight (
  $freight_vhost_name,
  $freight_docroot,
  $freight_gpgkey,
  $freight_group,
  $freight_libdir,
  $freight_manage_docroot = true,
  $freight_manage_libdir = true,
  $freight_manage_vhost = true,
  $freight_manage_ssl_vhost = false
) {
  include apache

  package { 'freight':
    ensure  => present,
    require => Apt::Source["rcrowley.list"],
  }

  if ($freight_manage_docroot) {
    file { $freight_docroot:
      ensure    => directory,
      group     => $freight_group,
      require   => Group[$freight_group],
      mode      => "2775",
    }
  }

  if ($freight_manage_libdir) {
    file { $freight_libdir:
      ensure    => directory,
      group     => $freight_group,
      require   => Group[$freight_group],
      mode      => "2775",
    }
  }

  file { '/etc/freight.conf':
    ensure    => present,
    content   => template('freight/freight.conf.erb'),
    require   => Package['freight'],
  }

  if ($freight_manage_vhost) {
    apache::vhost { $freight_vhost_name:
      servername  => $freight_vhost_name,
      priority    => '10',
      port        => '80',
      ssl         => false,
      docroot     => $freight_docroot,
      require     => File[$freight_docroot],
      template    => 'freight/apache2.conf.erb',
    }

    if ($freight_manage_ssl_vhost == true ) {

      include puppetlabs_ssl

      apache::vhost { "${freight_vhost_name}_ssl":
        servername  => $freight_vhost_name,
        priority    => '11',
        port        => '443',
        ssl         => true,
        docroot     => $freight_docroot,
        require     => File[$freight_docroot],
        template    => 'freight/apache2.conf.erb',
      }
    }

    # We need mod_rewrite for freight.
    realize(A2mod['rewrite'])
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

  gpg::agent { "root":
    options => [
      "--default-cache-ttl 999999999",
      "--max-cache-ttl     999999999",
      "--use-standard-socket",
    ],
  }
}

