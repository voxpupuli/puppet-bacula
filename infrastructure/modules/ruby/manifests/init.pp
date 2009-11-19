# installs some extra ruby rpms
class ruby {
  package {
    ['rubygems', 'ruby-rdoc', 'ruby-irb']:
  }
}
