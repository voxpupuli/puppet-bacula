Things to fix on baal
===

infra
---
* openvpn should get keys written
* nagios needs postfix
* Make sure the logfile exists for unbound

bacula
---
* bacula/ needs persmissions for the files
* bacula file daemon pid in config conflics with init.d causing /etc/init.d/bacula-fd status to fail

gearman
---
* added sources.list.d/wheezy.list for modgearman stuff
  * apt pinning for gearman packages
* need to add broker configuration to nagios
/etc/nagios3/gearman.conf
* need to add services for `check_gearman`

puppet
---
* need to get certificates into puppet dashboard for inventory service
* inventory needs settings.yaml template
* max post size on nginx may need help:
    http://wiki.nginx.org/HttpCoreModule#client_max_body_size


