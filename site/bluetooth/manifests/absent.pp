# dont run bluetooth by default
class bluetooth::absent {
  Package{ensure => absent}
  package {['bluez-utils', 'bluez-gnome']:}
  package {'bluez-libs':
    require => [Package['bluez-utils']],
   }
}
