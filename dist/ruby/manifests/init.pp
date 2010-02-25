# installs some extra ruby rpms
class ruby {
  package{'ruby': ensure => installed,}
  package{'rubygems': ensure => installed, require => Package['ruby'],}
}
