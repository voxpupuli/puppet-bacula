class grayskull::tools {

  file{ '/usr/local/sbin/ungrayskull.sh':
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    ensure => file,
    source => 'puppet:///modules/grayskull/ungrayskull.sh',
  }

}
