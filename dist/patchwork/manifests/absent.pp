# = Class patchwork
#
# == Description
#
# Burns patchwork to the ground like the abomination that it is
#
# == Caveats
#
# This module cannot pour holy water over the hypervisor running app01
# and thus cannot entirely purge the taint of darkness
class patchwork::absent {

  file {[
    "/srv/patchwork/",
    "/var/lib/bacula/pgsql",
    "/home/patchwork",
    ]:
      ensure  => absent,
      recurse => true,
      force   => true,
      backup  => false,
  }

  cron {
    "patchwork_sql_dump":
      user    => root,
      command => "sudo -i -u patchwork pg_dump | gzip > /var/lib/bacula/pgsql/bacula.sql.gz",
      ensure  => absent;
    "fetchmail":
      user => patchwork,
      command => '/usr/bin/fetchmail -s --mda "/srv/patchwork/apps/patchwork/bin/parsemail.sh"',
      ensure  => absent;
    "repoupdate":
      user => patchwork,
      command => '/usr/bin/setlock -nx ~/.repoupdate /home/patchwork/bin/update-repos-and-patchwork ~/repos',
      ensure  => absent;
  }

}
