require 'pp'
require 'yaml'

Puppet::Parser::Functions::newfunction(:genpass, :type => :rvalue) do |args|
  store   = lookupvar('hostname')
  search  = args[0]
  datadir = '/etc/puppet/Pdubs'
  datastore = "#{datadir}/#{store}.yaml"

  unless File.directory?(datadir)
    Puppet::info "Creating datadir #{datadir}"
    Dir.mkdir(datadir)
  end

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
  Puppet.info data["#{search}"]
  data["#{search}"]
end

