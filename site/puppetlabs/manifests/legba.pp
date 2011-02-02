# Class: puppetlabs::legba
#
# This class installs and configures Legba
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetlabs::legba {

  include puppetlabs
  include puppetlabs_ssl
  include account::master
  include collectd::client

	#Acount::User <| tag == 'developers' |>
	#Group <| tag == 'developers' |>
	ssh::allowgroup { "prosvc": }
	ssh::allowgroup { "enterprise": }
	ssh::allowgroup { "developers": }

	$ssl_path = $puppetlabs_ssl::params::ssl_path

  apache::vhost {'ps.puppetlabs.com':
	  serveraliases => "ps.puppetlabs.com",
    port => 80,
    docroot => '/opt/prosvc',
    ssl => false,
    priority => 10,
    template => 'puppetlabs/legba.conf.erb',
  }

  apache::vhost {'ps.puppetlabs.com_ssl':
	  serveraliases => "ps.puppetlabs.com",
    port => 443,
    docroot => '/opt/prosvc',
    ssl => true,
		auth => true,
    priority => 11,
    template => 'puppetlabs/legba.conf.erb',
  }

	file { "/opt/prosvc": ensure => directory, owner => root, group => prosvc, mode => 664, recurse => true, checksum => none; }
	file { "/opt/prosvc/.htaccess": owner => root, group => root, mode => 644, source => "puppet:///modules/puppetlabs/legba_htaccess"; }
  
	apache::vhost {'pm.puppetlabs.com':
	  serveraliases => "pm.puppetlabs.com",
    port => 80,
    docroot => '/opt/pm',
    ssl => false,
    priority => 15,
    template => 'puppetlabs/legba.conf.erb',
  }

  apache::vhost {'pm.puppetlabs.com_ssl':
	  serveraliases => "pm.puppetlabs.com",
    port => 443,
    docroot => '/opt/pm',
    ssl => true,
		auth => false,
    priority => 16,
    template => 'puppetlabs/legba.conf.erb',
	}

	file { "/opt/pm": ensure => directory, owner => root, group => enterprise, mode => 664, recurse => true, checksum => none; }
	file { "/opt/pm/.htaccess": owner => root, group => enterprise, mode => 644, source => "puppet:///modules/puppetlabs/legba_htaccess"; }

}

