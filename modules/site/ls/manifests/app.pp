# class for app servers at backcountry
class bc::app inherits bc {
    #
    # Include classes in external modules
    #
    include hosts
    include apache
    User    <| tag == appusers |>
    File    <| tag == appusers |>
    Group   <| tag == appgroups |>

    #
    # Use a different authorized_keys file for root.
    #
    File["/root/.ssh/authorized_keys"] { source => "puppet:///bc/root/authorized_keys.app" }

    #
    # authorized_keys file for interch
    #
    file    {
        "/var/lib/interchange/.ssh":
            ensure  => directory,
            owner   => "interch",
            group   => "interch",
            mode    => "700",
            require => User[interch];
        "/var/lib/interchange/.ssh/authorized_keys":
            owner   => "interch",
            group   => "interch",
            mode    => "600",
            source  => "puppet:///bc/interch/authorized_keys";
    }

    #
    # authorized_keys file for deploy
    #
    file    {
        "/home/deploy/.ssh":
            ensure  => directory,
            owner   => "deploy",
            group   => "deploy",
            mode    => "700",
            require => User[deploy];
        "/home/deploy/.ssh/authorized_keys":
            owner   => "deploy",
            group   => "deploy",
            mode    => "600",
            source  => "puppet:///bc/deploy/authorized_keys";
    }

    #
    # Manage the /etc/bc-role file for legacy management scripts
    #
    file { "/etc/bc-role": ensure => "present", owner => "root", group => "root", mode => "644", content => "app" }

    #
    # Create skeleton directories for Interchange install
    #
    file    { ["/usr/lib/interchange","/var/log/interchange","/var/run/interchange"]:
        ensure  => directory,
        owner   => "interch",
        group   => "interch",
        mode    => "755",
        require => User["interch"],
    }

    #
    # These are just managed to replace a legacy cron job
    #
    file    {
        "/var/www": ensure => directory, owner => "root", group => "root", mode => "755";
        "/var/www/html": ensure => directory, owner => "interch", group => "interch", mode => "775", require => User["interch"];
        "/var/www/cgi-bin": ensure => directory, owner => "interch", group => "interch", mode => "755", require => User["interch"];
    }

    #
    # Legacy administrative scripts in /root/bin
    #
    file    { "/root/bin": recurse => true, owner => "root", group => "root", ignore => ".svn*", source => "puppet:///bc/root/bin" } 

    #
    # Cron jobs
    #
    cron {
        "server-status-snapshot":
            ensure  => "present",
            user    => "root",
            command => "/root/bin/server-status-snapshot",
            minute  => "*/5",
            hour    => "2-5",
            require => File["/root/bin"];
    }

    #
    # Install Interchange
    #
    package { "goat-webapp": ensure => "0.4-5", require => User["interch"] }

    #
    # Manage a few other resources that Interchange needs
    #
    file    { "/etc/httpd/conf":
        ensure  => directory,
        owner   => "interch",
        group   => "interch",
        mode    => "755",
        require => Package["apache"],
        require => User["interch"],
    }

    #
    # Adding bittorrent-console script to all webapps
    #
    file {
        "/var/lib/interchange/ctier":
            ensure  => directory,
            owner   => "interch",
            group   => "interch",
            mode    => "755";
        "/var/lib/interchange/ctier/runtorrents.sh":
            ensure  => present,
            owner   => "interch",
            group   => "interch",
            mode    => "744",
            source  => "puppet:///bc/runtorrents.sh";
    }

    #
    # additional packages needed
    #
    package { [ "endpoint-pg83-repo-bc", "tcl", "elinks", "postgresql", "postgresql-libs", "compat-postgresql-libs" ]: ensure => present }

    #
    # Overide aliases
    #
    class mail::app inherits mail {
        Mailalias["root"] { recipient => "critical@infra.backcountry.com" }
    }

    #
    # Bittorrent dependencies
    #
    package { ["bittorrent","python-crypto","python-khashmir"]: ensure => present }
}
