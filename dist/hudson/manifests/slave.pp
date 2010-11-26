class hudson::slave {
	include hudson::params

	Account::User <| tag == 'hudson' |>
	Group <| tag == 'hudson' |>

	package { $hudson::params::slave_packages: 
		ensure => installed,
	}

}
