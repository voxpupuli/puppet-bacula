# For apt-pinning in debian. See man 5 apt_preferences.
# Examples for use:
#
# aptpin{ 'internetexplorer':
#        release  => 'lenny-backports',
#        priority => '1001', }
#
# apt::pin{ '*':
#  release  => 'lenny-backports',
#  priority => '200',
#  filename => 'star'
#  }
##

define apt::pin( $release, $priority, $filename = undef, $ensure = 'present' ) {
  # get around naming things such as '*'
  if $filename == undef {
    $fname = $name
  } else {
    $fname = $filename
  }

  file{
    "/etc/apt/preferences.d/${fname}.pref":
      ensure   => $ensure,
      content  => "Package: $name\nPin: release a=$release\nPin-Priority: $priority\n",
      owner => 'root',
      group => 'root',
      mode => '0644'
  }
}
