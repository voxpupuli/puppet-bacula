class duplicity::ssh_server {

  ssh::allowgroup {"backupusers": }
  Account::User <| tag == 'backupusers' |>
}
