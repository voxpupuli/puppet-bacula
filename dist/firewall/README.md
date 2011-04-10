#Puppet Firewall Management Module

Puppet module to manage firewall rules.

##Overview

This module provides a new type, firewall, for managing firewall rules. Only iptables and ip6 tables are supported at the moment, though ipfw, pf, and ipf support is planned for future releases.

Currently, the iptables provider determines whether a rule exists using the name as a comment. Some older distros do not support iptables comments, which can cause issues.

If your current ruleset does not have comments, all new rules are inserted in order above them.

This module was started as a replacement for the current [iptables module](https://github.com/camptocamp/puppet-iptables). As such, the interface has been left intact to allow users to easily migrate from one provider to the other.

##Usage
###iptables

    firewall { "0001-example-rule":
      iniface => 'lo',
      chain   => 'INPUT',
      jump    => 'ACCEPT'
    }

##Future Work

- Determine whether iptables supports comments and, if not, find a different way of diffing the rules
- Refactor type to allow for additional providers
- Find a way to create provider unit tests
- Support for negations

##Copyright

Copyright (c) 2011 (mt) Media Temple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
