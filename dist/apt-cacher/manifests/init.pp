class apt-cacher (
    $service = true
  ) {

  package {
    "apt-cacher-ng": ensure => installed;
  }

  if $service == true { 
    service {
      "apt-cacher-ng":
        enable    => true,
        ensure    => running,
        hasstatus => false,
        pattern   => "apt-cacher-ng",
        require   => Package['apt-cacher-ng'],
    }
  }

}
