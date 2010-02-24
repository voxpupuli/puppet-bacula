class vim{
  case $operatingsystem{
    Debian, Ubuntu: {include vim::debian}
    redhat, centos, fedora: {include vim::redhat}
    default: {fail("unspecified operatingsystem ${operatingsystem}")}
  }
}
