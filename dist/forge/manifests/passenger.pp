class forge::passenger {
      include ::passenger
      include passenger::params
      include apache::ssl

      $passenger_version=$passenger::params::version
      $gem_path=$passenger::params::gem_path

      file { "/etc/apache2/conf.d/passenger.conf":
        owner   => root,
        group   => root,
        mode    => 0644,
        notify  => Service["httpd"],
        content => template("forge/passenger.conf.erb");
      }

      apache::vhost { $vhost:
        port => '80',
        priority => '60',
        ssl => false,
        docroot => '/opt/forge/public/',
        template => 'forge/puppet-forge-passenger.conf.erb',
        require => [ Vcsrepo['/opt/forge'], File['/opt/forge/log'], File['/opt/forge/tmp'], Exec['rakeforgedb'], File['/opt/forge/config/database.yml'], File['/opt/forge/config/secrets.yml'] ],
      }

      if $ssl == true {
          apache::vhost { "${vhost}_ssl":
            port => 443,
            priority => 61,
            docroot => '/opt/forge/public/',
            ssl => true,
            template => 'forge/puppet-forge-passenger.conf.erb',
            require => [ Vcsrepo['/opt/forge'], File['/opt/forge/log'], File['/opt/forge/tmp'], Exec['rakeforgedb'], File['/opt/forge/config/database.yml'], File['/opt/forge/config/secrets.yml'] ],
          }
      }
}
