class postfix::params {

  case $operatingsystem {
    'debian','ubuntu': {
      $postfix_package = 'postfix'
      $postfix_service = 'postfix'
      $postfix_alias_files = '/etc/postfix/aliases'
      $postfix_newaliases  = '/usr/bin/newaliases'
      $postfix_maincf = '/etc/postfix/main.cf'
      $postfix_maincf_erb = 'postfix/main.cf.debian.erb'
      $ssl_certs = '/etc/ssl/certs/ca-certificates.crt'
    }
    'freebsd': {
      $postfix_package = 'mail/postfix'
      $postfix_service = 'postfix'
      $postfix_alias_files = '/etc/mail/aliases'
      $postfix_newaliases  = '/usr/local/bin/newaliases'
      $postfix_maincf = '/usr/local/etc/postfix/main.cf'
      $postfix_maincf_erb = 'postfix/main.cf.freebsd.erb'
      $ssl_certs = '/usr/local/share/certs/ca-root-nss.crt'
    }
    'fedora','redhat','centos': {
      $postfix_package = 'postfix'
      $postfix_service = 'postfix'
      $postfix_alias_files = '/etc/postfix/aliases'
      $postfix_newaliases  = '/usr/bin/newaliases'
      $postfix_maincf = '/etc/postfix/main.cf'
      $postfix_maincf_erb = 'postfix/main.cf.centos.erb'
      $ssl_certs = '/etc/pki/tls/certs/ca-bundle.crt'
    }
    default: {
      fail("Please check ${module_name} for this OS.")
    }
  }
}
