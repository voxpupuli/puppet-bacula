# installs some extra ruby rpms
class ruby::dev {
  require ruby
  package {['ruby-rdoc', 'ruby-irb', 'rubygem-rake']:
    ensure => installed,
  }
}
