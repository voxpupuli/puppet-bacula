class puppetlabs::vanir {

  class { "apt-cacher": }

#  cron {
#    "pull ~zach/src/puppetlabs-modules":
#      command => "source ~/.keychain/wyrd.sh && (cd ~zach/src/puppetlabs-modules/; git pull)",
#      user    => zach,  minute => '*/10';
#  }

#  apache::vhost {
#    "$fqdn":
#      port    => 80,
#      docroot => '/opt/www'
#  }

}

