class apache::ssl {
  include apache
  package{'mod_ssl':
    requre => Package['httpd'],
  }
}
