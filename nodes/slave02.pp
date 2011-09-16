node slave02 {
  include role::server
  include jenkins::slave
  include mock
}

