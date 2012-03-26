class service::baculaserver {

  class { "bacula::director":
    db_user => 'bacula',
    db_pw   => 'qhF4M6TADEkl',
  }

  # bacula::director::pool {
  #   "PuppetLabsPool-Full":
  #     volret      => "21 days",
  #     maxvolbytes => '4g',
  #     maxvoljobs  => '10',
  #     maxvols     => "20",
  #     label       => "Full-";
  #   "PuppetLabsPool-Inc":
  #     volret      => "8 days",
  #     maxvolbytes => '4g',
  #     maxvoljobs  => '50',
  #     maxvols     => "10",
  #     label       => "Inc-";
  # }

  bacula::jobdefs {
    "PuppetLabsOps":
      jobtype  => "Backup",
      sched    => "WeeklyCycle",
      messages => "Standard",
      priority => "10",
  }

  bacula::schedule {
    "WeeklyCycle":
      runs => [
        "Level=Full sun at 1:05",
        "Level=Incremental mon-sat at 1:05"
      ];
    "WeeklyCycleAfterBackup":
      runs => [ "Full sun-sat at 3:10" ]
  }

  #bacula::job {
  #  "BackupCatalog":
  #    template => "bacula/catalogjob.conf.erb"
  #}

}

