# Class: puppetlabs_ssl
#
# This class installs the Puppet Labs SSL certificates
#
# Parameters:
#
# Actions:
# - Installs the Puppet Labs certificates
#
# Requires:
#
# Sample Usage:
#
class puppetlabs_ssl {

  include puppetlabs_ssl::params

  # XXX Currently this fails miserably in non-production environments, so
  # only enabling it when it won't throw errors constantly
  if $environment == "production" {

    $ssl_path = $puppetlabs_ssl::params::ssl_path

    file {
      "$ssl_path/certs":
        ensure => directory,
        mode => 0755,
        owner => 'root',
        group => 'root';
      "$ssl_path/certs/pl.cert":
        source => "puppet:///modules/puppetlabs_ssl/pl.cert",
        mode => 0644,
        owner => 'root',
        group => 'root';
      "$ssl_path/certs/ca.cert":
        source => "puppet:///modules/puppetlabs_ssl/ca.cert",
        mode => 0644,
        owner => 'root',
        group => 'root';
      "$ssl_path/private":
        ensure => directory,
        mode => 0600,
        owner => 'root',
        group => 'root';
      "$ssl_path/private/pl.key":
        source => "puppet:///modules/puppetlabs_ssl/pl.key",
        mode => 0400,
        owner => 'root',
        group => 'root';
    }
  }
  else {
    notify { "puppetlabs_ssl only works in production, currently using $environment so not applying": }
  }
}
