class yum {
  package { ['yum', 'yum-priorities']:
    ensure => latest,
  }
  $yumdir = '/etc/yum.repos.d'
  File { owner => 'root', group => 'root', mode => '0644' }
  file { $yumdir: 
    ensure => directory, 
    purge => true,
    recurse => true,
  }
  file {
    "${yumdir}/epel.repo": source => 'puppet:///yum/epel.repo';
    "${yumdir}/epel-testing.repo": source => 'puppet:///yum/epel-testing.repo';
    "${yumdir}/CentOS-Base.repo": source => 'puppet:///yum/CentOS-Base.repo';
    #"${yumdir}/CentOS-Media.repo": source => 'puppet:///yum/CentOS-Media.repo';
    "${yumdir}/local-arch.repo": source => 'puppet:///yum/local-arch.repo';
    "${yumdir}/local-noarch.repo": source => 'puppet:///yum/local-noarch.repo';
  }
} 
