class testbed::driver {
  include ruby
  include git

  $gems = ["net-ssh","net-scp","net-http","systemu","rake"]
  package { $gems: ensure => installed, provider => gem; }

  file { "/etc/plharness/secret":
    owner => root,
    group => root,
    mode  => 640,
    content => 'Puppetmaster!';
  }
}
