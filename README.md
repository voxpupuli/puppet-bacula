# Bacula

[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/bacula.svg)](https://forge.puppetlabs.com/puppet/bacula)
[![Build Status](https://github.com/voxpupuli/puppet-bacula/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-bacula/actions?query=workflow%3ACI)
[![Donated by xaque208](https://img.shields.io/badge/donated%20by-xaque208-fb7047.svg)](#authors)

A puppet module for the Bacula backup system.

## Supported Platforms

* OpenBSD
* FreeBSD
* Linux (Debian, Ubuntu, RedHat, Centos, Fedora, SLES)

# Requirements

This module requires that [exported resources] have been setup (e.g. with
[PuppetDB]).  Including manifests on the Bacula client, assumes that it can
export bits of data to the director to end up with fully functional configs.
As such, to get the benefits of using this module, you should be using it on at
least the director and client, and most likely the storage, though this might
be gotten around, if one were so inclined.

## Usage

To understand Bacula, the [Component Overview] in the Bacula documentation is a
useful start to begin understanding the moving parts.

### A Minimal Setup

What follows here is the bare minimum you would need to get a fully functional
Bacula environment with Puppet.  This setup assumes that the three components
of Bacula (Director, Storage, and Client) all run on three separate nodes.  If
desired, there is no reason this setup can not be built on a single node, just
updating the hostnames used below to all point to the same system.

#### Defaults

Bacula's functionality depends on connecting several components, together.  Due
to the number of moving pieces in this module, you will likely want to set some
site defaults, and tune more specifically where desired.

As such, it is reasonable to use the following declaration in a profile used by all your nodes:

```puppet
class bacula {
  storage_name  => 'mystorage.example.com',
  director_name => 'mydirector.example.com',
}
```

When using the default settings from this module, some resources get provisioned. The provisioning of these default resources can be disabled with the `manage_defaults` parameter.

```puppet
class { 'bacula::director':
  manage_defaults => false,
}
```

##### Classification

This may be on the same host, or different hosts, but the name you put here
should be the fqdn of the target system.  The Director will require the
classification of `bacula::director`, and the Storage node will require the
classification of `bacula::storage`.  **All nodes will require classification
of `bacula::client`, and all nodes will require the shared config by being classified `bacula`.**

A common way of using the module in a simple setup is using a single node that act as a director and storage daemon for all other nodes of the fleet.  In such a scenario, you can create two profiles: `profile::bacula_client` and `profile::bacula_server`:

```puppet
class profile::bacula_client (
  Sensitive $password,
) {
  class { 'bacula':
    storage_name  => 'bacula.example.com',
    director_name => 'bacula.example.com',
    # Other common settings, see below
  }

  class { 'bacula::client':
    password => $password,
    # File daemon specific settings, see below
  }
}
```

```puppet
class profile::bacula_server (
) {
  include profile::bacula_client

  class { 'bacula::director':
    password => 'director-password',
    # Director specific settings, see below
  }

  class { 'bacula::storage':
    password => 'storage-password',
    # File storage specific settings, see below
  }
}
```

##### Upgrading from an older version

Users of a previous version of this module should refer to the wiki for
[upgrading
instructions](https://github.com/voxpupuli/puppet-bacula/wiki/Upgrading).

#### Communication Encryption (TLS Setup)

Refer to the [TLS
Setup](https://github.com/voxpupuli/puppet-bacula/wiki/TLS-Setup) page on the
wiki for instructions about configuring communication encryption.

#### Director Setup

The director component handles coordination of backups and databasing of
transactions.  In its simplest form, the director can be configured with a
simple declaration:

```puppet
class { 'bacula::director':
  storage => 'mystorage.example.com',
}
```

The `storage` parameter here defines which storage server should be used for
all default jobs.  If left empty, it will default to the `$facts['fqdn']` of the
director. This is not a problem for all in one installations, but in scenarios
where directors to not have the necessary storage devices attached, default
jobs can be pointed elsewhere.

Note that if you expect an SD to be located on the Director, you will also need
to include the `bacula::storage` class as follows.

By default a 'Common' fileset is created.

#### Storage Setup

The storage component allocates disk storage for pools that can be used for
holding backup data.

```puppet
class { 'bacula::storage':
  director => 'mydirector.example.com',
}
```

You will also want a storage pool that defines the retention.  You can define
this in the Director catalog without exporting it, or you can use an exported
resource.

```puppet
  bacula::director::pool { 'Corp':
    volret      => '14 days',
    maxvolbytes => '5g',
    maxvols     => '200',
    label       => 'Corp-',
    storage     => 'mystorage.example.com',
  }
```

#### Client Setup

The client component is run on each system that needs something backed up.

```puppet
class { 'bacula::client':
  director => 'mydirector.example.com',
}
```

To direct all jobs to a specific pool like the one defined above set the
following data.

```puppet
class { 'bacula::client':
  default_pool => 'Corp',
}
```

To exclude Info messages from the logfile.

```puppet
class { 'bacula::client':
  messages => {
    'Standard-fd' => {
      daemon   => 'fd',
      mname    => 'Standard',
      director => "${director}-dir = all, !skipped, !restored",
      append   => '"/var/log/bacula/bacula-fd.log" = all, !info, !skipped',
    },
  },
}
```

#### Data Encryption (PKI Setup)

Refer to the [PKI
Setup](https://github.com/voxpupuli/puppet-bacula/wiki/PKI-Setup) section of the
wiki to configure data encryption on clients.

## Creating Backup Jobs

In order for clients to be able to define jobs on the director, exported
resources are used, thus there was a reliance on PuppetDB availability in the
environment. In the client manifest the `bacula::job` exports a job definition
to the director. If you deploy multiple directors that use the same PuppetDB
and you don't want each director to collect every job, specify a job_tag to
group them.

```puppet
bacula::job { 'obsidian_logs':
  files => ['/var/log'],
}
```

This resource will create a new `Job` entry in `/etc/bacula/conf.d/job.conf`
the next time the director applies it's catalog that will instruct the system
to backup the files or directories at the paths specified in the `files`
parameter.

If a group of jobs will contain the same files, a [FileSet resource] can be
used to simplify the `bacula::job` resource. This can be exported from the
node (ensuring the resource title will be unique when realized) or a simple
resource specified on the director using the `bacula::director::fileset`
defined type as follows:

```puppet
bacula::director::fileset { 'Puppet':
  files   => ['/etc/puppet'],
  options => {'compression' => 'LZO' }
}
```
If you set a job_tag on your `bacula::job`, make sure to also set the tag of
the `bacula::director::fileset` to the same value.

[Component Overview]: http://www.bacula.org/7.0.x-manuals/en/main/What_is_Bacula.html#SECTION00220000000000000000
[FileSet resource]: http://www.bacula.org/7.0.x-manuals/en/main/Configuring_Director.html#SECTION001570000000000000000
[exported resources]: https://docs.puppetlabs.com/puppet/latest/reference/lang_exported.html
[PuppetDB]: https://docs.puppetlabs.com/puppetdb
