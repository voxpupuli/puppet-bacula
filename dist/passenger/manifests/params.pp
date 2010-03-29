class passenger::params {
  $version='2.2.11'
  
  case $operatingsystem {
    "ubuntu": {
      $gem_path = '/var/lib/gems/1.8/gems/'
      $gem_binary_path = '/var/lib/gems/1.8/bin'
      $mod_passenger_location = "/var/lib/gems/1.8/gems/passenger-$version/ext/apache2/mod_passenger.so"
    }
    "centos": {
      $gem_path = '/usr/lib/ruby/gems/1.8/gems'
      $gem_binary_path = '/usr/lib/ruby/gems/1.8/gems/bin'
      $mod_passenger_location = "/usr/lib/ruby/gems/1.8/gems/passenger-$version/ext/apache2/mod_passenger.so"
    }
  }
}
