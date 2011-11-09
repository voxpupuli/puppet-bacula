define duplicity::cron(
  $ensure = "present",
  $user,
  $target,
  $options = []
) {

  include duplicity::client

  $command = inline_template("/usr/bin/duplicity <%= options.join(' ') %> ${name} ${target}")

  cron { "Duplicity backup of ${name}":
    ensure  => $ensure,
    command => $command,
    user    => $user,
    hour    => 0,
    minute  => 0,
  }
}
