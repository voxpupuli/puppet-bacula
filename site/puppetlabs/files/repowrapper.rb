#! /usr/bin/env ruby

require 'pp'

apt_base = '/opt/repository/apt'
keychain_cmd = "keychain -q --agents gpg --timeout 120 4BD6EC30"
downloads = "apu.puppetlabs.com:/var/www/puppetlabs.com/downloads"

# Start Keychain
puts "Starting keychain..."
`#{keychain_cmd}`

class Array
  def get_debs
    @debs = []
    self.each do |file|
      @debs << file if file =~ /deb$/
    end
    @debs
  end

  def get_changes
    @changes = []
    self.each do |file|
      @changes << file if file =~ /changes$/
    end
    @changes
  end

end

Dir.glob("#{apt_base}/*").each do |repo|
  incoming = "#{repo}/incoming"
  # only operate if there is an incoming directory
  if File.directory?("#{incoming}") == true 
    files = Dir.entries("#{incoming}") - ['.','..']
    # proceed if the incoming directory is not empty
    if files.length > 0
      Dir.chdir(repo)
      # get a list of distributions to operate on
      dists = File.read('conf/distributions').grep(/Codename/).each do |line|
        dist = line.split(' ').last.chomp
        files.get_debs.each do |deb|
          cmd = "reprepro includedeb #{dist} incoming/#{deb}"
          `#{cmd}`
        end

        files.get_changes.each do |changefile|
          cmd = "reprepro include #{dist} incoming/#{changefile}"
          `#{cmd}`
        end
      end
    end
  end

end

