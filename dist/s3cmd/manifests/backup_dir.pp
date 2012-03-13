# A defined type to wrap exec of s3cmd
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
# 
# usage:
#   
#   s3cmd::backup_dir {'a_dir_to_backup':
#     bucket        => "s3://a_bucket",
#     config_file   => "/somewhere/.s3cfg",
#   }  

define s3cmd::backup_dir ($bucket, $config_file, $dir_to_backup = $title) {
  exec { $dir_to_backup:
    command => "/usr/bin/s3cmd -c ${config_file} sync ${dir_to_backup}/ s3://${bucket}${dir_to_backup}/",
    timeout => 0,
  }
}

