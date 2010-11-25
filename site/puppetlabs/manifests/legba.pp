# Class: puppetlabs::legba
#
# This class installs and configures Legba
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetlabs::legba {

  include puppetlabs
  include account::master

	Account::User <| tag == 'prosvc' |>
	Group <| tag == 'prosvc' |>
	Account::User <| tag == 'developers' |>
	Group <| tag == 'developers' |>

}

