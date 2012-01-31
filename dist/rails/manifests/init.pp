class rails {

  require ruby::dev

  if !$rails_version {
    fail('$rails_version must be defined when rails is included')
  }

  # this will not work if gems was not installed 
  # on a previous run
  package { 'rails':
    ensure   => $rails_version,
    provider => 'gem',
  }

}
