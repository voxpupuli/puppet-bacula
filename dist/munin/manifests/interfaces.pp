# Build out munin on all interfaces, well, other than loopback.
#

class munin::interfaces {

  $interfaces_of_worth =  regsubst( $interfaces , '((dummy|teql|sit|gre|tunl|ip6tnl)[0-9]|lo[0-9]?),?' , '', 'G' )

  munin::interfaces::plugin{ 'if_ints':
    array_of_interfaces => $interfaces_of_worth,
    plugin_name         => 'if_',
  }

  munin::interfaces::plugin{ 'if_ints_of_error':
    array_of_interfaces => $interfaces_of_worth,
    plugin_name         => 'if_err_',
  }


}

#
# This takes an array of interfaces, and the plugin name with trailing
# '_' and makes a load of munin plugins of them.
#
# Eg:
#
#  munin::interfaces::plugin{ 'all_the_ifs':
#   array_of_interfaces => [ 'em0', 'em1', 'igb0' ],
#   plugin_name         => 'if_',
#  }
#

define munin::interfaces::plugin (
  $array_of_interfaces,
  $plugin_name,
  $plugin_path = undef
) {

  # Have to use double backslash due to being a double quoted string,
  # so it pulls in the variable, but then it intrepts escape sequences
  # too.
  #
  # regsubst also, helpfully, takes in an array, and spits it back out
  # too. So we can just act on each!
  $array_of_plugins = regsubst( split( $array_of_interfaces , ',' ) , '^(.*)', "${plugin_name}\\1" , 'G' )

  munin::plugin{ $array_of_plugins:
    fromname   => $plugin_name,
    pluginpath => $plugin_path,
  }

}

