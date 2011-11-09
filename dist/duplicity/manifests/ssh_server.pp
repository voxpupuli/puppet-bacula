class duplicity::ssh_server {

  include duplicity::params

  file { $duplicity::params::droproot:
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode   => "0755",
  }

  ssh::allowgroup { "backupusers": }
  Account::User <| tag == 'backupusers' |>
}
