class pkgmgr::apt {
  file{'/etc/apt/sources.list':
    ensure => file, 
  }
}
