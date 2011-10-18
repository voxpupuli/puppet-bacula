Facter.add("confenv") do
  setcode do
    kernel = Facter.value('kernel')
    if kernel.match(/FreeBSD/)
      path = '/usr/local/bin/puppet'
    elsif
      path = '/usr/bin/puppet'
    end
    %x{#{path} config print environment}.chomp if File.exists?(path)
  end
end
