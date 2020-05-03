# @summary Define a Bacula Messages
#
# Create a Messages resource on the $daemon (director, storage or file).
#
# @param append      Append the message to the filename given in the address field
# @param catalog     Send the message to the Catalog database
# @param console     Send the message to the Bacula console
# @param daemon      Daemon to add Messages resource to
# @param director    Send the message to the Director whose name is given in the address field
# @param mailcmd     Specify exactly how to send the mail
# @param mail        Send the message to the email addresses that are given as a comma separated list in the address field
# @param mname       The name of the Messages resource. The name you specify here will be used to tie this Messages resource to a Job and/or to the daemon
# @param operatorcmd This resource specification is similar to the MailCommand except that it is used for Operator messages
# @param operator    Send the message to the email addresses that are specified as a comma separated list in the address field
# @param syslog      Send the message to the system log (syslog) using the facility specified in the address field
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
