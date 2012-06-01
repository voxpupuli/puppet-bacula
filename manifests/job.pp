# Class: bacula
#
# This class installs a bacula job on the director.  This can be used for specific applications as well as general host backups
#
# Parameters:
#   * files - An array of files that you wish to get backed up on this job for this host.  ie: ["/etc","/usr/local"]
#   * excludes - An array of files to skip for the given job.  ie: ["/usr/local/src"]
#   * fileset - If set to true, a fileset will be genereated based on the files and exclides paramaters specified above.  Of set to anything but true, the job will attempt to use the fileset named "Common".  NOTE:  the fileset common must be declared elsewhere for this to work.  See Class::Bacula for details.
#
# Actions:
#   * Exports job fragment for consuption on the director
#   * Exports nagios service for consumption on nagios server
#
# Requires:
#   * Class::Bacula {}
#
# Sample Usage:
#  bacula::job {
#    "${fqdn}-common":
#      fileset => "Common",
#  }
#  bacula::job {
#    "${fqdn}-mywebapp":
#      files    => ["/var/www/mywebapp","/etc/mywebapp"],
#      excludes => ["/var/www/mywebapp/downloads"],
#  }
#
define bacula::job (
    $files    = '',
    $excludes = '',
    $jobtype  = 'Backup',
    $fileset  = true,
    $template = 'bacula/job.conf.erb',
    $storage  = hiera('bacula_storage')
  ) {

  include bacula

  # if the fileset is not defined, we fall back to one called "Common"
  if $fileset == true {
    if $files == '' { err("you tell me to create a fileset, but no files given") }
    $fileset_real = $name
    bacula::fileset {
      $name:
        files    => $files,
        excludes => $excludes
      }
  } else {
    $fileset_real = "Common"
  }

  @@concat::fragment {
    "bacula-job-${name}":
      target  => '/etc/bacula/conf.d/job.conf',
      content => template("${template}"),
      tag     => "bacula-${::bacula::params::bacula_director}";
  }

  if $bacula::monitor == true {
    if $jobtype == 'Backup' {
      @@nagios_service { "check_bacula_${name}":
        use                      => 'generic-service',
        host_name                => $::bacula::params::bacula_director,
        check_command            => "check_nrpe!check_bacula!30 ${name}",
        service_description      => "check_bacula_${name}",
        target                   => '/etc/nagios3/conf.d/nagios_service.cfg',
        notify                   => Service[$nagios::params::nagios_service],
        first_notification_delay => '120',
      }
    }
  }
}

