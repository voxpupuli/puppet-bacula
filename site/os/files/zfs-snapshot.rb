#!/usr/bin/env ruby

require 'pp'
require 'optparse'

@zfs_cmd   = '/sbin/zfs'
@zpool_cmd = '/sbin/zpool'

$options = {}
opt_parser = OptionParser.new do |opts|
  opts.banner = "#{$0}: [options] --config NUM --snapshot NAME POOL1 POOL2 ..."

  opts.on('-r', '--recurse', "snapshots should be made recursive") do
    $options[:recurse] = true
  end

  opts.on('-c', '--count=COUNT', "Number of snapshots to keep") do |count|
    $options[:count] = count
  end

  opts.on('-s', '--snapshot=NAME', "The name of the snapshot") do |snapshot|
    $options[:snapshot] = snapshot
  end

  opts.on('-v', '--verbose', "Speak up") do
    $options[:verbose] = true
  end

  opts.on('-d', '--dry', "Don't actually make changes") do
    $options[:dry] = true
  end

  opts.on('-h', '--help', "Display this help") do
    puts opts
    exit
  end
end

begin
  opt_parser.parse!
  mandatory = [:snapshot, :count]
  missing = mandatory.select{ |param| $options[param].nil? }
  if not missing.empty? 
    puts "Missing options: #{missing.join(', ')}"
    puts opt_parser
    exit 1
  end
rescue => e
  $stderr.puts e
  $stderr.puts opt_parser
end

def get_zpools
  pools = []
  %x{#{@zpool_cmd} list -H}.split("\n").each do |line,i|
    pools << line.split.first
  end
  pools
end

class ZeeFS
  attr_accessor :creation, :type

  def initialize ( zpoolname, options)
    @zfs_cmd   = '/sbin/zfs'
    @zpool_cmd = '/sbin/zpool'

    @zpoolname = zpoolname
    @options   = options

    unless self.zpool_exists?
      puts "The zpool \"#{@zpoolname}\" does not exist"
      exit 2
    end

    @count    = @options[:count].to_i
    @snapshot = @options[:snapshot]

    @snapshots = self.get_snapshot_list()

    @creation = self.get_zfs_property("creation")
    @type     = self.get_zfs_property("type")

  end

  def get_zfs_property ( prop )
    %x{#{@zfs_cmd} get -Hp #{prop} #{@zpoolname}}.split[2]
  end

  def snapshot (name)
    if @options[:recurse]
      snap_cmd = "zfs snapshot -r #{@zpoolname}@#{name}"
    else
      snap_cmd = "zfs snapshot #{@zpoolname}@#{name}"
    end
    pp "running: #{snap_cmd}" if @options[:verbose]
    %x{#{snap_cmd}} unless @options[:dry]
  end

  def zpool_exists?
    get_zpools.include?("#{@zpoolname}")
  end

  def get_snapshot_list
    snapshots = []
    %x{#{@zfs_cmd} list -Ht snapshot}.split("\n").each do |line,i|
      snapshots << line.split.first if line =~ /#{Regexp.escape(@zpoolname)}/
    end
    snapshots
  end

  def snapshot_exists? (zfsname)
    @snapshots.include?(zfsname)
  end

  def snapshot_rename (from,to)
    if @options[:recurse]
      rename_cmd = "zfs rename -r #{from} #{to}"
    else
      rename_cmd = "zfs rename #{from} #{to}"
    end
    pp "running: #{rename_cmd}" if @options[:verbose]
    %x{#{rename_cmd}} unless @options[:dry]
  end

  def snapshot_remove (name)
    if @options[:recurse]
      remove_cmd = "zfs destroy -r #{name}"
    else
      remove_cmd = "zfs destroy #{name}"
    end
    pp "running: #{remove_cmd}" if @options[:verbose]
    %x{#{remove_cmd}} unless @options[:dry]
  end

  def rotate
    # zero index
    index = @count - 1
    while index >= 0
      zfsname = "#{@zpoolname}@#{@snapshot}.#{index}"
      if snapshot_exists?(zfsname)
        # remove the last one so we can rename something to it
        if index == @count - 1
          last = "#{@zpoolname}@#{@snapshot}.#{index}"
          snapshot_remove(last)
        else
          dest = "#{@zpoolname}@#{@snapshot}.#{index + 1}"
          snapshot_rename(zfsname,dest)
        end
      end
      index -= 1
    end
  end

end

pools = []
if ARGV.size == 0
  pools = get_zpools()
else
  pools = ARGV
end

pools.each do |zpoolname|
  z = ZeeFS.new( zpoolname, $options )

  if $options[:count]
    z.rotate
    if $options[:snapshot]
      z.snapshot("#{$options[:snapshot]}.0")
    end
  end
end

