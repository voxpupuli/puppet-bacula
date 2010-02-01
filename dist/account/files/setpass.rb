#!/usr/bin/ruby

#
# Creates a password database on the Puppetmaster.
#

require 'openssl'
require 'yaml'

if ARGV[0]
  user = ARGV[0] 
else
  user = ENV['login']
end

puts "Setting password for user #{user}"

YAMLDIR = '/etc/puppet/userpw'
@passinfo = ''

def setpasswd(user)
  passfile = File.join(YAMLDIR, "#{user}.yml")
  if FileTest.exist?(YAMLDIR)
    puts 'Enter new password'
    begin
      system "stty -echo"
      password = STDIN.gets.chomp
    ensure
      system "stty echo"
    end
    #@passinfo = { 'password' => "#{OpenSSL::Digest::SHA512.new(password)}" }
    @passinfo = { 'password' => %x{mkpasswd -m SHA-512 #{password}}.chomp }
    File.open("#{passfile}", 'w') { |f| f.puts @passinfo.to_yaml }
  end
end

setpasswd(user) 
