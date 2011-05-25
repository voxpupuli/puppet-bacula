class puppetlabs::forge-dev {

    class { 'forge':
        vhost       => 'forge-dev.puppetlabs.com',
        ssl         => false,
        newrelic    => false,
        do_ssh_keys => true,
    }

}
