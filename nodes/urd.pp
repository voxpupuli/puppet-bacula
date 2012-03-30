node urd {
  include role::server
  include service::bootserver
  include jumpstart

  nginx::vhost {
    "$fqdn":
      port => 80,
  }

  Preseed {
    proxy => hiera("proxy")
  }

  preseed { "/var/www/${fqdn}/d-i/debian_base.cfg": }
  preseed { "/var/www/${fqdn}/d-i/debian_ops.cfg": }

  $debian = {
    "arch" => ["amd64"],
    "ver"  => ["squeeze","wheezy"],
    "os"   => "debian"
  }

  $debian_common = {
    "file"    => "os_<%= os %>",
    "kernel"  => "images/<%= os %>/<%= ver %>/<%= arch %>/linux",
    "append"  => "vga=normal initrd=images/<%= os %>/<%= ver %>/<%= arch %>/initrd.gz auto locale=en_US console-keymaps-at/keymap=us hostname=<%= os %> domain=unknown url=http://<%= fqdn %>/d-i/debian_base.cfg text",
    "label"   => "Random Ops Shit <%= os %> <%= ver %> <= arch %>",
  }

  resource_permute('pxe::bootstrap', $debian, $debian_common)

}
