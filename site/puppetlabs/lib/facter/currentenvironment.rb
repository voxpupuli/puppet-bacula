Facter.add("currentenvironment") do
  path = '/usr/bin/puppet'
  setcode do
    %x{#{path} --configprint environment}.chomp
  end
end
