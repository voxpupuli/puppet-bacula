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
