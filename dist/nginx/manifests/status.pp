class nginx::status {

  nginx::vhost { "status":
    template => "nginx/vhost-status.conf.erb"
  }

}
