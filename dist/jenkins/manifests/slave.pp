class jenkins::slave {
	include jenkins::params

	Account::User <| tag == 'jenkins' |>
	Group <| tag == 'jenkins' |>

	package { $jenkins::params::slave_packages: 
		ensure => installed,
	}

}
