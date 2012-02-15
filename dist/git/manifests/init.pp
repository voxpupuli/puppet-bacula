# install everything required to be a git client
class git {

  case $operatingsystem {
    'Debian': { $package_name = 'git' }
    'CentOS': { $package_name = 'git' }
    'Ubuntu': { $package_name = 'git-core' }
    'SLES':   { $package_name = 'git' }
    'Fedora': { $package_name = 'git' }
    default: { fail("No git package known for operating system ${operatingsystem}") }
  }

  package { $package_name:
    ensure => installed,
  }
}
