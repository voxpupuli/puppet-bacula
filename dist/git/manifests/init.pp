# install everything required to be a git client
class git {

  case $operatingsystem {
    'Debian': { $package_name = 'git' }
    'CentOS': { $package_name = 'git' }
    'Ubuntu': { $package_name = 'git-core' }
    default: { fail("No git package known for operating system ${operatingsystem}") }
  }

  package { $package_name:
    ensure => installed,
  }
}
