# Class okra::params
#
# Specifies default but overridable params for okra
class okra::params (
  $user          = 'www-data',
  $group         = 'www-data',
  $basedir       = "/opt/okra",
  $source_url    = "git@github.com:arcturo/okra.git"
) {

}
