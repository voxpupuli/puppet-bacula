#
# This modules will look very different when A. We implement stored configs and collection and B. All backcountry hosts are managed by Puppet.
# This would be better managed using a combination of the host type resource, store configs, and tags.  For now we will just manage the file and put in only on hosts that need it.
#
class hosts {
    file { "/etc/hosts":
        owner   => "root",
        group   => "root",
        mode    => "644",
        source  => "puppet:///hosts/hosts_file",
    }
}
