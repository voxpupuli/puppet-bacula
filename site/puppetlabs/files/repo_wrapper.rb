#! /usr/bin/env ruby

require 'pp'

apt_base = '/opt/repository/apt'
# Start Keychain
puts "Starting agent..."
%x{bash -c "eval $(keychain -q --eval --agents gpg 4BD6EC30 --timeout 5)"}

repos = [
  '/opt/repository/apt/ubuntu',
  '/opt/repository/apt/debian',
  '/opt/repository/apt/ops',
]

#Dir.glob("#{apt_base}/*").each do |repo|
repos.each do |repo|
  puts "Working on #{repo}"
  incoming = "#{repo}/incoming"
  if File.directory?("#{incoming}") == true 
    files = Dir.entries("#{incoming}") - ['.','..']
    if files.length > 0
      Dir.chdir(repo)
      # Do something useful here
      dists = File.read('conf/distributions').grep(/Codename/).each do |line|
        dist = line.split(' ').last.chomp
        cmdlist = []
        cmdlist << "reprepro -b #{repo} includedeb #{dist} #{incoming}/*.deb"
        cmdlist << "reprepro -b #{repo} include #{dist} #{incoming}/*.changes"
        cmdlist.each do |cmd|
          `#{cmd}`
        end
      end
    end
  end
end

