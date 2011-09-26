Facter.add("lastuser") do
  setcode do
    %x{last | awk '/^[^root].* console / {print $1}' | sort -r | uniq -c | awk '{ print $2 }' | head -n 1}.chomp
  end
end
