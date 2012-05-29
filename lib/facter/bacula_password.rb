# = Fact: bacula_password
#
# == Resolutions
#
# If a bacula client configuration exists, extract the password from that.
# Else create a new password
#

client_config = '/etc/bacula/bacula-fd.conf'

Facter.add(:bacula_password) do
  # If a bacula client config exists, extract the password from it. This takes
  # precedence since it uses the on-disk password.
  has_weight 100
  confine :id => 'root'

  setcode do
    regex = %r[.*Password\s*=\s*"(.+)"]
    begin
      File.open(client_config) do |fd|

        # Find the first line with Password =
        if pass_line = fd.find {|line| line.match(regex) }
          match = pass_line.match(regex)
          match[1]
        end
      end
    rescue Errno::ENOENT => e
      Facter.debug e
    end
  end
end

# This code was ripped off from Zach's genpass function
Facter.add(:bacula_password) do
  has_weight 0
  confine :id => 'root'

  setcode do
    o =  [('a'..'z'),('A'..'Z')].map(&:to_a).flatten
    (0..50).map{ o[rand(o.length)]  }.join
  end
end
