# to make it easier to grab the neede package one-offs

class packages::shells {

  @package { "zsh":  ensure => installed; }
  @package { "bash": ensure => installed; }

}
