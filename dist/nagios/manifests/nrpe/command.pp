define nagios::nrpe::command (
  $args,
  $path
  ) {

  include nagios::params

  $command_file = "${::nagios::params::nrpe_config_dir}/${name}.cfg"
  $command_line = "command[$name]=${path} ${args}\n"

  file {
    $command_file:
      owner   => $::nagios::params::nrpe_user,
      group   => $::nagios::params::nrpe_group,
      content => $command_line,
      notify  => Service["$nagios::params::nrpe_service"],
  }

}
