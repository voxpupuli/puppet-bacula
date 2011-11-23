class gpg::install {
  package { ["gnupg2", "gnupg-agent"]:
    ensure => present
  }
}
