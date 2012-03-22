node 'eternia' {
  include role::server
  include grayskull

  package{'postgres': ensure => installed }

}
