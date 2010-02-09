# This has to be a separate type to enable collecting
Puppet::Type.newtype(:mysql_database) do
  @doc = "Manage a database."
  ensurable
  newparam(:name) do
    desc "The name of the database."
    # TODO: only [[:alnum:]_] allowed
  end

  newproperty(:args) do
    desc "array of arguments for database creation"
  end
  newproperty(:user) do
    desc "user that will query database"
  end
  newproperty(:password) do
    desc "password for user that will query database"
  end
        
end

