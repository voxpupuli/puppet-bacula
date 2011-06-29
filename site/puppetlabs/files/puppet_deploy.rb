#! /usr/bin/env ruby
##
# So could probably make this more modular. But that's just the fact it was a 5
# line shell script, and now it's a Ruby script with a class in it. Get over it.
# 
# This purely checks out our github repo and puts all the branches in their own
# dir. Inspired by/copied from
# http://hunnur.com/blog/2010/10/dynamic-git-branch-puppet-environments/
#
# Hardcode city. Suck it up.
#

require 'pp'
require 'fileutils'

github_repo_urls = { :default => 'git@github.com:puppetlabs/puppetlabs-modules.git',
                     #:adrient => 'git@github.com:adrienthebo/puppetlabs-modules.git',
                     #:zach    => 'git@github.com:xaque208/puppetlabs-modules.git'
}

# Identifer for individual repos.
$NSIDENT = 'nonPL'

# $modulepath=`puppet master --configprint modulepath`
env_base_dir  = '/etc/puppet/environments'

$debug = false

if ARGV.include? "-d" or ARGV.include? "--debug"
  $debug = true
end

$gitnoise = ""
unless $debug == true
  $gitnoise = "--quiet"
end

def pp_and_system( dome )
  pp dome if $debug == true
  system dome
end

def dputs( text )
  puts text if $debug == true
end

class GitRepo

  attr_accessor :repo , :branches , :branchcount

  def initialize( base_dir , git_name , git_repo_url )

    @git_repo_url = git_repo_url
    @namespace    = git_name == :default ?  '' : "#{$NSIDENT}#{git_name}" # :default doesn't have a namespace, but everything else should.

    check_env_dir base_dir

    @env_base_dir = base_dir
    @mirrordir = "#{@env_base_dir}/.github_pl_#{@namespace}modules_repo"
    # We need to mirror the repo before we can get the list of branches!
    self.mirror_repo

    @branches = self.get_branches
    @branchcount = @branches.size
  end

  # check the dir exists, try and make it if not. Bail if we have to.
  private
  def check_env_dir( base_dir )
    unless File.directory? base_dir
      begin
        dputs "Trying to mkdir -p to #{base_dir}"
        FileUtils.mkdir_p base_dir
      rescue
        raise "Can't make environments base dir of #{base_dir}." 
        exit 10
      end
    end
  end
  public

  def get_branches
    dputs "CDing to #{@mirrordir} from #{Dir.getwd}"
    Dir.chdir @mirrordir do 

      branches_wot_we_have = []

      `LANG="C" git branch -a`.split("\n").each do |branch|
        branch = branch.split( / +/ )[1]
        next if branch == "master"
        next if branch =~ /remotes\/origin\/(HEAD|master)/
        next if branch =~ /\// # Zach safe code.

        branches_wot_we_have << branch
      end

      branches_wot_we_have
    end
  end


  def populate_branchi
    @branches.each do |b|
      self.make_subbranch b
    end
  end

  def make_subbranch( branch_to_make , make_as=nil )
    Dir.chdir @env_base_dir 

    envname = make_as
    branch_checkout_dirname = branch_to_make.split( '/' ).last

    if make_as != nil
      checkout_as = @namespace + make_as
    else
      checkout_as = @namespace + branch_checkout_dirname
    end

    dputs "Making ol' #{branch_to_make}"
    branch_dir = "#{@env_base_dir}/#{checkout_as}"

    # Chunk stolen from 
    # { cd $BRANCH_DIR/$BRANCH && git pull origin $BRANCH ; } \
    #     || { mkdir -p $BRANCH_DIR && cd $BRANCH_DIR \
    #     && git clone $REPO $BRANCH && cd $BRANCH \
    #     && git checkout -b $BRANCH origin/$BRANCH ; }
    if File.directory? branch_dir
      dputs "doing a pull on an existing branch"
      Dir.chdir branch_dir do
        pp_and_system "LANG='C' git fetch #{$gitnoise} --all && git reset #{$gitnoise} --hard origin/#{branch_to_make}" # origin #{branch_to_make}"
      end
    else
      dputs "doing a clone on a new branch"
      Dir.chdir @env_base_dir do
        pp_and_system "LANG='C' git clone #{$gitnoise} -b #{branch_checkout_dirname} #{@mirrordir} #{checkout_as}" 
      end
    end
  end

  def checkout_master
    # just assume it's checked out, for now.
    Dir.chdir @mirrordir do
      pp_and_system( "LANG='C' git fetch #{$gitnoise} --all --prune" )
    end
  end

  def mirror_repo
    if File.directory? @mirrordir
      self.checkout_master
    else
      dputs "Making clone of remote repo locally to #{@mirrordir}"
      pp_and_system( "LANG='C' git clone #{$gitnoise} --mirror #{@git_repo_url} #{@mirrordir}" )
    end
  end

  def delete_extraneous_branches
    Dir.chdir @env_base_dir do
      Dir.glob( '*' ) do |dir|
        next if dir == "#{@namespace}production" # Hardcode DON'T RM PROD!
                                                 # :default will namespace to ''
        next unless File.directory? dir
        next if @branches.include? dir

        # Remove things, but base it on namespaces.
        if @namespace.empty? 
          next if dir =~ /^#{$NSIDENT}/
        else
          next if dir !~ /^#{@namespace}/

          # It is our name space, but which branches?
          next if @branches.collect { |b| @namespace + b }.include? dir
        end

        # if we're here, it's not prod, it is a directory and it isn't a branch
        # we have.
        cmd = %Q!rm -rf "#{@env_base_dir}/#{dir}"!
        pp_and_system cmd
      end
    end
  end
end


startdir = Dir.getwd

github_repo_urls.each do |nom,repo|

  dputs "Working on #{nom}'s repo from #{repo}"

  Dir.chdir startdir

  g = GitRepo.new( env_base_dir, nom, repo )

  # Do all the wee bonnie branches other than main. This will clone them from the
  # repo we just checked out, so it's a local only operation.
  g.populate_branchi

  # By default it ignores master, this throws it in to production.
  g.make_subbranch( "master" , "production" )

  # Finally, tidy up other branches/envs
  g.delete_extraneous_branches

end

exit


__END__
#!/bin/sh
module_dir="/etc/puppet/modules"
module_dir="puppet_modules"

if [ -d $module_dir ]; then
	cd $module_dir
else
	echo "Failed to find \"$module_dir\", you need to clone it."
	exit 10
fi

git fetch --all && \
	git reset --hard origin/master

exit $?

