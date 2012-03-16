# A defined type to wrap cron execution of s3cmd
# 
# Backs up contents of a directory to s3. Performs a "soft sync",
# that is, does not delete files in the backup that no longer exist
# in the source. Timeout set to 0 to avoid failure on longer
# backups.
#
# Parameters:
# - $bucket the bucket in s3 to backup to
# - $config_file the s3cmd config file to use
# - $dir_to_backup the directory to back up in s3 (defaults to title)
# - $user the user the cron job will run as
# - $ensure as with a cron resource, either "present" or "absent"
# - various time parameters - all identical to standard cron resource 
# 
# usage:
#   
#   s3cmd::backup_dir {'a_dir_to_backup':
#     bucket        => "s3://a_bucket",
#     config_file   => "/somewhere/.s3cfg",
#     user          => "a_guy",
#     ensure        => "present",
#     minute        => "0",
#     hour          => "0",
#     monthday      => "*",
#     month         => "*",
#     weekday       => "0",
#   }  

define s3cmd::backup_dir (
    $bucket,
    $config_file,
    $dir_to_backup = $title,
    $user,
    $ensure = "present",
    $minute,
    $hour,
    $monthday,
    $month,
    $weekday,
) {

  cron { $title:
    command   => "/usr/bin/s3cmd -c ${config_file} sync ${dir_to_backup}/ s3://${bucket}${dir_to_backup}/",
    user      => "${user}", 
    ensure    => "${ensure}",
    minute    => "${minute}",
    hour      => "${hour}",
    monthday  => "${monthday}",
    month     => "${month}",
    weekday   => "${weekday}",
  }
}

