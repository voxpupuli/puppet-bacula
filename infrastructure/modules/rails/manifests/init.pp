class rails {
  require 'ruby::dev'
  $my_rails_version = '2.2.2'
  # this will not work if gems was not installed 
  # on a previous run
  package{'rails':
    ensure   => $my_rails_version,
    provider => 'gem',
  }
  
}
