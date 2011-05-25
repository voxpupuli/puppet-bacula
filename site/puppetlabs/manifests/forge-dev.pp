class puppetlabs::forge-dev {

    include postfix

    class { 'forge':
        vhost       => 'forge-dev.puppetlabs.com',
        ssl         => false,
        newrelic    => false,
        do_ssh_keys => true,
        github_url  => 'git@github.com:puppetlabs/puppet-module-site.git',
    }

}
