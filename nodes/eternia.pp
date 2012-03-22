node eternia {
  include role::server
  include grayskull

  package{'postgresql': ensure => installed }

}
