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

define apt::pin( $release, $priority, $filename = undef, $ensure = 'present', $wildcard = false ) {
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

  file{
    "/etc/apt/preferences.d/${fname}.pref":
      ensure   => $ensure,
      content  => "Package: ${packagename}\nPin: release a=${release}\nPin-Priority: ${priority}\n",
      owner => 'root',
      group => 'root',
      mode => '0644'
  }
}
