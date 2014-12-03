# Bacula

[![Build Status](https://travis-ci.org/xaque208/puppet-bacula.png)](https://travis-ci.org/xaque208/puppet-bacula)

A puppet module for the Bacula backup system.

## Supported Platforms

* Linux
  * Debian, Ubuntu, Centos, Fedora, SLES
* FreeBSD (client only)
* OpenBSD

# Requirements

## Usage

### Director Setup

The director component handles coordination of backups and databasing of
transactions.  In its simplest form, the director can be configured with a
simple declaration:

```Puppet
class { 'bacula::director': storage => 'mystorage.example.com' }
```

### Storage Setup

The storage component allocates disk storage for pools that can be used for
holding backup data.

```Puppet
class { 'bacula::storage': director => 'mydirector.example.com' }
```

### Client Setup

The client component is run on each system that needs something backed up.

```Puppet
class { 'bacula::client': director => 'mydirector.example.com' }
```

## Exporting resources from clients to the director

In order for clients to be able to define jobs on the director, exported
resources are used. In the client manifest the `bacula::job` can be declared as:

```puppet
@@bacula::job { 'obsidian_logs':
  files => ['/var/log'],
}
```

Will create a new `Job` entry in `/etc/bacula/conf.d/job.conf` the next time
the director applies it's catalog.

The other type that can be exported is the `bacula::fileset`:

```puppet
@@bacula::fileset { 'Puppet':
  files   => ['/etc/puppet'],
  options => {'compression' => 'LZO' }
}
```

This requires that [exported resources](https://docs.puppetlabs.com/puppet/latest/reference/lang_exported.html) have been setup (e.g. with [PuppetDB](https://docs.puppetlabs.com/puppetdb/)).

## TLS encryption

By default no TLS encryption is enabled, enabling it can be done through Hiera with:

```yaml
bacula::params::ssl: yes
```

It will then use the Puppet agent certificates to establish secured connections.
However in order for the client to export it's keys back to the director the
following Hiera keys must contain the agent's certificate and keyfile:

```puppet
bacula_ssl_keyfile_${::clientcert}
bacula_ssl_certfile_${::clientcert}
```

For example by using [hiera-file](https://github.com/adrienthebo/hiera-file)

## Available types

### bacula::fileset

Defines a Bacula [FileSet](http://www.bacula.org/7.0.x-manuals/en/main/Configuring_Director.html#SECTION001570000000000000000) resource. Parameters are:

- `files`: string or array of files to backup.
   Bacula `File` directive.
- `excludes`: string or array of files to exclude from a backup.
  Defaults to `''`.  Bacula `Exclude` directive.
- `options`: hash of options.
  Defaults to `{'signature' => 'MD5', 'compression' => 'GZIP'}`.  Bacula `Options` directive.

### bacula::job

Define a Bacula [Job](http://www.bacula.org/7.0.x-manuals/en/main/Configuring_Director.html#SECTION001530000000000000000) resource which can create new `Bacula::Fileset` resources if needed. Parameters are:

- `files`: array of files to backup as part of `Bacula::Fileset[$name]`
  Defaults to `[]`.
- `excludes`: array of files to exclude in `Bacula::Fileset[$name]`
  Defaults to `[]`.
- `jobtype`: one of `Backup` (default), `Restore`, `Admin` or `Verify`.
  Defaults to `Backup`. Bacula `Type` directive.
- `fileset`: determines wether to use the `Common` fileset (`false`), define a
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
- `accurate`: wether to enable accurate mode. NB, can be memory intensive
  on the client.
  Defaults to 'no'. Bacula 'Accurate' directive.

### bacula::jobdefs

Define a Bacula [JobDefs](http://www.bacula.org/7.0.x-manuals/en/main/Configuring_Director.html#SECTION001540000000000000000) resource. Parameters are:

- `jobtype`: one of `Backup`, `Restore`, `Admin` or `Verify`.
  Defaults to `Backup`. Bacula `Type` directive.
- `sched`: name of the `bacula::schedule` to use.
  Defaults to `Default`. Bacula `Schedule` directive.
- `messages`: which messages resource to deliver to.
  Defaults to `Standard`. Bacula `Messages` directive.
- `priority`: priority of the job.
  Defaults to `10`. Bacula `Priority` directive.

### bacula::mesages

Define a Bacul [Messages]() resource. Parameters are:

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

Define a Bacula [Schedule](http://www.bacula.org/7.0.x-manuals/en/main/Configuring_Director.html#SECTION001550000000000000000) resource. Parameter is:

- `runs`: define when a job is run.
   Bacula `Run` directive.

### bacula::director::pool

Define a Bacula [Pool]() resource. Parameters are:

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
  Defaults to `''`. Bacula `Label Format` directive.
- `storage`: name of the `Storage` resource backing the pool.
  Defaults to `$bacula::params::bacula_storage`. Bacula `Storage` directive.
