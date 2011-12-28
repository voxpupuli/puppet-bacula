# For apt-pinning in debian. See man 5 apt_preferences.
# Examples for use:
#
# aptpin{ 'internetexplorer':
#        release  => 'lenny-backports',
#        priority => '1001', }
#
# set wildcard => true for wildcards, it then kinda ignores the
# namevar so you can have duplicates without issue.
#
# apt::pin{ 'lenny_backports_wildcard':
#  release  => 'lenny-backports',
#  priority => '200',
#  filename => 'star',
#  wildcard => true
#  }
#
#

define apt::pin( 
    $release  = '',
    $origin   = '',
    $priority,
    $filename = undef,
    $ensure   = 'present',
    $wildcard = false
  ) {
  include apt

  # get around naming things such as '*'
  if $filename == undef {
    $fname = $name
  } else {
    $fname = $filename
  }

  # So, if we want to have more than one '*' entry.
  if $wildcard == true {
    $packagename = '*'
  } else {
    $packagename = $name
  }

  # to pin on something other than release, like origin.  See apt_preferences(5)
  if $release != '' {
    $pin = "release a=${release}"
  } elsif $origin != '' {
    $pin = "origin \"${origin}\""
  } else {
    err("Apt::Pin needs either $release or $origin, jerk")
  }

  file{
    "/etc/apt/preferences.d/${fname}.pref":
      ensure  => $ensure,
      content => "Package: ${packagename}\nPin: ${pin}\nPin-Priority: ${priority}\n",
      owner   => 'root',
      group   => 'root',
      mode    => '0644'
  }
}
