class rack {
  package{'rack':
    ensure => installed,
    provider => 'gem',
  }
}
