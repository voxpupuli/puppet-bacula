class puppetlabs::service::pkgrepo (
  $ensure = present
) {
  ###
  # Package repositories
  #

  file {
    "/usr/local/bin/repo_perms.sh":
      ensure => $ensure,
      owner  => root,
      group  => root,
      mode   => 0755,
      source => "puppet:///modules/puppetlabs/repo_perms.sh";
  }

  file {
    "/usr/local/bin/repo_wrapper.rb":
      ensure => $ensure,
      owner  => root,
      group  => root,
      mode   => 0755,
      source => "puppet:///modules/puppetlabs/repo_wrapper.rb";
  }

  cron {
    "/usr/local/bin/repo_perms.sh":
      ensure  => $ensure,
      user    => root,
      command => "/usr/local/bin/repo_perms.sh",
      minute  => "*/10";
  }
  if $ensure == present {
    nagios::website { 'apt.puppetlabs.com': }
    nagios::website { 'yum.puppetlabs.com': }
    class { "apt::server::repo": site_name => "apt.puppetlabs.com"; }
    include yumrepo

    Package <| title == "gnupg-agent" |>
  }

  rsync::server {
    "packages":
      comment => "Puppet Labs Package Repository",
      path    => "/opt/repository",
      exclude => "apt/*/logs/*** apt/*/conf/*** apt/*/db/***",

  }

}

