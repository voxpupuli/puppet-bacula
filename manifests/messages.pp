# == Define: bacula::messages
#
# Create a Messages resource on the $daemon (director, storage or file).
#
define bacula::messages (
  $mname       = 'Standard',
  $daemon      = 'dir',
  $director    = undef,
  $append      = undef,
  $catalog     = undef,
  $syslog      = undef,
  $console     = undef,
  $mail        = undef,
  $operator    = undef,
  $mailcmd     = undef,
  $operatorcmd = undef,
) {
  validate_re($daemon, ['^dir', '^sd', '^fd'])

  include bacula::common
  include bacula::params

  concat::fragment { "bacula-messages-${daemon}-${name}":
    target  => "${bacula::params::conf_dir}/bacula-${daemon}.conf",
    content => template('bacula/messages.erb'),
  }
}
