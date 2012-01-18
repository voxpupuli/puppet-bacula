require 'pp'
require 'yaml'

Puppet::Parser::Functions::newfunction(:genpass, :type => :rvalue) do |args|
  store   = lookupvar('fqdn')
  search  = args[0]
  datadir = '/etc/puppet/Pdubs'
  datastore = "#{datadir}/#{store}.yaml"

  unless File.directory?(datadir)
    Puppet::info "Creating datadir #{datadir}"
    Dir.mkdir(datadir)
    raise Puppet::Error, "Data directory #{datadir} was not created" unless File.directory?(datadir)
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
  data["#{search}"]
end

