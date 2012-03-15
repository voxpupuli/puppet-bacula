# = Class: service::docs
#
# == Purpose
#
# Allow shell access for the documentation deploy user
#
class service::docs {

  # The deploy user is used for the automated deployment of documentation.
  # see https://github.com/puppetlabs/puppet-docs/blob/master/config/deploy.rb
  # for the Rest of the Story (TM)
  ssh::allowgroup { "www-data": }
  Account::User <| tag == 'deploy' |>
  Ssh_authorized_key <| tag == 'deploy' |>

}
