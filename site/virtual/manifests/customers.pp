class virtual::customers {
  include virtual::groups
  @account::user {'menglund':
    comment => 'Martin Englund',
		usekey  => false,
		chroot  => true,
    group   => vmware,
    tag     => customer,
  }

}

