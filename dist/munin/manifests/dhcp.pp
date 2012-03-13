class munin::dhcp {

  include munin::params
  include munin::extra
  include dhcp::params

  $packages = [
    "libnet-netmask-perl",
    "libnet-ip-perl",
    "libhttp-date-perl",
  ]

  munin::plugin { "dhcpd3": }
  munin::pluginconf { "dhcpd3":
      confname => 'dhcpd3',
      confs => {
        "user"           => "root",
        "env.leasefile"  => "/var/lib/dhcp/dhcpd.leases",
        "env.configfile" => "/etc/dhcp/dhcpd.conf",
        #"env.filter"    => "^10\.140\.",
        "env.critical"   => "0.95",
        "env.warning"    => "0.9",
      }
  }

}
