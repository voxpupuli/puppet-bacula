class php{
  package{'php':
    ensure => installed,
  }
  package{'php-pdo':
    ensure  => installed,
    require => Package['php'],
  }
}
