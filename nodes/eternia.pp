node eternia {
  include role::server
  include grayskull

  include rsyslog::listenonudp  # for log4j in grayskull

  package{'postgresql': ensure => installed }

}
