# Puppet Mrepo #

Manages an installation of mrepo

## Synopsis ##

    class my_mrepo {
      class { mrepo::settings:
        rhn_username  => 'my_rhn_username',
        rhn_password  => 'my_rhn_password',
      }
    
      mrepo::repo { "centos5-x86_64":
        ensure    => present,
        repotitle => "Centos 5.5 64 bit",
        arch      => "x86_64",
        release   => "5.5",
        iso       => 'CentOS-5.5-x86_64-bin-DVD-part?.iso',
        updates   => 'rsync://mirrors.kernel.org/centos/$release/updates/x86_64/',
      }
    }

## Usage ##

If you need to customize the mrepo default settings, include the 
mrepo::settings class and include the appropriate variables. Else, you should
be able to include mrepo by itself.

Note that mrepo::settings must be included before mrepo if you choose to 
override defaults.

### mrepo::settings ###

__srcroot__: The destination of the mirrored packages

__wwwroot__: The location where these packages will be hosted

__isoroot__: The location of any provided isos to remount

These parameters are only needed if you plan to mirror RHN packages

__rhn_username__: your redhat network username

__rhn_username__: your redhat network username

### mrepo::repo ###

__ensure__: present, absent

__repotitle__: The short description of the repo

__arch__: i386, x86_64

__release__: The repository release to mirror

__updates__: The url to download updates from

__extras__: The url to download extra packages from

__fasttrack__: The url to download fasttrack updates from. RHEL specific.
