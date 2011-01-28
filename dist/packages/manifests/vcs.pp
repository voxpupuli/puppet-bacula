# to make it easier to grab the neede package one-offs

class packages::vcs {
	@package { "git-core": ensure => installed; }
	@package { "subversion": ensure => installed; }

}
