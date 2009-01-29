class puppetmaster {
  include puppet::server::storedconfigs
  puppet::server::storedconfigs::puppetstoredb {"reductive": }
}
