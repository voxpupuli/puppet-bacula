class packages::archive {
	@package { "unzip": ensure => installed; }

  case $operatingsystem {
    'debian','ubuntu': { @package { 'xz-utils': ensure => installed; } }
    'centos','rhel':   { @package { 'xz': ensure => installed; } }
  }

}
