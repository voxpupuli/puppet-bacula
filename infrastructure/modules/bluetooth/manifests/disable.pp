# dont run bluetooth by default
class bluetooth::disable {
  service{"bluetooth":
    ensure => stopped,
    enable => false,
  }
}
