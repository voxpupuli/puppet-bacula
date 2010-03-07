# installs some extra ruby rpms
class ruby::dev {
  require ruby
  case $operatingsystem {
    'centos': {
      $ruby_dev='ruby-devel'
      $ruby_rdoc='ruby-rdoc'
      $ruby_irb='ruby-irb'
      $ruby_rake='rubygem-rake'
    }
    'ubuntu': {
      $ruby_dev='ruby-dev'
      $ruby_rdoc='rdoc'
      $ruby_irb='irb'
      $ruby_rake='rake'
    }
  
  }
  package {[$ruby_rdoc, $ruby_irb, $ruby_rake, $ruby_dev]:
    ensure => installed,
  }
}
