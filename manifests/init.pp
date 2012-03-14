class gitolite {
  include gitolite::package
  include gitolite::instance
  include gitolite::rc

  anchor { 'gitolite::begin': } ->
  Class['gitolite::package'] ->
  Class['gitolite::instance'] ->
  Class['gitolite::rc'] ->
  anchor { 'gitolite::end': }

}
