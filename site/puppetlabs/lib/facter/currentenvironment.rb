Facter.add("currentenvironment") do
  path = '/usr/bin/puppet'
  setcode do
    %x{#{path} /usr/bin/puppet --configprint environment}.chomp
  end
end
