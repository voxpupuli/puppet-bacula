# = Fact: bacula_config
#
# == Resolutions
#
# If a bacula client configuration exists, extract the password from that.
#
Facter.add(:bacula_config) do
  confine :kernel => :freebsd
  setcode { "/usr/local/etc/bacula-fd.conf" }
end

Facter.add(:bacula_config) do
  confine :kernel => :linux
  setcode { "/etc/bacula/bacula-fd.conf" }
end

# = Fact: bacula_password
#
# == Resolutions
#
# If a bacula client configuration exists, extract the password from that.
#
Facter.add(:bacula_password) do
  confine :id => 'root'

  setcode do
    regex = %r[.*Password\s*=\s*"(.+)"]
    begin
      if client_config = Facter.value(:bacula_config)
        File.open(client_config) do |fd|

          # Find the first line with Password =
          if pass_line = fd.find {|line| line.match(regex) }
            match = pass_line.match(regex)
            match[1]
          end
        end
      end
    rescue Errno::ENOENT => e
      Facter.debug e
    end
  end
end
