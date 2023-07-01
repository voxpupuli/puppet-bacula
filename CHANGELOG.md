# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v7.0.0](https://github.com/voxpupuli/puppet-bacula/tree/v7.0.0) (2023-06-28)

[Full Changelog](https://github.com/voxpupuli/puppet-bacula/compare/v6.0.0...v7.0.0)

**Breaking changes:**

- Drop Puppet 6 support [\#182](https://github.com/voxpupuli/puppet-bacula/pull/182) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add support for Puppet 8 [\#185](https://github.com/voxpupuli/puppet-bacula/pull/185) ([smortex](https://github.com/smortex))
- Relax dependencies version requirements [\#184](https://github.com/voxpupuli/puppet-bacula/pull/184) ([smortex](https://github.com/smortex))

**Merged pull requests:**

- Use the namespaced function `postgresql::postgresql_password()` [\#186](https://github.com/voxpupuli/puppet-bacula/pull/186) ([smortex](https://github.com/smortex))

## [v6.0.0](https://github.com/voxpupuli/puppet-bacula/tree/v6.0.0) (2022-10-06)

[Full Changelog](https://github.com/voxpupuli/puppet-bacula/compare/5.8.0...v6.0.0)

**Breaking changes:**

- Allow to listen on multiple IP addresses [\#174](https://github.com/voxpupuli/puppet-bacula/pull/174) ([smortex](https://github.com/smortex))
- Drop support for Puppet 5 \(EOL\) [\#173](https://github.com/voxpupuli/puppet-bacula/pull/173) ([smortex](https://github.com/smortex))

**Implemented enhancements:**

- Allow up-to-date dependencies [\#177](https://github.com/voxpupuli/puppet-bacula/pull/177) ([smortex](https://github.com/smortex))
- Add support for up-to-date OSes [\#169](https://github.com/voxpupuli/puppet-bacula/pull/169) ([smortex](https://github.com/smortex))
- Allow the latest version of dependencies [\#167](https://github.com/voxpupuli/puppet-bacula/pull/167) ([smortex](https://github.com/smortex))
- Add support for "Mail on success" / "Mail on error" [\#160](https://github.com/voxpupuli/puppet-bacula/pull/160) ([smortex](https://github.com/smortex))

**Fixed bugs:**

- Fix legacy fact usage [\#175](https://github.com/voxpupuli/puppet-bacula/pull/175) ([smortex](https://github.com/smortex))

**Closed issues:**

- metadata.json has old dependencies [\#166](https://github.com/voxpupuli/puppet-bacula/issues/166)
- New puppetserver CA certs causes backup failures [\#165](https://github.com/voxpupuli/puppet-bacula/issues/165)

**Merged pull requests:**

- Update module documentation [\#176](https://github.com/voxpupuli/puppet-bacula/pull/176) ([smortex](https://github.com/smortex))
- Transfer the module to Voxpupuli [\#172](https://github.com/voxpupuli/puppet-bacula/pull/172) ([smortex](https://github.com/smortex))
- Drop support of OSes which have reached EOL [\#168](https://github.com/voxpupuli/puppet-bacula/pull/168) ([smortex](https://github.com/smortex))

## [5.8.0](https://github.com/voxpupuli/puppet-bacula/tree/5.8.0) (2020-08-29)

[Full Changelog](https://github.com/voxpupuli/puppet-bacula/compare/5.7.0...5.8.0)

**Implemented enhancements:**

- Add job var "Max Full Interval" [\#159](https://github.com/voxpupuli/puppet-bacula/pull/159) ([zachfi](https://github.com/zachfi))
- Ensure all parameters are documented [\#151](https://github.com/voxpupuli/puppet-bacula/pull/151) ([smortex](https://github.com/smortex))

**Fixed bugs:**

- Output OperatorCommand before Operator [\#153](https://github.com/voxpupuli/puppet-bacula/pull/153) ([smortex](https://github.com/smortex))

**Merged pull requests:**

- Fix CI [\#158](https://github.com/voxpupuli/puppet-bacula/pull/158) ([smortex](https://github.com/smortex))

## [5.7.0](https://github.com/voxpupuli/puppet-bacula/tree/5.7.0) (2020-05-02)

[Full Changelog](https://github.com/voxpupuli/puppet-bacula/compare/5.6.0...5.7.0)

**Fixed bugs:**

- Rename of script used to create the PostgreSQL tables [\#148](https://github.com/voxpupuli/puppet-bacula/pull/148) ([Tamerz](https://github.com/Tamerz))

## [5.6.0](https://github.com/voxpupuli/puppet-bacula/tree/5.6.0) (2019-12-28)

[Full Changelog](https://github.com/voxpupuli/puppet-bacula/compare/5.5.1...5.6.0)

**Implemented enhancements:**

- Make it easier to set $make\_bacula\_tables [\#146](https://github.com/voxpupuli/puppet-bacula/pull/146) ([fraenki](https://github.com/fraenki))
- Use the configured DH parameters with all services [\#143](https://github.com/voxpupuli/puppet-bacula/pull/143) ([smortex](https://github.com/smortex))
- Minor README fixes [\#142](https://github.com/voxpupuli/puppet-bacula/pull/142) ([smortex](https://github.com/smortex))
- No more lookup [\#141](https://github.com/voxpupuli/puppet-bacula/pull/141) ([smortex](https://github.com/smortex))
- "write bootstrap" & "full/diff backup pool" [\#139](https://github.com/voxpupuli/puppet-bacula/pull/139) ([tmanninger](https://github.com/tmanninger))

**Fixed bugs:**

- Fix jobs' $selection\_pattern [\#144](https://github.com/voxpupuli/puppet-bacula/pull/144) ([smortex](https://github.com/smortex))
- Fix wrong database initialization [\#140](https://github.com/voxpupuli/puppet-bacula/pull/140) ([smortex](https://github.com/smortex))

**Closed issues:**

- future maintenance and collaboration [\#136](https://github.com/voxpupuli/puppet-bacula/issues/136)

## [5.5.1](https://github.com/voxpupuli/puppet-bacula/tree/5.5.1) (2019-02-27)

[Full Changelog](https://github.com/voxpupuli/puppet-bacula/compare/5.5.0...5.5.1)

**Implemented enhancements:**

- Switch to Bacula 9 on FreeBSD [\#133](https://github.com/voxpupuli/puppet-bacula/pull/133) ([smortex](https://github.com/smortex))
- Added option to not include the director defaults [\#132](https://github.com/voxpupuli/puppet-bacula/pull/132) ([tcassaert](https://github.com/tcassaert))
- Switch ERB to EPP templates, improve parameters validation [\#128](https://github.com/voxpupuli/puppet-bacula/pull/128) ([smortex](https://github.com/smortex))
- Improve $packages data-types consistency [\#126](https://github.com/voxpupuli/puppet-bacula/pull/126) ([smortex](https://github.com/smortex))
- Normalize logging accross services [\#123](https://github.com/voxpupuli/puppet-bacula/pull/123) ([smortex](https://github.com/smortex))
- minor improvements to make some params more forgiving [\#120](https://github.com/voxpupuli/puppet-bacula/pull/120) ([jflorian](https://github.com/jflorian))

**Fixed bugs:**

- Fix variable name @director\_name -\> @director [\#124](https://github.com/voxpupuli/puppet-bacula/pull/124) ([smortex](https://github.com/smortex))

**Closed issues:**

- Virtual resource [\#101](https://github.com/voxpupuli/puppet-bacula/issues/101)

**Merged pull requests:**

- Update supported dependencies versions [\#130](https://github.com/voxpupuli/puppet-bacula/pull/130) ([smortex](https://github.com/smortex))
- Switch to Hiera 5 [\#129](https://github.com/voxpupuli/puppet-bacula/pull/129) ([smortex](https://github.com/smortex))
- Modernize and fix style [\#127](https://github.com/voxpupuli/puppet-bacula/pull/127) ([smortex](https://github.com/smortex))
- Remove unused template [\#125](https://github.com/voxpupuli/puppet-bacula/pull/125) ([smortex](https://github.com/smortex))
- Use ensure\_packages to simpify packages management [\#122](https://github.com/voxpupuli/puppet-bacula/pull/122) ([smortex](https://github.com/smortex))

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



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
