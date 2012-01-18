#!/usr/bin/env ruby

require 'pp'
require 'yaml'

module Puppet::Parser::Functions
  newfunction(:genpass) do |args|
    store   = lookupvar('hostname')
    search  = args[0]
    datadir = '/etc/puppet/data'
    datastore = "#{datadir}/#{store}.yaml"
    Dir.mkdir(datadir) unless File.directory?(datadir)

    data = {}
    if File.exists?(datastore)
      data = YAML::load(File.open(datastore))
    else
      o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten;
      string  =  (0..50).map{ o[rand(o.length)]  }.join;
      data["#{search}"] = string
      File.open(datastore, "w") do |f|
        f.write(data.to_yaml)
      end
    end
    data["#{search}"]
  end
end





