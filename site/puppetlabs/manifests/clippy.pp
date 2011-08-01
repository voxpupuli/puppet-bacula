class puppetlabs::clippy {

  sudo::allowgroup  { "interns": }
  ssh::allowgroup   { "interns": }

  include git::gitolite
}
