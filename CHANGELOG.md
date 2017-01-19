## Unreleased
- Add support for multiple directors

## 2017-01-18 4.1.0
### Summary
Testing updates, bug fix, and more usage of hiera.

### Bugfixes
 - Only include an Append in messages when its been requested

### Testing
 - Drop puppet 4.2 from testing to allow data_provider from heira
 - Include newer Puppet versions in testing

### Features
 - Allow the directory messages to be configurable using hiera

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

