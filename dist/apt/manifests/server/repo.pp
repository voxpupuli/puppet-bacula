# Class: apt::server::repo
#
# This class installs and configures a local APT repo
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class apt::server::repo (
    $base_location = '/opt/repository/apt',
    $site_name = $fqdn
  ) {

  package { 'reprepro': ensure => present; }

  File { owner => 'root', group => 'release', mode => 664 }

  file { $base_location: ensure => directory; }

  # Debian
  file {
    "$base_location/debian":
      ensure => directory;
    "$base_location/debian/conf":
      ensure => directory,
      require => File["$base_location/debian"];
    "$base_location/debian/override":
      ensure => directory,
      require => File["$base_location/debian"];
    "$base_location/debian/incoming":
      ensure => directory,
      require => File["$base_location/debian"];

    "$base_location/debian/conf/incoming":
      content => template("apt/debian_incoming"),
      require => File["$base_location/debian"];
    "$base_location/debian/conf/distributions":
      source => 'puppet:///modules/apt/debian_distributions',
      require => File["$base_location/debian/conf"];
    "$base_location/debian/conf/options":
      source => 'puppet:///modules/apt/options',
      require => File["$base_location/debian/conf"];
  }

  # Ubuntu
  file {
    "$base_location/ubuntu":
      ensure => directory;
    "$base_location/ubuntu/conf":
      ensure => directory,
      require => File["$base_location/ubuntu"];
    "$base_location/ubuntu/override":
      ensure => directory,
      require => File["$base_location/ubuntu"];
    "$base_location/ubuntu/incoming":
      ensure => directory,
      require => File["$base_location/ubuntu"];

    "$base_location/ubuntu/conf/incoming":
      content => template("apt/ubuntu_incoming"),
      require => File["$base_location/ubuntu"];
    "$base_location/ubuntu/conf/distributions":
      source => 'puppet:///modules/apt/ubuntu_distributions',
      require => File["$base_location/ubuntu/conf"];
    "$base_location/ubuntu/conf/options":
      source => 'puppet:///modules/apt/options',
      require => File["$base_location/ubuntu/conf"];
  }

  apache::vhost {
    "$site_name":
      priority => '10',
      port     => '80',
      docroot  => "$base_location",
      template => 'apt/apache2.conf.erb'
  }

}

