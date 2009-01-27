# class for manager servers at backcountry
class bc::app::manager inherits bc::app {
    #
    # Use a different authorized_keys file for root.
    #
    File["/root/.ssh/authorized_keys"] { source => "puppet:///bc/root/authorized_keys.manager" }
    File["/etc/bc-role"] { content => "manager\n" }
    File["/var/lib/interchange/ctier/runtorrents.sh"] { ensure => absent }

    #
    # additional packages needed
    #
    package { 
        [
            "foomatic.x86_64", "lynx.x86_64", "pbzip2.x86_64", "poppler.x86_64", "psutils.x86_64",
            "perl-BSD-Resource", "perl-Compress-Zlib", "perl-DBI", "perl-HTML-Parser", "perl-HTML-Tagset",
            "perl-libwww-perl", "perl-XML-Parser", "perl-XML-Simple", "mailx"
        ]:
            ensure => present
    }

    #
    # Mount shared docroot
    #
    mount   { "/var/www/html":
        options     => "noatime,nodiratime",
        device      => "tigris:/vol/manager_shared/docroot",
        dump        => "0",
        blockdevice => "",
        ensure      => "mounted",
        pass        => "0",
        fstype      => "nfs",
        atboot      => "",
        target      => "/etc/fstab",
    }
}
