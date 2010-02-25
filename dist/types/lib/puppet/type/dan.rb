Puppet::Type.newtype(:dan) do
  desc "You can create dans."
  # ...
  newparam(:name) do
    desc "this is my name"
    isnamevar
  end
  newparam(:dans) do
    desc "do other dans exist?"
  end
  newparam(:awesomeness) do
    desc "how awesome is dan?"
    isrequired
    validate do |value|
      unless value =~ /(true|false)/
        raise ArgumentError, "Dan awesomeness can only be true or false"
      end
    end
    # this happens after validate.
    munge do |value|
      # I can do stuff here
    end
  end
  # you have to munge params with arrays
end
