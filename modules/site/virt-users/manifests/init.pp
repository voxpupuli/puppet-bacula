# setup non-root users
class virt-users {
    #
    # Application Users
    #
    @file {
        "interch-home":
            ensure  => directory,
            path    => "/var/lib/interchange",
            owner   => "interch",
            group   => "interch",
            mode    => "755",
            require => User["interch"],
            tag     => "appusers";
        "interch-bashrc":
            path    => "/var/lib/interchange/.bashrc",
            owner   => "interch",
            group   => "interch",
            mode    => "644",
            source  => "puppet:///virt-users/bashrc",
            require => User["interch"],
            tag     => "appusers";
        "interch-bash_profile":
            path    => "/var/lib/interchange/.bash_profile",
            owner   => "interch",
            group   => "interch",
            mode    => "644",
            source  => "puppet:///virt-users/bash_profile",
            require => User["interch"],
            tag     => "appusers";
        "deploy-home":
            ensure  => directory,
            path    => "/home/deploy",
            owner   => "deploy",
            group   => "deploy",
            require => User["deploy"],
            tag     => "appusers";
    }
    @user {
        "interch":
            ensure  => present,
            uid     => "52",
            gid     => "52",
            home    => "/var/lib/interchange",
            shell   => "/bin/bash",
            tag     => "appusers";
        "deploy": 
            ensure  => present,
            uid     => "502",
            gid     => "502",
            home    => "/home/deploy",
            shell   => "/bin/bash",
            tag     => "appusers",
            groups  => ["interch", "wheel"];
    }
    #
    # Application Groups
    #
    @group { "interch": ensure => present, gid => "52", before => User["deploy"], before => User["interch"], tag => "appgroups" }
    @group { "deploy": ensure => present, gid => "502", before => User["deploy"], tag => "appgroups" }
}
