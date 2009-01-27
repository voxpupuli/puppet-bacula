# setup repositories
class yum {
    file {
        "/etc/yum.repos.d":
            ensure  => directory,
            recurse => true;
        "/etc/yum/pluginconf.d/rhnplugin.conf":
            ensure  => present,
            owner   => "root",
            group   => "root",
            mode    => "644",
            source  => "puppet:///yum/rhnplugin.conf";
        "/etc/yum.repos.d/5Server-x86_64.repo":
            ensure  => present,
            owner   => "root",
            group   => "root",
            mode    => "644",
            source  => "puppet:///yum/5Server-x86_64.repo",
            require => File["/etc/yum/pluginconf.d/rhnplugin.conf"],
            # 
            # This is not exactly how I want to model this prerequisite.  It is necessary to make sure that the yum repo is added before packages are installed.
            #
            before  => Class["bc"];
        "/etc/yum.repos.d/backcountry-local.repo":
            ensure  => present,
            owner   => "root",
            group   => "root",
            mode    => "644",
            source  => "puppet:///yum/backcountry-local.repo",
            require => File["/etc/yum.repos.d/5Server-x86_64.repo"],
            before  => Class["bc"];
   }
}
