# Class: okra
#
# Installs the okra rails app and all dependencies
#
# Actions:
#
# clones the github url
#
# Sample Usage:
#
class okra {
  include okra::package
  include okra::params
}
