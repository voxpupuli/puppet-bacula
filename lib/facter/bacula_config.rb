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
