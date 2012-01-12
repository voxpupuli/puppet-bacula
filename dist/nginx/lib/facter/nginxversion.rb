Facter.add('nginxversion') do
  setcode do
    # Parse out:
    # nginx version: nginx/0.7.62
    %x{ nginx -v 2>&1 }.split('/').last
  end
end
