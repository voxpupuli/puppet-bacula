Puppet::Type.type(:vcsrepo).provide(:git) do
  desc "implement git"
#  confine :has_git => 'true'
  commands :git => 'git' 
#  begin
#    git('init')
#  rescue Puppet::ExecutionError => e
#    raise Puppet::Error, "could not mount blah"  
#  end
  def create
    unless @resource.value(:source)
      Dir.chdir(@resource.value(:path)) do
        git('init')
      end
    else 
      Dir.chdir(@resource.value(:path)) do
        git('clone', @resource.value(:source).to_s)
        git('reset', '--hard', value) 
      end
    end
  end
  
  def exists?
    File.directory?("#{@resource.value(:path)}/.git")
  end

  def destroy
    FileUtil.rm(@resource.value(:path))
  end


  def revision
    Dir.chdir(@resource.value(:path)) do
      git('rev-parse', 'HEAD').chomp
    end
  end

  def revision=(value)
    #make sure that we have the latest commits
    Dir.chdir(@resource.value(:path)) do
      git('fetch', 'origin')
    #change to a version
      git('reset', '--hard', value)
    end
  end
end
