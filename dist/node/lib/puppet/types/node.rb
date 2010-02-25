Puppet::Type.newtype(:node) do
  @doc = "Manages the provisioing of new machines."

  newparam(:name) do
    desc "I think this is hostname"
    validate do
    end
  end

  newparam(:rootdisk) do
    desc "the size of the root partition created at boot time"
  end

  # I need to consider if owner and password should be params
  #   ie: do we want to move machines between owners??
  newparam(:owner) do
    desc "owner of node, this will refer to the account responsible for
    provisioning for cloud services, this may also be required
    "
  end

  newparam(:password) do
    desc "this will on"
  end
 
  newparam(:group) do
    desc "node group that will be used for parameterization"
  end

  newparam(:role) do
    desc "list of classes that define machine role"
  end
 
  newproperty(:ncpus) do
    desc "Number of CPUs for a host"
  end

  newproperty(:memory) do
    desc "Total amount of memory for machine"
  end

