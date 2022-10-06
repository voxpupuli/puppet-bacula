## [5.5.0](https://github.com/voxpupuli/puppet-bacula/tree/5.5.0) (2019-02-14)
Switch to Bacula 9 on FreeBSD

## 2018-05-26 5.4.0
Switch to more strict data types

## 2018-05-26 5.3.1
Improve Debian support.  Use the correct group (tape) for the bacula-sd
configuration file on Debian.

## 2018-05-13 5.3.0
Revamp TLS handling and Improve class/define parameter data types.  See the
github wiki for details.

## 2017-10-22 5.2.0
Introduce PKI support for encrypting and signing backups with a self-signed
cert.  See the README for details.

## 2017-10-04 5.1.1
### Summary
Syntax fix for newer Puppet.

## 2017-07-24 5.1.0
### Summary

This update contains many small fixes, and clean up.  Thanks to the several
people who sent in PRs for this work and filed issues.

### Features
* Encourage hiera for class params in documentation
* Create bacula::storage::device define for greater flexibility
* Add support for Max Concurrent Jobs tuning
* Use trusted facts for node name references

### Bugfixes
* Refactor ssl variable references
* Relocate default client pool and package data to hiera
* Fix use pool name when job or client request pool_{full,inc, diff} by name
* Fix job_tag reference
* Improve classification documentation in the README
* Fix template name template reference fixes #87
* Fix missing variable references fixes #95
* Change director's client address reference to use the node address, not name
* Clean up old variable references and comments

## 2017-04-16 5.0.0
### Summary

This update contains a data overhaul removing the params class entirely, some
testing changes and a couple small features.  Please see the `Upgrading`
section in the README.

### Features
* Allow for multiple directors
* Move to data in modules entirely dropping params class

### Testing
* Drop older versions of puppet and ruby from test matrix
* Test all primary classes with improved platform coverage
* Lint ruby code for rubocop compliance

## 2017-01-18 4.1.0
### Summary
Testing updates, bug fix, and more usage of hiera.

### Bugfixes
 - Only include an Append in messages when its been requested

### Testing
 - Drop puppet 4.2 from testing to allow data_provider from heira
 - Include newer Puppet versions in testing

### Features
 - Allow the director messages to be configurable using hiera

## 2017-01-17 4.0.1
### Summary
This release contains small bugfixes and a couple feature tweaks.

#### Bugfixes
 - Fix SELinux setype on file type storage devices
 - Fix parameter pass through for client options

#### Features
 - Sort the jobs by name in config to be reflected in bconsole
 - Disable diff for secret-containing files, keeping puppetdb clean

## 2016-07-29 4.0.0
### Summary
This release contains backwards incompatible changes.

#### Features
 - Native Puppet4 module data and type validation
 - Drop support for puppet 3.x
 - database make-tables script has been removed in favor of packaged scripts

## 2016-04-04 3.0.1
### Summary
This release contains bugfixes and testing updates for puppet4.

#### Testing
- Add puppet4 for the test matrix
- Include ipaddress fact in testing

#### Features
- Allow user specified device mode on bacula::storage

## 2015-10-20 Release 3.0.0
### Summary

This release contains breaking changes to how director and storage daemon
hostnames are referred to in the params class.  **Users will need to remove any
instances of the deprecated variables and replace them.**  See the README.

#### Features
- Clean up template whitespace
- Relocate templates to match daemon namespace context
- Clean up documentation and add notes about upgrading
- Default pools 'Inc' and 'Full' are no longer created.  Users are now required
  to define the required pools explicitly.
- Modify client pool parameters to expose desired pool information
- Add documentation on creating pools per above

## 2015-10-18 Release 2.0.2
### Summary
This release contains improvements to IP address handling to better support
IPv6 for all components of the bacula system.

#### Features
- Add function to validate and determine the inet family of an IP
- Centralize address handling in single template and instrument

## 2015-10-17 Release 2.0.1
### Summary
This release contains bugfixes.

#### Bugfixes
- Use the correct client address variable for the director resource

## 2015-10-15 Release 2.0.0
### Summary

### Features
This release drops a dependency on the ploperations/puppet module by
implementing a parameter 'ssl_dir' allowing/requiring the user to specify the
directory to retrieve the Puppet SSL data.

