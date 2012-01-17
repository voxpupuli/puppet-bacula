class os {
  case $operatingsystem {
    centos,
    fedora,
    ubuntu,
    debian:  { include os::linux }
    darwin:  { include os::darwin }
    freebsd: { include os::freebsd }
    default: { notify { "OS ${operatingsystem} hos no love": } }
  }
}
