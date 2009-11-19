class apache::ssl {
  include apache
  package{'mod_ssl':
    require => Package['httpd'],
  }
}
