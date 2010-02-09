class rails {
  require 'ruby::dev'
  if !$rails_version {
    fail('$my_rails_version must be defined when rails is included')
  }
  # this will not work if gems was not installed 
  # on a previous run
  package{'rails':
    ensure   => $rails_version,
    provider => 'gem',
  }
  
}
