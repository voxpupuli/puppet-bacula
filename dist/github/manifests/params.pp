# Class: github::params
#
# This class provides for the overriding of the default user, group, and
# basedir
#
# Parameters:
#   - user
#   - group
#   - basedir
#   - wwwroot
#   - vhost_name
#   - verbose
class github::params (
  $user       = "git",
  $group      = "git",
  $wwwroot    = "/var/www/html",
  $basedir    = "/home/git",
  $vhost_name = 'git',
  $verbose    = false
) { }
