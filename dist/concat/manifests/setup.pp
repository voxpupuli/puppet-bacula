# Sets up the concat system, you should set $concatdir to a place
# you wish the fragments to live, this should not be somewhere like
# /tmp since ideally these files should not be deleted ever, puppet
# should always manage them
#
# It also copies out the concatfragments.sh file to /usr/local/bin
class concat::setup {
    $concatdir = "/var/lib/puppet/concat"
    $sortpath = $operatingsystem ? {
        Darwin => "/usr/bin/sort",
        Ubuntu => "/usr/bin/sort",
        Debian => "/usr/bin/sort",
        default => "/bin/sort",
    }

    file{"/usr/local/bin/concatfragments.sh": 
            owner  => root,
            group  => 0,
            mode   => 755,
            #source => "puppet:///modules/concat/concatfragments.sh";
            content => template("concat/concatfragments.sh");

         $concatdir: 
            ensure => directory,
            owner  => root,
            group  => 0,
            mode   => 755;
    }
}

# vi:tabstop=4:expandtab:ai
