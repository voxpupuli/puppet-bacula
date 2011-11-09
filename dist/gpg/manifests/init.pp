class gpg {
  package { ["gnupg", "gnupg-agent"]:
    ensure => present
  }
}
