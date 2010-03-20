# Class: ruby::params
#
# This class handles the Ruby module parameters
#
# Parameters:
#   $ruby_devel = the name of the Ruby development libraries
#   $ruby_rdoc  = Ruby RDoc
#   $ruby_irb   = Ruby IRB
#   $ruby_rake  = Ruby Rake
# 
# Actions:
#
# Requires:
#
# Sample Usage:
#
class ruby::params {

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

}

