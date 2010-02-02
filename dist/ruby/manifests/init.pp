# installs some extra ruby rpms
class ruby {
  package {['rubygems', 'rdoc', 'irb', 'rake', 'build-essential']:
    ensure => installed,
  }
}
