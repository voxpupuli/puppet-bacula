# Pass in distro specific stuff in options
define kickstart::entry($ensure = "present", $os, $arch, $ver, $options = {}) {

  include kickstart
  include kickstart::params

  $ks_file = "${kickstart::params::ks_root}/${os}-${ver}-${arch}.cfg"

  file { $ks_file:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("kickstart/${os}.cfg.erb"),
  }
}
