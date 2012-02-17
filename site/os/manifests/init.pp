class os {
  case $::kernel {
    linux:   { include os::linux }
    darwin:  { include os::darwin }
    freebsd: { include os::freebsd }
    default: { notify { "OS ${operatingsystem} has no love": } }
  }
}
