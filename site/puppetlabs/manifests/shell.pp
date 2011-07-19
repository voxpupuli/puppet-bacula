# Class: puppetlabs::shell
#
# This class installs and configures Shell
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetlabs::shell {
  ssh::allowgroup { "allstaff": }
  include account::master
}

