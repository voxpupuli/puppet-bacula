# Class okra::params
#
# Specifies default but overridable params for okra
class okra::params (
  $user          = 'okra',
  $group         = 'okra',
  $basedir       = "/opt/okra",
  $source_url    = "git@github.com:arcturo/okra.git"
) {

}
