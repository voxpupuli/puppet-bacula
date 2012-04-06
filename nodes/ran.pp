node ran {

  include role::server
  include role::gearman
  include service::bootserver

  nginx::vhost {
    "$fqdn":
      port => 80,
  }

  preseed { "/var/www/${fqdn}/d-i/debian_base.cfg": }
  preseed { "/var/www/${fqdn}/d-i/debian_ops.cfg": 
  }

  $debian = {
    "arch" => ["amd64"],
    "ver"  => ["squeeze","wheezy"],
    "os"   => "debian"
  }

  $debian_common = {
    "file"      => "os_<%= os %>",
    "kernel"    => "images/<%= os %>/<%= ver %>/<%= arch %>/linux",
    "append"    => "initrd=images/<%= os %>/<%= ver %>/<%= arch %>/initrd.gz auto locale=en_US console-keymaps-at/keymap=us hostname=<%= os %> domain=unknown url=http://<%= fqdn %>/d-i/debian_ops.cfg text suite=<%= ver %>",
    "menutitle" => "Operations auto-deployment <%= os %> <%= ver %> <%= arch %>",
  }

  resource_permute('pxe::menu::installentry', $debian, $debian_common)

}
