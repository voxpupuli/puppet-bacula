# Net01 network management node
#
# for things like DNS, DHCP, and friends. 

node net01 {

  include role::server
  include git

  ssh::allowgroup   { "techops": }
  sudo::allowgroup  { "techops": }

  # rsyslog hackery.
  file{ '/etc/rsyslog.d/aruba.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppetlabs/net01_rsyslog_aurba.conf',
  }

  file{ '/etc/rsyslog.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppetlabs/net01_rsyslog.conf',
  }

  file{ '/etc/logrotate.d/aruba':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppetlabs/net01_logrotate_aruba',
  }

  service{ 'rsyslog':
    hasstatus  => true,
    hasrestart => true,
    ensure     => running,
    enable     => true,
    subscribe  => [ File['/etc/rsyslog.conf'],
                    File['/etc/rsyslog.d/aruba.conf'] ],
  }

  # DNS Stuff
  class { 'bind':
    customoptions => "check-names master ignore;\nallow-recursion {192.168.100.0/23; 10.0.0.0/16; };\n",
  }

  $ddnskeyname = 'dhcp_updater'
  bind::key { $ddnskeyname:
      algorithm => 'hmac-md5',
      secret    => 'S5acGh2LrqMeuRkFPmXFqw==',
  }

  bind::zone {
    'puppetlabs.lan':
      type         => 'master',
      initialfile  => 'puppet:///modules/bind/puppetlabs.lan.initial',
      allow_update => 'key "dhcp_updater"',
      require      => Bind::Key['dhcp_updater'];
    '100.168.192.in-addr.arpa':
      type         => 'master',
      initialfile  => 'puppet:///modules/bind/42.0.10.in-addr.arpa.initial',
      allow_update => 'key "dhcp_updater"',
      require      => Bind::Key['dhcp_updater'];
    'dc1.puppetlabs.net':
      type          => 'slave',
      masters       => '10.0.1.20',
      require       => Bind::Key['dhcp_updater'];
    '1.0.10.in-addr.arpa':
      type          => 'slave',
      masters       => '10.0.1.20',
      require       => Bind::Key['dhcp_updater'];
    '5.0.10.in-addr.arpa':
      type          => 'slave',
      masters       => '10.0.1.20',
      require       => Bind::Key['dhcp_updater'];
    '42.0.10.in-addr.arpa':
      type          => 'slave',
      masters       => '10.0.1.20',
      require       => Bind::Key['dhcp_updater'];
  }

  include git
  include bind::params

  exec { "ensure dns-zone repo exists":
    path    => ["/usr/bin", "/usr/local/bin"],
    command => "git clone git@git.puppetlabs.net:puppetlabs-dnszones.git /opt/dns",
    creates => "/opt/dns/.git",
  }

  cron { "update dns zones":
    command => "(cd /opt/dns &&  git pull --quiet origin master && /opt/dns/zonedump.rb ${::domain}.ns | /usr/bin/nsupdate -v -k /etc/bind/keys.d/dhcp_updater) ",
    minute  => "*/5",
    user    => "root",
    require => Exec["ensure dns-zone repo exists"],
  }

  # DHCP
  class { 'dhcp':
    dnsdomain    => [
      'puppetlabs.lan',
      '100.168.192.in-addr.arpa',
      ],
    nameservers  => ['192.168.100.8'],
    ntpservers   => ['us.pool.ntp.org'],
    interfaces   => ['eth0'],
    dnsupdatekey => "/etc/bind/keys.d/$ddnskeyname",
    require      => Bind::Key[ $ddnskeyname ],
    pxeserver    => '10.0.1.50',
    pxefilename  => 'pxelinux.0',
  }

  dhcp::pool{ 'puppetlabs.lan':
    network => '192.168.100.0',
    mask    => '255.255.254.0',
    range   => '192.168.100.150 192.168.100.250',
    gateway => '192.168.100.1',
  }

  ##############################################################################
  # Jenkins acceptance testbed hosts
  ##############################################################################

  # Win2008r2 testbed (#12472)
  dhcp::host { "win2008r2-acceptance":
    mac => '00:50:56:b2:00:2a',
    ip  => '192.168.100.24',
  }

  # testbed
  dhcp::host { "sles-11-x64-2":
    mac => '00:50:56:b2:00:69',
    ip  => '192.168.100.37',
  }

  # testbed
  dhcp::host { "sles-11-i386-2":
    mac => '00:50:56:b2:00:68',
    ip  => '192.168.100.38',
  }

  # testbed
  dhcp::host { "oel-r4-u7-i386":
    mac => '00:50:56:b2:00:ae',
    ip  => '192.168.100.40',
  }

  # 
  dhcp::host { "centos-55-64-1":
    mac => '00:50:56:b2:00:0a',
    ip  => '192.168.100.50',
  }

  # 
  dhcp::host { "centos-55-386-1":
    mac => '00:50:56:b2:00:09',
    ip  => '192.168.100.51',
  }

  # Testbed
  dhcp::host { "ubuntu-1004-32-1":
    mac => '00:50:56:b2:00:19',
    ip  => '192.168.100.52',
  }

  # Testbed
  dhcp::host { "ubuntu-1004-64-1":
    mac => '00:50:56:b2:00:18',
    ip  => '192.168.100.53',
  }

  # TestBed Solaris 10u9 x86
  dhcp::host { "sol-10-u9-ga-x86":
    mac => '00:50:56:b2:00:31',
    ip  => '192.168.100.54',
  }

  # debian6-latest-amd64 for test harness
  dhcp::host { "debian6-latest-amd64":
    mac => '00:50:56:b2:00:3e',
    ip  => '192.168.100.58',
  }

  # debian6-latest-i386
  dhcp::host { "debian6-latest-i386":
    mac => '00:50:56:b2:00:3d',
    ip  => '192.168.100.59',
  }

  # testbed
  dhcp::host { "scientific60-i386":
    mac => '00:50:56:b2:00:44',
    ip  => '192.168.100.61',
  }

  # testbed
  dhcp::host { "scientific60-x86-64":
    mac => '00:50:56:b2:00:45',
    ip  => '192.168.100.62',
  }

  # testbed
  dhcp::host { "scientific5x-i386":
    mac => '00:50:56:b2:00:42',
    ip  => '192.168.100.63',
  }

  # testbed
  dhcp::host { "scientific5x-x86-64":
    mac => '00:50:56:b2:00:43',
    ip  => '192.168.100.64',
  }

  # 
  dhcp::host { "centos60-i386":
    mac => '00:50:56:b2:00:4b',
    ip  => '192.168.100.66',
  }

  # testbed
  dhcp::host { "centos60-x86-64":
    mac => '00:50:56:b2:00:4c',
    ip  => '192.168.100.67',
  }

  # 
  dhcp::host { "centos-55-386-3":
    mac => '00:50:56:b2:00:4e',
    ip  => '192.168.100.68',
  }

  # 
  dhcp::host { "centos-55-64-3":
    mac => '00:50:56:b2:00:4f',
    ip  => '192.168.100.69',
  }

  # 
  dhcp::host { "ubuntu-1004-32-2":
    mac => '00:50:56:b2:00:49',
    ip  => '192.168.100.70',
  }

  # 
  dhcp::host { "ubuntu-1004-64-2":
    mac => '00:50:56:b2:00:4a',
    ip  => '192.168.100.71',
  }

  # testbed
  dhcp::host { "oel-r6-u1-x86-64":
    mac => '00:50:56:b2:00:55',
    ip  => '192.168.100.73',
  }

  # testbed
  dhcp::host { "oel-r5-u6-x86-64":
    mac => '00:50:56:b2:00:54',
    ip  => '192.168.100.74',
  }

  # testbed
  dhcp::host { "debian5-latest-i386":
    mac => '00:50:56:b2:00:38',
    ip  => '192.168.100.80',
  }

  # testbed
  dhcp::host { "debian5-latest-amd64":
    mac => '00:50:56:b2:00:37',
    ip  => '192.168.100.81',
  }

  # testbed
  dhcp::host { "sles-11-586-1":
    mac => '00:50:56:b2:00:22',
    ip  => '192.168.100.84',
  }

  # testbed
  dhcp::host { "centos4-latest-x86-64":
    mac => '00:50:56:b2:00:33',
    ip  => '192.168.100.85',
  }

  # testbed
  dhcp::host { "centos4-latest-i386":
    mac => '00:50:56:b2:00:32',
    ip  => '192.168.100.86',
  }

  # testbed
  dhcp::host { "centos40-i386":
    mac => '00:50:56:b2:00:30',
    ip  => '192.168.100.87',
  }

  # testbed
  dhcp::host { "centos40-x86-64":
    mac => '00:50:56:b2:00:2f',
    ip  => '192.168.100.88',
  }

  # testbed
  dhcp::host { "rhel5-latest-x86-64":
    mac => '00:50:56:b2:00:14',
    ip  => '192.168.100.89',
  }

  # tb system for rhel6-64
  dhcp::host { "rhel6-64-1":
    mac => '00:50:56:b2:00:02',
    ip  => '192.168.100.98',
  }

  # testbed
  dhcp::host { "rhel60-i386":
    mac => '00:50:56:b2:00:2c',
    ip  => '192.168.100.105',
  }

  # testbed
  dhcp::host { "rhel5-latest-i386":
    mac => '00:50:56:b2:00:25',
    ip  => '192.168.100.111',
  }

  # testbed
  dhcp::host { "rhel50-x86-64":
    mac => '00:50:56:b2:00:2d',
    ip  => '192.168.100.112',
  }

  # testbed
  dhcp::host { "rhel50-i386":
    mac => '00:50:56:b2:00:2e',
    ip  => '192.168.100.113',
  }

  # 
  dhcp::host { "rhel6-32-1":
    mac => '00:50:56:b2:00:29',
    ip  => '192.168.100.114',
  }

  # open solairs dev box
  dhcp::host { "dev-osol-x86":
    mac => '00:0c:29:57:23:26',
    ip  => '192.168.100.117',
  }

  # testbed
  dhcp::host { "oel-r4-u7-x86-64":
    mac => '00:50:56:b2:00:15',
    ip  => '192.168.100.118',
  }

  # testbed
  dhcp::host { "rhel60-x86-64":
    mac => '00:50:56:b2:00:2b',
    ip  => '192.168.100.135',
  }

  # testbed
  dhcp::host { "rhel6-latest-x86-64":
    mac => '00:50:56:b2:00:12',
    ip  => '192.168.100.136',
  }

  # testbed
  dhcp::host { "rhel6-latest-i386":
    mac => '00:50:56:b2:00:11',
    ip  => '192.168.100.137',
  }

  # rhel6-mock vm
  dhcp::host { "rhel6-mock":
    mac => '00:50:56:b2:00:1e',
    ip  => '192.168.100.138',
  }

  # sles-11-64-1 for testbed
  dhcp::host { "sles-11-64-1":
    mac => '00:50:56:b2:00:23',
    ip  => '192.168.100.139',
  }
  # centos-55-64-2
  dhcp::host { "centos-55-64-2":
    mac => '00:50:56:b2:00:21',
    ip  => '192.168.100.145',
  }

  # centos-55-386-2
  dhcp::host { "centos-55-386-2":
    mac => '00:50:56:b2:00:20',
    ip  => '192.168.100.146',
  }

  # Windows 2003 R2 SP2 testbed (#12284)
  dhcp::host { 'win2003r2-acceptance':
    mac => '00:50:56:3f:11:3a',
    ip  => '192.168.100.65',
  }

  ##############################################################################
  # Release engineering builder hosts
  ##############################################################################

  # (#11498) Lion VM for release eng
  dhcp::host { "osx-builder":
    mac => '00:0c:29:22:f2:5a',
    ip  => '192.168.100.29',
  }

  # Release Eng. solaris builder #11354
  dhcp::host { "sol10-builder":
    mac => '00:50:56:b2:00:6a',
    ip  => '192.168.100.104',
  }

  # Package Builder for Debs
  dhcp::host { "deb-builder":
    mac => '00:50:56:b2:00:46',
    ip  => '192.168.100.100',
  }

  # Mock box
  dhcp::host { "rpm-builder":
    mac => '00:50:56:b2:00:47',
    ip  => '192.168.100.78',
  }

  # build host for SLES packages
  dhcp::host { "sles-builder":
    mac => '00:50:56:b2:00:d1',
    ip  => '192.168.100.41',
  }

  dhcp::host { "win-builder":
    mac => '00:50:56:a1:4c:84',
    ip  => '192.168.100.122'
  }


  ##############################################################################
  # Jenkins testbed drivers
  ##############################################################################

  dhcp::host { "tb-driver":
    mac => '00:50:56:b2:00:0b',
    ip  => '192.168.100.49',
  }

  # #9298
  dhcp::host { "slave-tb":
    mac => '00:50:56:b2:00:9d',
    ip  => '192.168.100.95',
  }

  # #9298
  dhcp::host { "slave-tb2":
    mac => '00:50:56:b2:00:9e',
    ip  => '192.168.100.126',
  }

  ##############################################################################
  # Jenkins slaves
  ##############################################################################
  # SLES 11 slave for Jenkins
  dhcp::host { "slave-sles11":
    mac => '00:50:56:b2:00:97',
    ip  => '192.168.100.47',
  }

  dhcp::host { "slave10":
    mac => '99:90:99:90:99:91',
    ip  => '192.168.100.144',
  }


  # hudson slave for ruby 1.9
  dhcp::host { "slave1-9":
    mac => '00:50:56:b2:00:1d',
    ip  => '192.168.100.121',
  }

  # hudson slave01
  dhcp::host { "slave01":
    mac => '00:50:56:b2:00:00',
    ip  => '192.168.100.119',
  }

  # hudson slave02
  dhcp::host { "slave02":
    mac => '00:50:56:b2:00:05',
    ip  => '192.168.100.109',
  }

  # slave03 for hudson
  dhcp::host { "slave03":
    mac => '00:0c:29:17:30:70',
    ip  => '192.168.100.108',
  }

  # slave for building packages
  dhcp::host { "slave06":
    mac => '00:50:56:b2:00:24',
    ip  => '192.168.100.91',
  }

  # slave for building packages
  dhcp::host { "slave05":
    mac => '00:50:56:b2:00:1f',
    ip  => '192.168.100.90',
  }

  # Jenkins slave
  dhcp::host { "dev-lucid-amd64":
    mac => '00:50:56:b2:00:07',
    ip  => '192.168.100.48',
  }

  ##############################################################################
  # Selenium testing
  ##############################################################################

  dhcp::host { 'selenium-win7-legacy':
    mac => '00:50:56:a1:4c:9c',
    ip  => '192.168.100.94',
  }

  dhcp::host { 'selenium-win7-current':
    mac => '00:50:56:a1:4c:9e',
    ip  => '192.168.100.60',
  }

  # ticket #9022
  dhcp::host { "selenium-test":
    mac => '00:50:56:b2:00:9a',
    ip  => '192.168.100.93',
  }

  ##############################################################################
  # Printers. Evil, wicked devices.
  ##############################################################################

  # Printer on ann's desk
  dhcp::host { "printer02":
    mac => '98:4b:e1:39:9f:6b',
    ip  => '192.168.100.82',
  }

  # Xerox Printer
  dhcp::host { "printer01":
    mac => '00:00:aa:e3:04:2c',
    ip  => '192.168.100.96',
  }

  ##############################################################################
  # Operations production
  ##############################################################################

  # Mrepo Machine
  dhcp::host { "yo":
    mac => '00:50:56:b2:00:1b',
    ip  => '192.168.100.143',
  }

  # IPv6 tunnel box.
  dhcp::host { 'veesix':
    mac => '00:50:56:b2:00:72',
    ip  => '192.168.100.254'
  }

  # opsteam management
  dhcp::host { "net01":
    mac => '00:50:56:b2:0:34',
    ip  => '192.168.100.8',
  }

  # Customer dropbox #11518
  dhcp::host { "odin":
    mac => '00:50:56:b2:00:74',
    ip  => '192.168.100.19',
  }

  # (#12222) app server
  dhcp::host { "jotunn":
    mac => '00:50:56:b2:00:7c',
    ip  => '192.168.100.31',
  }

  # Operations OSX VMWare Fusion host
  dhcp::host { "tupac":
    mac => '10:9a:dd:5b:5d:79',
    ip  => '192.168.100.28',
  }

  # Gitolite host
  dhcp::host { "clippy":
    mac => '00:50:56:b2:00:50',
    ip  => '192.168.100.72',
  }

  # Zach building a new Puppet master
  # also allegedly backup DNS
  dhcp::host { "wyrd":
    mac => '00:50:56:b2:00:1c',
    ip  => '192.168.100.76',
  }

  # mac mini server #2
  dhcp::host { "mawu":
    mac => 'c4:2c:03:0b:b6:e6',
    ip  => '192.168.100.83',
  }

  # New Graphite Box
  dhcp::host { "syn":
    mac => '00:50:56:b2:01:09',
    ip  => '192.168.100.77',
  }

  # the lan bacula server
  dhcp::host { "bacula01":
    mac => '00:50:56:b2:00:39',
    ip  => '192.168.100.79',
  }

  # Virtual Center Server
  dhcp::host { "vc01":
    mac => '00:50:56:a1:4c:83',
    ip  => '192.168.100.99',
  }

  # Proxy and PXE
  dhcp::host { "modi":
    mac => '00:50:56:b2:00:99',
    ip  => '192.168.100.102',
  }

  # Ubuntu proxy system
  dhcp::host { "vanir":
    mac => '00:50:56:b2:00:27',
    ip  => '192.168.100.123',
  }

  # PXE Builder
  dhcp::host { "urd":
    mac => '00:50:56:b2:00:0c',
    ip  => '192.168.100.129',
  }

  # Release engineering bastion
  dhcp::host { "pluto":
    mac => '00:50:56:b2:00:0e',
    ip  => '192.168.100.101',
  }

  # Mac Mini Server - Faro
  dhcp::host { "faro":
    mac => 'c4:2c:03:05:3a:4c',
    ip  => '192.168.100.125',
  }

  # Operations Windows 7
  dhcp::host { "ops-win7":
    mac => '00:50:56:b2:00:0f',
    ip  => '192.168.100.128',
  }

  # mac mini in the kitchen
  dhcp::host { "kitchenwall":
    mac => '28:37:37:17:4c:27',
    ip  => '192.168.100.133',
  }

  ##############################################################################
  # Operations staging/development
  ##############################################################################

  # Wordpress test box
  dhcp::host { "wordtodapress":
    mac => '00:50:56:b2:00:57',
    ip  => '192.168.100.18',
  }

  # test box for chiliproject
  dhcp::host { "projects2-dev":
    mac => '00:50:56:b2:00:62',
    ip  => '192.168.100.25',
  }

  # Web Staging Server
  dhcp::host { "webstage":
    mac => '00:50:56:b2:00:b2',
    ip  => '192.168.100.44',
  }

  # Redmine Development box
  dhcp::host { "redminedev":
    mac => '00:0c:29:4e:ed:c1',
    ip  => '192.168.100.103',
  }

  # Projects Development Site
  dhcp::host { "projects-dev":
    mac => '00:50:56:b2:00:16',
    ip  => '192.168.100.147',
  }

  # Forge/puppet modules development
  dhcp::host { "forge-dev":
    mac => '00:50:56:b2:00:36',
    ip  => '192.168.100.57',
  }

  ##############################################################################
  # Engineering test/development
  ##############################################################################

  # For James, testing auth on RHEL
  dhcp::host { "rhel-auth-tester":
    mac => '00:50:56:b2:00:b1',
    ip  => '192.168.100.45',
  }

  # Development Windows 7 
  dhcp::host { "dev-win7":
    mac => '00:0c:29:7f:01:a2',
    ip  => '192.168.100.110',
  }

  # Dev Box
  dhcp::host { "dev-centos01":
    mac => '00:0c:29:1c:13:b5',
    ip  => '192.168.100.115',
  }

  # Dev Box
  dhcp::host { "dev-ubuntu01":
    mac => '00:0c:29:3a:12:e6',
    ip  => '192.168.100.116',
  }

  # Lukes dev box
  dhcp::host { "lukedev01":
    mac => '00:50:56:b2:00:1a',
    ip  => '192.168.100.124',
  }

  # (#11702) 2k3 dev server
  dhcp::host { "win2k3-dev":
    mac => '00:50:56:b2:00:7a',
    ip  => '192.168.100.30',
  }

  # Postgres box for dev work.
  dhcp::host { "vor.puppetlabs.lan":
    mac => '00:50:56:b2:00:98',
    ip  => '192.168.100.46',
  }

  ##############################################################################
  # Access points
  ##############################################################################

  # Aruba AP 3 (mark/admin)
  dhcp::host { "arubaap3":
    mac => '00:0b:86:cf:b2:4f',
    ip  => '192.168.100.251',
  }

  # Aruba AP (couches)
  dhcp::host { "arubaap4":
    mac => '00:0b:86:cf:ac:19',
    ip  => '192.168.100.252',
  }

  # Dev Access Point
  dhcp::host { "arubaap5":
    mac => '00:24:6c:c9:36:ef',
    ip  => '192.168.100.253',
  }

  ##############################################################################
  # Sales Engineering/Demo boxes
  ##############################################################################

  # Gateway Machine for Dhogland's Lan
  dhcp::host { "fw-selab":
    mac => '00:50:56:b2:00:08',
    ip  => '192.168.100.92',
  }

  # JJM - Tomcat 0 Gold Master for Demo
  dhcp::host { "tomcat0":
    mac => '00:16:36:45:21:ec',
    ip  => '192.168.100.140',
  }

  # Tomcat 1 VM
  dhcp::host { "tomcat1":
    mac => '00:16:36:45:21:d0',
    ip  => '192.168.100.141',
  }

  # Tomcat VM
  dhcp::host { "tomcat2":
    mac => '00:16:36:45:21:d1',
    ip  => '192.168.100.142',
  }

  # Jeff 2011-09-21 PuppetConf PuppetMaster Demo Machine.  This reservation may be removed after PuppetConf but please talk to Jeff.
  dhcp::host { "puppetmaster":
    mac => '00:50:56:b2:00:f3',
    ip  => '192.168.100.42',
  }

  ##############################################################################
  # Testing hardware(ish)
  ##############################################################################

  # Adrien's AIX Box
  # It's not my damn box. I disavow any knowledge of that hateful device.
  dhcp::host { "aix":
    mac => '00:14:5e:96:87:90',
    ip  => '192.168.100.43',
  }

  # hpux box
  dhcp::host { "hpux":
    mac => '00:30:6e:39:86:9e',
    ip  => '192.168.100.97',
  }

  # Juniper for Nan/Tumblr.
  dhcp::host { "junos":
    mac => '88:e0:f3:68:dd:1',
    ip  => '192.168.100.27',
  }

  # Solaris sparc zone
  dhcp::host { "sol-10-sparc.test":
    mac => '99:90:99:90:99:90',
    ip  => '192.168.100.55',
  }

  # F5 BIGIP for Nan's testing
  dhcp::host { "pro-bigip":
    mac => '00:50:56:b2:00:5f',
    ip  => '192.168.100.75',
  }

  # Sun Sparc Netra 120
  dhcp::host { "netra":
    mac => '00:03:ba:14:c6:4b',
    ip  => '192.168.100.106',
  }

  ##############################################################################
  # Hypervisors
  ##############################################################################

  # Top Server
  dhcp::host { "tiki":
    mac => '00:25:90:33:68:2e',
    ip  => '192.168.100.22',
  }

  # Bottom Server
  dhcp::host { "soko":
    mac => '00:25:90:33:6a:80',
    ip  => '192.168.100.23',
  }

  # ESXI box, dl380 hardware.
  dhcp::host { "magni":
    mac => '0:1f:29:e0:11:de',
    ip  => '192.168.100.26',
  }

  # Dell T310 52B1KN1 eth0
  dhcp::host { "juok":
    mac => '84:2b:2b:19:f7:e3',
    ip  => '192.168.100.132',
  }

  # Dell T310 52B1KN1 eth0
  dhcp::host { "kaang":
    mac => '84:2b:2b:19:f3:92',
    ip  => '192.168.100.134',
  }

  # ProSvc Testing Machine
  dhcp::host { "hyel":
    mac => '00:26:2d:31:24:fd',
    ip  => '192.168.100.148',
  }

  # PS R&D Physical Machine (Gateway PC)
  dhcp::host { "gunab":
    mac => '00:26:2d:31:20:f1',
    ip  => '192.168.100.149',
  }

  ##############################################################################
  # Lights out management
  ##############################################################################

  dhcp::host { "pseudo-ilo-host":
    mac => 'de:fa:ce:df:ab:1e',
    ip  => '192.168.100.20',
  }

  dhcp::host { "pseudo-ilo-host2":
    mac => 'de:fa:ce:df:ab:1f',
    ip  => '192.168.100.21',
  }

  # Dell T310 52B1KN1
  dhcp::host { "juok-rac":
    mac => '84:2b:2b:19:f7:e5',
    ip  => '192.168.100.130',
  }

  # Dell T310 42B1KN1
  dhcp::host { "kaang-rac":
    mac => '84:2b:2b:19:f3:94',
    ip  => '192.168.100.131',
  }

  ##############################################################################
  # Misc boxes
  ##############################################################################

  # Nan's wiki box
  dhcp::host { "wiki":
    mac => '00:0c:29:27:cd:71',
    ip  => '192.168.100.120',
  }

  # OSQA Box
  dhcp::host { "qa":
    mac => '00:50:56:b2:00:04',
    ip  => '192.168.100.107',
  }

  # Selena mailinglist stats making box
  dhcp::host { "mysqlisrad":
    mac => '00:50:56:b2:01:06',
    ip  => '192.168.100.39',
  }

}
