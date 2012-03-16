class vim{
  case $operatingsystem {
    Debian, Ubuntu: { include vim::debian }
    Redhat: { include vim::redhat }
    Suse: { include vim::suse }
    default: { fail("unspecified operatingsystem ${operatingsystem}") }
  }
}
