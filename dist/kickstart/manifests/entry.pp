# Pass in distro specific stuff in options
define kickstart::entry($ensure = "present", $distro, $arch, $release, $options = {}) {

  include kickstart
  include kickstart::params

  $ks_file = "${kickstart::params::ks_root}/${distro}-${release}-${arch}.cfg"

  file { $ks_file:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("kickstart/${distro}.cfg.erb"),
  }
}
