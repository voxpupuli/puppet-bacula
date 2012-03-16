class munin::extra {

  include munin::params
  package { $munin::params::extra_packages: ensure => installed; }

}
