class gpg {
  package { ["gnupg2", "gnupg-agent"]:
    ensure => present
  }
}
