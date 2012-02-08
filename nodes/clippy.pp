# = Node: clippy
#
# == Description
#
# This node hosts downloads for puppet products, so such things as
# yum.puppetlabs.com, apt.puppetlabs.com, downloads.puppetlabs.com, and other
# roles.
#
# This host should be accessible to anyone that needs to administer releases,
# such as the enterprise release team, solutions, and professional services.
#
# == Other names
#
# - git.puppetlabs.lan
# - git.puppetlabs.net
node clippy {
  include role::server
  include service::gitolite

  sudo::allowgroup  { "techops": }
  ssh::allowgroup   { "techops": }

  gpg::agent { "git":
    options => [
      "--default-cache-ttl 999999999",
      "--max-cache-ttl     999999999",
      "--use-standard-socket",
    ],
  }

  duplicity::cron { "/home/git":
    user           => "git",
    target         => "ssh://gitbackups@bacula01.puppetlabs.lan:22//bacula/duplicity/git.puppetlabs.net",
    gpg_agent_info => "/home/git/.gpg-agent-info",
    mailto         => '""',
    options        => [
      "--encrypt-key 409D0688",
      "--sign-key 409D0688",
      "--use-agent",
    ],
  }
}
