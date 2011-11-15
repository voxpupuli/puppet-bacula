class gdash ($site_alias = $fqdn, $gdash_base="/opt/gdash" ) {
  
  $site_title    = "Puppet Labs Statistics"
  $graphite_url  = "http://graphite.puppetlabs.lan"
  $dashboard_dir = "${gdash_base}/graph_templates/dashboards"
  $whisper_dir   = "/opt/graphite/storage/whisper"
  $repo_url      = "https://github.com/ripienaar/gdash.git"
  
  package { "sinatra" : provider => gem, ensure => present, }
  
  vcsrepo { $gdash_base:
    ensure   => present,
    provider => git,
    source   => $repo_url,
    require  => [Package["sinatra"]],
  }

  include apache::params
  include ::passenger

  $passenger_version=$passenger::params::version
  $gem_path=$passenger::params::gem_path
  
  file{"${gdash_base}/config/gdash.yaml":
    content => template("gdash/gdash.yaml.erb"),
  }
  
  gdash::passenger { "gdash-vhost": 
    gdash_base => $gdash_base,
    site_alias => $site_alias }
}

define gdash::passenger ($gdash_base, $site_alias, $port='80') {
  include apache::params
  include ::passenger

  $passenger_version=$passenger::params::version
  $gem_path=$passenger::params::gem_path

  apache::vhost{$site_alias:
    port     => $port,
    priority => '30',
    docroot  => "${gdash_base}/public/",
    template => 'gdash/gdash-passenger.conf.erb',
  }
}
