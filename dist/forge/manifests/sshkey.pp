# Class: forge::sshkey
#
# This class installs and configures the SSH key for github, so it can
# pull down the private repo it needs.
#
class forge::sshkey {

    # For now, we only work on linux, due to SunOS's strange lack of
    # /root/
    if $kernel == 'Linux' {

        file{
            '/root/.ssh':
                ensure =>  directory , owner => 'root';
            '/root/.ssh/github_puppet-module-site':
                ensure  => file,
                owner   => 'root',
                mode    => '0600',
                source  => 'puppet:///modules/forge/github_puppet-module-site.sshkey',
                require => File['/root/.ssh'];
            '/root/.ssh/config':
                ensure  => file,
                owner   => 'root',
                mode    => '0600',
                source  => 'puppet:///modules/forge/github_ssh_config',
                require => File['/root/.ssh'];
        }

        # Manage known_hosts too. This _may_ get out of date, but at
        # least for now it works, which is better than not at all.
        sshkey{ 'github.com':
          ensure => present,
          type   => 'ssh-rsa',
          key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==',
        }

    } else {
        warning( "Not messing with Forge/github SSH key antics on $hostname/$kernel" )
    }

}
