class virtual::customers {
  include virtual::groups
  @account::user {'menglund':
    comment => 'Martin Englund',
		usekey  => false,
    group   => vmware,
    tag     => customer,
  }

}

