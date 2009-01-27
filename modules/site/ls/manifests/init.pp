# main bc class
class bc {
    #
    # include classes in external modules
    #
    include virt-users
    include ssh::server
    include ntp
    include sudo
    include mail
    include rsyslog
    include monitor
    include backup

    #
    # Setting default owner, group, and mode parameters.
    #
    File{ owner => "root", group => "root", mode => "644" }

    #
    # Managing misc system files that don"t really require their own modules in BC environment.
    # Note these configurations assume that we are building only RHEL5 machines.
    #
    file { "/etc/resolv.conf": 
        source => $domain ? {
          "fqa.bcinfra.net"  => "puppet:///bc/fqa/resolv.conf",
          "vw.bcinfa.net"  => "puppet:///bc/prod/resolv.conf",
          default  => "puppet:///bc/prod/resolv.conf"
        }
    }


    #
    # Just disabling these services for now. 
    #
    service { "iptables": ensure => "stopped", enable => false }

    #
    # Ensure SElinux is disabled
    #
    file    { "/etc/selinux/config": source => "puppet:///bc/selinux.config" }
    file    { "/etc/sysconfig/selinux": ensure => "/etc/selinux/config", require => File["/etc/selinux/config"] }

    #
    # array for default packages to be installed on every machine
    #
    package { [ "endpoint-repo-bc", "emacs-nox", "strace" ]: ensure => present }

    # use Postfix instead of Sendmail and cleanup sendmail statistics
    package { "sendmail": ensure => absent }
    package { "postfix": ensure => present }
    service { "postfix": ensure => running, enable => true }
    file    {
        "statistics.rpmsave": path => "/var/log/mail/statistics.rpmsave", ensure => absent, require => Package["sendmail"];
        "mail": path => "/var/log/mail", ensure => absent, require => Package["sendmail"], force => true;
    }

    #
    # We are going to just manage authorized keys as a file for now.
    # For the root user, this is a short term hack until individual user accounts with root via sudo are configured @ backcountry.
    # Also the ssh_authorized_key module seems to be broken so I wrote a defined type to deal with authorized keys.
    #
    file    {
        "/root/.ssh":
            ensure  => directory,
            owner   => "root",
            group   => "root",
            mode    => 700;
        "/root/.ssh/authorized_keys":
            owner   => root,
            group   => root,
            mode    => 600,
            source  => "puppet:///bc/root/authorized_keys";
        "vimrc":
            path    => "/root/.vimrc",
            owner   => root,
            group   => root,
            source  => "puppet:///bc/root/.vimrc";
        "emacs":
            path    => "/root/.emacs",
            owner   => root,
            group   => root,
            source  => "puppet:///bc/root/.emacs";
        "skel":
            path    => "/etc/skel",
            ensure  => directory,
            recurse => true,
            ignore  => ".svn",
            owner   => "root",
            group   => "root",
            source  => "puppet:///bc/skel";
        "bashrc":
            path    => "/etc/bashrc",
            owner   => root,
            group   => root,
            source  => "puppet:///bc/bashrc";
    }
}
