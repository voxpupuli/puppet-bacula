class php{
  package{'php':}
  package{'php-pdo':
    require => Package['php'],
  }
}
