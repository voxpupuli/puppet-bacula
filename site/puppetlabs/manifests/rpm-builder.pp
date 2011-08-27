class puppetlabs::rpm-builder {
  ssh::allowgroup  { "release": }
  ssh::allowgroup  { "builder": }

  sudo::allowgroup { "release": }
  sudo::allowgroup { "builder": }

  class { "nagios": nrpe_server => '173.255.196.32'; }
}

