class pkgmgr {
  case $operatingsystem {
    case Debian: {include pkgmgr::apt}
  }

}
