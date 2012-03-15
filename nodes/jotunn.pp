# = jotunn
#
# == Purpose
#
# It's like app01, but with a better name, a non-ubuntu operating system, and
# less cruft.
#
node jotunn {
  include role::server
  include service::docs

  # https://projects.puppetlabs.com/issues/7849
  # github pull request robot
  # THIS DOESN'T WORK, VCSREPO IS UTTER MONKEY SHIT.
  class{ 'githubrobotpuller':
    version => 'bd4ea8f52b66556a1d45c03f9ff975e09f6b16e2',
  }

  # (#11931) Host a JSONP proxy on the local network
  include apache::mod::passenger

  apache::vhost { 'jotunn.puppetlabs.lan':
    port     => 80,
    options  => '-Multiviews',
    docroot  => '/var/www',
    template => 'apache/vhost-passenger.conf.erb',
    template_options => {
      rack_base_uris => ["/jsonp", "/zendesk"],
    }
  }

  include freddy
  rack::app { 'jsonp':
    ensure => present,
    doc_root => '/var/www',
    app_root => '/opt/freddy',
    require  => Class['freddy'],
  }

  include zendesk
  rack::app { 'zendesk':
    ensure => present,
    doc_root => '/var/www',
    app_root => '/opt/zendesk',
    require  => Class['zendesk'],
  }

  # 12806 - Docs needs some scratch vhosts
  apache::vhost {
    'docspreview1.puppetlabs.lan': docroot => '/opt/docspreview1';
    'docspreview2.puppetlabs.lan': docroot => '/opt/docspreview2';
    'docspreview3.puppetlabs.lan': docroot => '/opt/docspreview3';
  }

  file {
    ['/opt/docspreview3','/opt/docspreview2','/opt/docspreview1']:
      ensure => directory,
      mode   => '0755',
      owner  => deploy,
      group  => root;
  }

}
