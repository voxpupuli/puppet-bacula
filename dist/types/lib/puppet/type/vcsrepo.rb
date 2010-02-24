Puppet::Type.newtype(:vcsrepo) do
  desc "this is a happy repo"
  # ...
  ensurable
  newparam(:path) do
    desc "this is the local path"
    isnamevar
    validate do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, 'Valid paths start with / (duh)' 
      end
    end
  end
  newparam(:source) do
    desc "this is the remote source"
    validate do |value|
      URI.parse(value)
    end
  end
  newproperty(:revision) do
    desc "this accepts any non-whitespace non-empty string"
    newvalue(/^\S+$/)
  end
#  autorequire :vcsrepo do
#    [
#      [:file, ]
#    ]
#  end
  
end
