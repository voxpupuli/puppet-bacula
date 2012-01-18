class role::base {

  include os

  class {
    "puppet":
      server => hiera("puppet_server"),
      agent  => false,
  }

}
