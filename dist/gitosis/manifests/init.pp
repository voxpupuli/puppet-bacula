class gitosis {
    # The rest of this class will require this exec,
    # so we won't try to do anything unless the init is working.
    exec { check-gitosis-install:
        command => "/bin/echo 'gitosis must be installed for this class to work' && exit 1",
        unless => "/bin/which gitosis-init"
    }
    package { python-setuptools: ensure => installed, require => Exec[check-gitosis-install] }

    user { git:
        shell => '/bin/sh',
        home => "/opt/rl/git",
        comment => 'git version control',
        managehome => true,
        ensure => present,
        require => Exec[check-gitosis-install]
    }
}
