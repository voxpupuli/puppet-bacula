define duplicity::cron(
  $ensure = "present",
  $mailto = "",
  $user,
  $target,
  $home,
  $options = []
) {

  include duplicity::install

  $gpg_agent_info = "${home}/.gpg_agent-info"
  $lastrun        = "${home}/.lastrun"

  $duplicity_command = inline_template("/usr/bin/duplicity <%= options.join(' ') %> ${name} ${target}")
  $environment_command = "source ${gpg_agent_info}; export GPG_AGENT_INFO;"
  $command = "/bin/bash -c '${environment_command} ${duplicity_command}' && touch ${lastrun}"

  cron { "Duplicity backup of ${name}":
    ensure  => $ensure,
    command => $command,
    user    => $user,
    hour    => 0,
    minute  => 0,
    environment => [ "MAILTO=$mailto" ],
  }

  @@nagios_service { "duplicity_${name}_${hostname}":
    use                      => 'generic-service',
    host_name                => $fqdn,
    check_command            => "check_nrpe!check_file_age 86400 172800 ${lastrun}"
    service_description      => "check_duplicity-${name}-${hostname}",
    first_notification_delay => '120',
    target                   => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify                   => Service[$nagios::params::nagios_service],
  }
}
