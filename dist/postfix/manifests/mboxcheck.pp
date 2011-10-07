class postfix::mboxcheck {

  # Every week, find all the email boxes that still have crap in them,
  # and email root about them.
  cron{ 'check_for_mailbozes':
    command     => '/usr/bin/find /var/mail -type f -size +0 -ls',
    weekday     => 0,
    hour        => 2,
    minute      => 17,
    environment => 'MAILTO=root',
  }

}
