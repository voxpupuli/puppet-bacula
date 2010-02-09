# This has to be a separate type to enable collecting
Puppet::Type.newtype(:mysql_user) do
  @doc = "Manage a database user. This includes management of users password as well as priveleges"
  ensurable
  newparam(:name) do
    desc "The name of the user. This uses the 'username@hostname' form."

    validate do |value|
      if value =~ /(\S+)@(\S+)/
        if $1.size > 16
          raise ArgumentError,
           "MySQL usernames are limited to a maximum of 16 characters"
      else 
        railse ArgumentError, "Must specify user in username@host format(for all hosts use %)"
      end
    end
  end

  # what if its all-db wide?
  # is that *
  def newparam(:db) 
    desc "Database where user should get priveleges"  
    
  end

  newproperty(:password_hash) do
    desc "The password hash of the user. Use mysql_password() for creating such a hash."
    newValue(/\w+/)
  end

  newproperty(:grant, :array_matching => :all) do
    desc "array of priveleges that should be granted."
    newValue(/^\S+$/)
  end
end
