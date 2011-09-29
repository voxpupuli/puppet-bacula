# to make it easier to grab the neede package one-offs
# Make them OS indepedant.

class packages::shells {

  $bash = $operatingsystem ? {
    'freebsd' => 'shells/bash',
    default   => 'bash'
  }

  $zsh = $operatingsystem ? {
    'freebsd' => 'shells/zsh',
    default   => 'zsh'
  }


  # Now do a virtual package for each shell.
  @package { $zsh:
    alias => 'zsh',
    ensure => installed,
  }

  @package { $bash:
    alias => 'bash',
    ensure => installed,
  }


}
