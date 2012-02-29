# A class to back up directories on burji to s3 using
# the backup_dir defined type.

class burji_s3cmd {
		$bucket       = "burji"
		$config_file  = "/root/.s3cfg"

		burji_s3cmd::backup_dir {'1': 
			bucket        => $bucket,
			config_file   => $config_file,
			dir_to_backup => "/opt/pm",
			schedule      => 'burji_backup',
		}

		burji_s3cmd::backup_dir {'2':
			bucket        => $bucket,
			config_file   => $config_file,
			dir_to_backup => "/opt/downloads",
			schedule      => 'burji_backup',
		}

		schedule { 'burji_backup':
			period  => 'weekly',
			range   => '2 - 4',
		}			
}

