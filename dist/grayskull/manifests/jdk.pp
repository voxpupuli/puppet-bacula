class grayskull::jdk inherits grayskull::params {
  package { $grayskull::params::jdkpkg: ensure => installed; }
}
