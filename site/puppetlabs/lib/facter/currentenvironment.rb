Facter.add("currentenvironment") do
  setcode do
    %x{grep environment /etc/puppet/puppet.conf}.split(" ").last.chomp
  end
end
