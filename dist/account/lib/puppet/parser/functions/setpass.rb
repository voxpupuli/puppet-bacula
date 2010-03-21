require 'yaml'
module Puppet::Parser::Functions
  YAMLDIR = '/etc/puppet/userpw'
  newfunction(:setpass, :type => :rvalue ) do |args| 
    passfile = File.join(YAMLDIR, "#{args[0]}.yml")
      if FileTest.exist?(passfile) && data = YAML.load_file(passfile)
        data['password']   
      else
        return ''
      end
  end
end
