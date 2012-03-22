class gitolite {
  include gitolite::install
  include gitolite::instance
  include gitolite::rc

  anchor { 'gitolite::begin': } ->
  Class['gitolite::instance'] ->
  Class['gitolite::rc'] ->
  anchor { 'gitolite::end': }

}
