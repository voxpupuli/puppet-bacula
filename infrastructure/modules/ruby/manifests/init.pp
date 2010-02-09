# installs some extra ruby rpms
class ruby::dev {
  package{'ruby': ensure => installed,}
  package{'rubygems': ensure => installed, require => Package['ruby'],}
}
