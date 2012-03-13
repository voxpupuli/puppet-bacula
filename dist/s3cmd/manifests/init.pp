# A class to back up directories to s3 using
# s3cmd and defined type, backup_dir.

class s3cmd {
  package { 's3cmd': ensure => installed }
}

