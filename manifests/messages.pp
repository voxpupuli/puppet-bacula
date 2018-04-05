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
  Optional[String] $append      = undef,
  Optional[String] $catalog     = undef,
  Optional[String] $console     = undef,
  String           $daemon      = 'dir',
  Optional[String] $director    = undef,
  Optional[String] $mailcmd     = undef,
  Optional[String] $mail        = undef,
  String           $mname       = 'Standard',
  Optional[String] $operatorcmd = undef,
  Optional[String] $operator    = undef,
  Optional[String] $syslog      = undef,
) {
  validate_re($daemon, ['^dir', '^sd', '^fd'])

  include ::bacula
  include ::bacula::common

  concat::fragment { "bacula-messages-${daemon}-${name}":
    target  => "${bacula::conf_dir}/bacula-${daemon}.conf",
    content => template('bacula/messages.erb'),
  }
}
