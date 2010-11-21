class hudson::slave {
	include puppetlabs::lan
	include hudson::params
	#include hudson::common

	Account::User <| tag == 'hudson' |>
	Group <| tag == 'hudson' |>

	package { $hudson::params::slave_packages: 
		ensure => installed,
	}

}
