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
  Optional[String]        $append      = undef,
  Optional[String]        $catalog     = undef,
  Optional[String]        $console     = undef,
  Enum['dir', 'fd', 'sd'] $daemon      = 'dir',
  Optional[String]        $director    = undef,
  Optional[String]        $mailcmd     = undef,
  Optional[String]        $mail        = undef,
  String                  $mname       = 'Standard',
  Optional[String]        $operatorcmd = undef,
  Optional[String]        $operator    = undef,
  Optional[String]        $syslog      = undef,
) {
  include bacula
  include bacula::common

  $epp_messages_variables = {
    mname       => $mname,
    director    => $director,
    append      => $append,
    syslog      => $syslog,
    catalog     => $catalog,
    console     => $console,
    mailcmd     => $mailcmd,
    mail        => $mail,
    operator    => $operator,
    operatorcmd => $operatorcmd,
  }

  concat::fragment { "bacula-messages-${daemon}-${name}":
    target  => "${bacula::conf_dir}/bacula-${daemon}.conf",
    content => epp('bacula/messages.epp', $epp_messages_variables),
  }
}
