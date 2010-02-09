# This has to be a separate type to enable collecting
Puppet::Type.newtype(:database) do
  @doc = "Manage creation/deletion of a database."

  ensurable

  newparam(:name) do
    desc "The name of the database."
    isnamevar
  end
#  newparam(:args) do
#    desc "array of arguments for database creation"
#  end
  newproperty(:charset) do
    defaultto :utf8
    newvalue(/^\S+$/)
  end

end

