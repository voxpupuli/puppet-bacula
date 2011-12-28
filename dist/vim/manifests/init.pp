class vim{
  case $operatingsystem {
    Debian, Ubuntu: { include vim::debian }
    Redhat, Centos, Fedora: { include vim::redhat }
    default: { fail("unspecified operatingsystem ${operatingsystem}") }
  }
}
