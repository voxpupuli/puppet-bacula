class postfix::params {

  case $operatingsystem {
    'debian','ubuntu': {
      $postfix_package = 'postfix'
      $postfix_service = 'postfix'
      $postfix_alias_files = '/etc/postfix/aliases'
      $postfix_newaliases  = '/usr/bin/newaliases'
      $postfix_maincf = '/etc/postfix/main.cf'
      $postfix_maincf_erb = 'postfix/main.cf.debian.erb'
    }
    'freebsd': {
      $postfix_package = 'mail/postfix'
      $postfix_service = 'postfix'
      $postfix_alias_files = '/etc/mail/aliases'
      $postfix_newaliases  = '/usr/local/bin/newaliases'
      $postfix_maincf = '/usr/local/etc/postfix/main.cf'
      $postfix_maincf_erb = 'postfix/main.cf.freebsd.erb'
    }
    default: {
      fail("Please check ${module_name} for this OS.")
    }
  }
}
