# @summary Define a Bacula Messages
#
# Create a Messages resource on the $daemon (director, storage or file).
#
# @param append           Append the message to the filename given in the address field
# @param catalog          Send the message to the Catalog database
# @param console          Send the message to the Bacula console
# @param daemon           Daemon to add Messages resource to
# @param director         Send the message to the Director whose name is given in the address field
# @param mailcmd          Specify exactly how to send the mail
# @param mail             Send the message to the email addresses that are given as a comma separated list in the address field
# @param mailonerrorcmd   Specify exactly how to send error mail
# @param mailonerror      Send the error message to the email addresses that are given as a comma separated list in the address field
# @param mailonsuccesscmd Specify exactly how to send success mail
# @param mailonsuccess    Send the success message to the email addresses that are given as a comma separated list in the address field
# @param mname            The name of the Messages resource. The name you specify here will be used to tie this Messages resource to a Job and/or to the daemon
# @param operatorcmd      This resource specification is similar to the MailCommand except that it is used for Operator messages
# @param operator         Send the message to the email addresses that are specified as a comma separated list in the address field
# @param syslog           Send the message to the system log (syslog) using the facility specified in the address field
#
define bacula::messages (
  Optional[String[1]]     $append           = undef,
  Optional[String[1]]     $catalog          = undef,
  Optional[String[1]]     $console          = undef,
  Enum['dir', 'fd', 'sd'] $daemon           = 'dir',
  Optional[String[1]]     $director         = undef,
  Optional[String[1]]     $mailcmd          = undef,
  Optional[String[1]]     $mail             = undef,
  Optional[String[1]]     $mailonerrorcmd   = undef,
  Optional[String[1]]     $mailonerror      = undef,
  Optional[String[1]]     $mailonsuccesscmd = undef,
  Optional[String[1]]     $mailonsuccess    = undef,
  String[1]               $mname            = 'Standard',
  Optional[String[1]]     $operatorcmd      = undef,
  Optional[String[1]]     $operator         = undef,
  Optional[String[1]]     $syslog           = undef,
) {
  include bacula
  include bacula::common

  $epp_messages_variables = {
    mname            => $mname,
    director         => $director,
    append           => $append,
    syslog           => $syslog,
    catalog          => $catalog,
    console          => $console,
    mailcmd          => $mailcmd,
    mail             => $mail,
    mailonerrorcmd   => $mailonerrorcmd,
    mailonerror      => $mailonerror,
    mailonsuccesscmd => $mailonsuccesscmd,
    mailonsuccess    => $mailonsuccess,
    operator         => $operator,
    operatorcmd      => $operatorcmd,
  }

  concat::fragment { "bacula-messages-${daemon}-${name}":
    target  => "${bacula::conf_dir}/bacula-${daemon}.conf",
    content => epp('bacula/messages.epp', $epp_messages_variables),
  }
}
