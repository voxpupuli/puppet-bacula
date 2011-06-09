class jenkins::slave {
  include jenkins::params

  ssh::allowgroup { "hudson": }
  sudo::allowgroup { "hudson": }

  Account::User <| tag == 'hudson' |>
  Group <| tag == 'hudson' |>

  package { $jenkins::params::slave_packages: 
    ensure => installed,
  }

}
