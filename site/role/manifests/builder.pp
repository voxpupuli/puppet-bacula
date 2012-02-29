class role::builder {

  class { "role::server": nagios => false; }

  Account::User      <| title == 'jenkins' |>
  Ssh_authorized_key <| user  == 'jenkins' |>

  ssh::allowgroup  { ['release', 'builder', 'jenkins' ]: }
  ssh::allowgroup  { ['release', 'builder', 'jenkins' ]: }

}
