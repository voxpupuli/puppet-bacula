# installs some extra ruby rpms
class ruby {
<<<<<<< HEAD:dist/ruby/manifests/init.pp
  package {['rubygems', 'rdoc', 'irb', 'rake', 'build-essential']:
    ensure => installed,
  }
=======
  package{'ruby': ensure => installed,}
  package{'rubygems': ensure => installed, require => Package['ruby'],}
>>>>>>> 180c546671513135a98ad3de0309d60b092f0160:infrastructure/modules/ruby/manifests/init.pp
}
