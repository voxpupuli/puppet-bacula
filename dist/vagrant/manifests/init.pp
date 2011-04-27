class vagrant {

  ssh::allowgroup { "vagrant": }
  sudo::allowgroup { "vagrant": }

}
