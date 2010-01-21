# install everything required to be a git client
class git{
  package{"git":
    ensure => installed,
  }
}
