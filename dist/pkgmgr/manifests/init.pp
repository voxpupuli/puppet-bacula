class pkgmgr {
  case $operatingsystem {
    Debian: {include pkgmgr::apt}
  }

}
