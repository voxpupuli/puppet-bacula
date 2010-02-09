# this is only tested on RH
class gcc {
  package{['gcc', 'gcc-c++']: ensure => installed }
}
