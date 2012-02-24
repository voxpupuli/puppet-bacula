define duplicity::cron(
  $ensure = "present",
  $mailto = "",
  $user,
  $target,
  $home,
  $options = []
) {

  include duplicity::install

  ##############################################################################
  # Set variables
  ##############################################################################

  $environment = [ "MAILTO=\"$mailto\"" ]

  $gpg_agent_info = "${home}/.gpg-agent-info"
  $lastrun        = "${home}/.lastrun"

  ##############################################################################
  # Assemble commands
  ##############################################################################

  $cmd_prefix = inline_template("/usr/bin/duplicity <%= options.join(' ') %>")
  $cmd_suffix = inline_template("${name} ${target}")

  $environment_command = "source ${gpg_agent_info}; export GPG_AGENT_INFO;"

  $incr_cmd = "/bin/bash -c '${environment_command} ${cmd_prefix} incremental ${cmd_suffix}' && touch ${lastrun}"
  $full_cmd = "/bin/bash -c '${environment_command} ${cmd_prefix} full ${cmd_suffix}' && touch ${lastrun}"

  $clean_cmd = "/bin/bash -c '${environment_command} ${cmd_prefix} remove-older-than 2W ${target}'"

  ##############################################################################
  # Install crons
  ##############################################################################

  # Run nightly incrementals
  cron { "Duplicity: incremental backup of ${name}":
    ensure      => $ensure,
    command     => $incr_cmd,
    user        => $user,
    hour        => 0,
    minute      => 0,
    weekday     => [1,2,3,4,5,6],
    environment => $environment,
  }

  # Run full backups once a week
  cron { "Duplicity: full backup of ${name}":
    ensure      => $ensure,
    command     => $full_cmd,
    user        => $user,
    hour        => 0,
    minute      => 0,
    weekday     => 0,
    environment => $environment,
  }

  # Remove unneeded backups
  cron { "Duplicity: remove unneeded backups":
    ensure      => $ensure,
    command     => $clean_cmd,
    user        => $user,
    hour        => 0,
    minute      => 0,
    weekday     => 0,
    environment => $environment,
  }

  ##############################################################################
  # Add monitoring for backups
  ##############################################################################

  @@nagios_service { "duplicity_${name}_${hostname}":
    use                      => 'generic-service',
    host_name                => $fqdn,
    check_command            => "check_nrpe!check_file_age!86400 172800 ${lastrun}",
    service_description      => "check_duplicity-${name}-${hostname}",
    first_notification_delay => '120',
    target                   => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify                   => Service[$nagios::params::nagios_service],
  }
}
