include git
vcsrepo{"/tmp/facter":
  source => 'git://github.com/reductivelabs/facter.git',
  revision => '1.5.7', 
#  path => $dir,
}
