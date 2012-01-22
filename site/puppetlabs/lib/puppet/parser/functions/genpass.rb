require 'pp'
require 'yaml'

def generate
  o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten;
  (0..50).map{ o[rand(o.length)]  }.join;
end

def writefile (f, stuff)
  File.open(f, "w") do |f|
    f.write(stuff)
  end
end

Puppet::Parser::Functions::newfunction(:genpass, :type => :rvalue) do |args|
  store   = lookupvar('fqdn')
  search  = args[0]
  datadir = "#{Puppet[:vardir]}/moduledata/pw"
  datastore = "#{datadir}/#{store}.yaml"

  unless File.directory?(datadir)
    Puppet::info "Creating datadir #{datadir}"
    Dir.mkdir(datadir)
    raise Puppet::Error, "Data directory #{datadir} was not created" unless File.directory?(datadir)
  end

  data = {}
  data = YAML::load(File.open(datastore)) if File.exists?(datastore)
  Puppet.debug(data.inspect)

  unless data.has_key?("#{search}")
    data["#{search}"] = generate()
    writefile(datastore,data.to_yaml)
  end
  data["#{search}"]
end

