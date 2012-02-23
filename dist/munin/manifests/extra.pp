class munin::extra {
  include munin::params
  package { $munin::params::extra_package: ensure => installed; }
}
