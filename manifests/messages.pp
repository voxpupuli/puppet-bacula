# Create a Messages resource on the $daemon (director, storage or file).
#
# @param append
# @param catalog
# @param console
# @param daemon
# @param director
# @param mailcmd
# @param mail
# @param mname
# @param operatorcmd
# @param operator
# @param syslog
#
define bacula::messages (
  $append      = undef,
  $catalog     = undef,
  $console     = undef,
  $daemon      = 'dir',
  $director    = undef,
  $mailcmd     = undef,
  $mail        = undef,
  $mname       = 'Standard',
  $operatorcmd = undef,
  $operator    = undef,
  $syslog      = undef,
) {
  validate_re($daemon, ['^dir', '^sd', '^fd'])

  include ::bacula
  include ::bacula::common

  concat::fragment { "bacula-messages-${daemon}-${name}":
    target  => "${bacula::conf_dir}/bacula-${daemon}.conf",
    content => template('bacula/messages.erb'),
  }
}
