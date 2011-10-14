class motd::params {
  case $operatingsystem {
    'debian','ubuntu': { $motd = '/var/run/motd' }
    default: { $motd = '/etc/motd' }
  }
}
