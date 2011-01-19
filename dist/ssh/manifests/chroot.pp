class ssh::chroot {

	file { "/var/chroot": ensure => directory; }

}
