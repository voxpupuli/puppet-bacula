class vim::redhat{
  package{['vim-minimal', 'vim-common', 'vim-enhanced']:
    ensure => latest,
  }
}
