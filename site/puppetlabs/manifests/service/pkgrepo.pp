class puppetlabs::service::pkgrepo {

  file {
    "/usr/local/bin/repo_perms.sh":
      owner  => root,
      group  => root,
      mode   => 0755,
      source => "puppet:///modules/puppetlabs/repo_perms.sh";
  }

  file {
    "/usr/local/bin/repo_wrapper.rb":
      owner  => root,
      group  => root,
      mode   => 0755,
      source => "puppet:///modules/puppetlabs/repo_wrapper.sh";
  }

  cron {
    "/usr/local/bin/repo_perms.sh":
      user    => root,
      command => "/usr/local/bin/repo_perms.sh",
      minute  => "*/10";
  }

  ###
  # Package repositories
  #
  nagios::website { 'apt.puppetlabs.com': }
  nagios::website { 'yum.puppetlabs.com': }
  class { "apt::server::repo": site_name => "apt.puppetlabs.com"; }
  include yumrepo


}

