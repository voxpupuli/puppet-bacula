class puppetlabs::service::pkgrepo {


  file {
    "/usr/local/bin/repo_perms.sh":
      owner  => root,
      group  => root,
      mode   => 0755,
      source => "puppet:///modules/puppetlabs/repo_perms.sh";
  }

  ###
  # Package repositories
  #
  class { "apt::server::repo": site_name => "apt.puppetlabs.com"; }
  include yumrepo


}

