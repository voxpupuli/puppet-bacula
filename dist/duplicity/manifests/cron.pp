define duplicity::cron(
  $ensure = "present",
  $quiet  = "true",
  $user,
  $target,
  $gpg_agent_info,
  $options = []
) {

  include duplicity::client

  $duplicity_command = inline_template("/usr/bin/duplicity <%= options.join(' ') %> ${name} ${target} <% quiet == 'true' and puts '1>/dev/null 2>/dev/null' %> ")
  $environment_command = "source ${gpg_agent_info}; export GPG_AGENT_INFO;"
  $command = "/bin/bash -c '${environment_command} ${duplicity_command}'"

  cron { "Duplicity backup of ${name}":
    ensure  => $ensure,
    command => $command,
    user    => $user,
    hour    => 0,
    minute  => 0,
    environment => [ "MAILTO=root" ],
  }
}
