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
                source  => 'puppet:///modules/forge/github_puppet-module-site',
                require => File['/root/.ssh'];
            '/root/.ssh/config':
                ensure  => file,
                owner   => 'root',
                mode    => '0600',
                source  => 'puppet:///modules/forge/github_ssh_config',
                require => File['/root/.ssh'];
        }

    } else {
        warning( "Not messing with Forge/github SSH key antics on $hostname/$kernel" )
    }

}
