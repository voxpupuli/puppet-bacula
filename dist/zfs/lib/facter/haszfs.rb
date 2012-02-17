Facter.add("haszfs") do
  setcode do
    if %x{mount} !~ /zfs/
      false
    else
      true
    end
  end
end
