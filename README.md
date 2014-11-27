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
