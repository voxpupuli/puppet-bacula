class vim{
  case $operatingsystem {
    Debian, Ubuntu: { include vim::debian }
    Redhat, CentOS, Fedora: { include vim::redhat }
    Suse, SLES: { include vim::suse }
    default: { fail("unspecified operatingsystem ${operatingsystem}") }
  }
}
