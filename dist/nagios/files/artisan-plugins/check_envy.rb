#!/usr/bin/env ruby
#

require 'optparse'

Okay     = 0
Warning  = 1
Critical = 2
Unknown  = 3


def getenv
  env = nil
  ['/etc/puppet/puppet.conf', '/etc/puppetlabs/puppet/puppet.conf' ].each do |puppetconf|
    next unless File.exists? puppetconf

    begin
      envs = IO.readlines( puppetconf ).grep( /^\s*environment\s*\s=\s(\w+)\s?/ ).last
      if envs
        envs.chomp!
        env = envs.split( /=/ ).last.strip
      end
    rescue => e
      $stderr.puts "Failed to read #{puppetconf} with #{e}"
      exit Unknown
    end
  end
  env
end



opts = {}
OptionParser.new do |opti|
  opti.on("-e", "--environment ENV", "What environment it should be") do |e|
    opts[:environment] = e
  end
end.parse!



shouldbe = opts[:environment] || 'production'
env = getenv()

if env.nil?
  puts "Critical: Couldn't find an env at all"
  exit Critical
elsif shouldbe != env
  puts "Warn: Env is #{env} and not #{shouldbe}"
  exit Warning
else
  puts "OK: Env is #{env}"
  exit Okay
end
