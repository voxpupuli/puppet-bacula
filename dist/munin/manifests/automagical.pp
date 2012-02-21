class munin::automagical {

  # could use string to bool... but haven't.
  if $haszfs == true or $haszfs == "true" {
    include munin::zfs
  }

  # okay, this one is not so magical.
  if $::operatingsystem == 'freebsd' {
    include munin::freebsd
  }

}
