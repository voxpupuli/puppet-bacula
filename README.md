# Bacula

[![Build Status](https://travis-ci.org/xaque208/puppet-bacula.svg?branch=master)](https://travis-ci.org/xaque208/puppet-bacula.svg?branch=master)

A puppet module for the Bacula backup system.

## Supported Platforms

* OpenBSD
* FreeBSD
* Linux (Debian, Ubuntu, RedHat, Centos, Fedora, SLES)

# Requirements

This module requires that [exported resources] have been setup (e.g. with [PuppetDB])

## Usage

To understand Bacula, the [Component Overview] in the Bacula documentation is a
useful start to begin understanding the moving parts.

### A Minimal Setup

What follows here is the bare minimum you would need to get a fully functional
Bacula environment with Puppet.  This setup assumes that the three components
of Bacula (Director, Storage, and Client) all run on three separate nodes.  If
desired, there is no reason this setup can not be build up on a single node,
just updating the hostnames used below to all point to the same system.

#### SSL

To enable SSL for the communication between the various components of Bacula,
the hiera data for SSL must be set.

```yaml
bacula::params::ssl: true
```

This will ensure that SSL values are processed in the various templates that
are capable of SSL communication.  An item of note: this module expects to be
using the SSL directory for Puppet.  The default value for the Puppet SSL
directory this module will use is `/etc/puppetlabs/puppet/ssl` to support the
future unified Puppet deployment.

To change the SSL directory, simply set `bacula::params::ssl_dir`.  For
example, to use another module for the data source of which SSL directory to
use for Puppet, something like the following is in order.

```yaml
bacula::params::ssl_dir: "%{scope('puppet::params::puppet_ssldir')}"
```

This example assumes that you are using the [ploperations/puppet] module, but
this has been removed as a requirement as a dependency.  Users may also wish to
look at [theforeman/puppet].

#### Director Setup

The director component handles coordination of backups and databasing of
transactions.  In its simplest form, the director can be configured with a
simple declaration:

```Puppet
class { 'bacula::director': storage => 'mystorage.example.com' }
```

The `storage` parameter here defines which storage server should be used for 
all default jobs.  If left empty, it will default to the `::fqdn` of the 
director.
  
This is not a problem for all in one installations, but in scenarios where 
directors to not have the necessary storage devices attached, default jobs 
can be pointed elsewhere.

Note that if you expect an SD to be located on the Director, you will 
also need to include the `bacula::storage` class as follows.

#### Storage Setup

The storage component allocates disk storage for pools that can be used for
holding backup data.

```Puppet
class { 'bacula::storage': director => 'mydirector.example.com' }
```

#### Client Setup

The client component is run on each system that needs something backed up.

```Puppet
class { 'bacula::client': director => 'mydirector.example.com' }
```

## Creating Backup Jobs

In order for clients to be able to define jobs on the director, exported
resources are used, thus there was a reliance on PuppetDB availability in the
environment. In the client manifest the `bacula::job` can be declared as
follows:

```puppet
bacula::job { 'obsidian_logs':
  files => ['/var/log'],
}
```

Will create a new `Job` entry in `/etc/bacula/conf.d/job.conf` the next time
the director applies it's catalog that will instruct the system to backup the
files or directories at the paths specified in the `files` parameter.

If a group of jobs will contain the same files, a [FileSet resource] can be
used to simplify the `bacula::job` resource.  This can be exported from the
node (ensuring the resource title will be unique when realized) or a simple
resource specified on the director using the `bacula::fileset` defined type as
follows:

```puppet
bacula::fileset { 'Puppet':
  files   => ['/etc/puppet'],
  options => {'compression' => 'LZO' }
}
```

## Available types

### bacula::fileset

Defines a Bacula [FileSet resource]. Parameters are:

- `files`: string or array of files to backup.
   Bacula `File` directive.
- `excludes`: string or array of files to exclude from a backup.
  Defaults to `''`.  Bacula `Exclude` directive.
- `options`: hash of options.
  Defaults to `{'signature' => 'MD5', 'compression' => 'GZIP'}`.  Bacula `Options` directive.

### bacula::job

Define a Bacula [Job resource] resource which can create new `Bacula::Fileset`
resources if needed. Parameters are:

- `files`: array of files to backup as part of `Bacula::Fileset[$name]`
  Defaults to `[]`.
- `excludes`: array of files to exclude in `Bacula::Fileset[$name]`
  Defaults to `[]`.
- `jobtype`: one of `Backup` (default), `Restore`, `Admin` or `Verify`.
  Defaults to `Backup`. Bacula `Type` directive.
- `fileset`: determines whether to use the `Common` fileset (`false`), define a
   new `Bacula::Fileset[$name]` (`true`) or use a previously
  defined `Bacula::Fileset` resource (any other string value).
  Defaults to `true`. Bacula `FileSet` directive.
- `template`: template to use for the fragment.
  Defaults to `bacula/job.conf.erb`.
- `pool`: name of the `bacula::director::pool` to use.
  Defaults to `Default`. Bacula `Pool` directive.
- `jobdef`: name of the `bacula::jobdef` to use.
  Defaults to `Default`. Bacula `JobDefs` directive.
- `level`: default job level to run the job as.
  Bacula `Level` directive.
- `accurate`: whether to enable accurate mode. NB, can be memory intensive
  on the client.
  Defaults to 'no'. Bacula 'Accurate' directive.
- `messages`: the name of the message resource to use for this job.
  Defaults to `false` which disables this directive. Bacula `Messages` directive.
  To ensure compatibility with existing installations, the Bacula `Messages`
  directive is set to `Standard` when `Jobtype` is `Restore` and the `messages`
  parameter is `false`.
- `restoredir`: the prefix for restore jobs.
  Defaults to `/tmp/bacula-restores`. Bacula `Where` directive.
- `sched`: the name of the scheduler resource to use for this job.
  Defaults to `false` which disables this directive. Bacula `Schedule` directive.
- `priority`: the priority of the job.
  Defaults to `false` which disables this directive. Bacula `Priority` directive.

See also `bacula::jobdefs`.

### bacula::jobdefs

Define a Bacula [JobDefs resource] resource. Parameters are:

- `jobtype`: one of `Backup`, `Restore`, `Admin` or `Verify`.  Defaults to
  `Backup`. Bacula `Type` directive.
- `sched`: name of the `bacula::schedule` to use.  Defaults to `Default`.
  Bacula `Schedule` directive.
- `messages`: which messages resource to deliver to.  Defaults to `Standard`.
  Bacula `Messages` directive.
- `priority`: priority of the job.  Defaults to `10`. Bacula `Priority`
  directive.
- `pool`: name of the `bacula::director::pool` to use.  Defaults to `Default`.
  Bacula `Pool` directive.
- `level`: default job level for jobs using this JobDefs.  Bacula `Level`
  directive.
- `accurate`: whether to enable accurate mode. NB, can be memory intensive on
  the client.  Defaults to 'no'. Bacula 'Accurate' directive.
- `reschedule_on_error`: Enable rescheduling of failed jobs.  Default: false.
  Bacula `Reschedule On Error` directive.
- `reschedule_interval`: The time between retries for failed jobs.  Bacula
  `Reschedule Interval` directive.
- `reschedule_times`: The number of retries  for failed jobs.  Bacula
  `Reschedule Times` directive.

### bacula::messages

Define a Bacula [Messages resource]. Parameters are:

- `mname`: name of the `Messages` resource.
  Defaults to `Standard`. Bacula `Name` directive.
- `daemon`:
  Defaults to `dir`.
- `director`:
  Bacula `Director` directive.
- `append`:
  Bacula `Append` directive.
- `Catalog`:
  Bacula `Catalog` directive.
- `syslog`:
  Bacula `Syslog` directive.
- `Console`:
  Bacula `Console` directive.
- `mail`:
  Bacula `Mail` directive.
- `Operator`:
  Bacula `Operator` directive.
- `mailcmd`:
  Bacula `Mail Command` directive.
- `operatorcmd`:
  Bacula `Operator Command` directive.

### bacula::schedule

Define a Bacula [Schedule resource]. Parameter is:

- `runs`: define when a job is run.
   Bacula `Run` directive.

### bacula::director::pool

Define a Bacula [Pool resource]. Parameters are:

- `pooltype`:
  Defaults to `Backup`. Bacula `Pool Type` directive.
- `recycle`
  Bacula `Recycle` directive.
- `autoprune`:
   Defaults to `Yes`. Bacula `AutoPrune` directive.
- `volret`:
  Bacula `Volume Retention` directive.
- `maxvoljobs`:
  Bacula `Maximum Volume Jobs` directive.
- `maxvolbytes`:
  Bacula `Maximum Volume Bytes` directive.
- `purgeaction`:
  Bacula `Action On Purge` directive.
  Defaults to `Truncate`.
- `label`:
  Bacula `Label Format` directive.
- `storage`: name of the `Storage` resource backing the pool.
  Defaults to `$bacula::params::bacula_storage`. Bacula `Storage` directive.


[Component Overview]: http://www.bacula.org/7.0.x-manuals/en/main/What_is_Bacula.html#SECTION00220000000000000000
[FileSet resource]: http://www.bacula.org/7.0.x-manuals/en/main/Configuring_Director.html#SECTION001570000000000000000
[exported resources]: https://docs.puppetlabs.com/puppet/latest/reference/lang_exported.html
[PuppetDB]: https://docs.puppetlabs.com/puppetdb
[JobDefs resource]: http://www.bacula.org/7.0.x-manuals/en/main/Configuring_Director.html#SECTION001540000000000000000
[Pool resource]: http://www.bacula.org/7.0.x-manuals/en/main/Configuring_Director.html#SECTION0015150000000000000000
[Schedule resource]: http://www.bacula.org/7.0.x-manuals/en/main/Configuring_Director.html#SECTION001550000000000000000
[Job resource]: http://www.bacula.org/7.0.x-manuals/en/main/Configuring_Director.html#SECTION001530000000000000000
[Messages resource]: http://www.bacula.org/7.0.x-manuals/en/main/Configuring_Director.html#SECTION001530000000000000000
[ploperations/puppet]: https://forge.puppetlabs.com/ploperations/puppet
[theforeman/puppet]: https://forge.puppetlabs.com/theforeman/puppet

