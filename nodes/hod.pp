# Storage server. Be careful out there little one.
#
node 'hod.dc1.puppetlabs.net' {
  include role::server

  include munin::plugins
  # include zfs::munin
}
