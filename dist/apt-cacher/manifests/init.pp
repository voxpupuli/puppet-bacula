class apt-cacher {

  package {
    "apt-cacher-ng": ensure => installed;
  }

  service {
    "apt-cacher-ng":
      enable  => true,
      ensure  => running,
      pattern => "apt-cacher-ng",
      require => Package['apt-cacher-ng'],
  }

}
