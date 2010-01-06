# Concatanates file snippets into one file. 
# NOTE: the purge feauture will not work on .24.8 or earlier
# OPTIONS:
#  - directory		The directory where snippets are found, defaults to ${name}.d
#  - mode		The mode of the final file
#  - owner		owner of final file
#  - group		group for final file
#
# ACTIONS:
#  - Creates directory and directory/snippets if it didn't exist already
#  - Executes the concatsnippets.sh script to build the final file, this script will create
#    directory/snippets.concat and copy it to the final destination.   Execution happens only when:
#    * The directory changes 
#    * snippets.concat != final destination, this means rebuilds will happen whenever 
#      someone changes or deletes the final file.  Checking is done using /usr/bin/cmp.
#    * The Exec gets notified by something else - like the concat_snippet define
#  - Defines a File resource to ensure $mode is set correctly but also to provide another 
#    means of requiring
#
# ALIASES:
#  - The exec can notified using Exec["concat_/path/to/file"] or Exec["concat_/path/to/directory"]
#  - The final file can be referened as File["/path/to/file"] or File["concat_/path/to/file"]  
define fragment::concat(
  $directory = '', $mode = 0644, $owner = "root", $group = "root"
  ) {
	
  $snipdir = $directory ? {
    ''	    => "${name}.d",
    default => $directory,
  }

  File{
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }

  file{$snipdir:
    ensure  => directory,
#    notify  => Exec["concat_${name}"],
  }

  file{"${snipdir}/snippets":
    ensure   => directory,
    recurse  => true,
    # purge any fragments not explicity managed by puppet
    purge    => true,
    force    => true,
    ignore   => ['.svn', '.git'],
    # notify the exec in case we have to purge
    notify   => Exec["concat_${name}"],
  }

  file{"${snipdir}/snippets.concat":
    ensure  => present,
  }

  file{'/usr/local/bin/concatsnippets.sh':
    mode   => 755,
    source => 'puppet:///modules/fragment/concatsnippets.sh',
  }

  exec{"concat_${name}":
    user      => $owner,
    group     => $group,
    notify    => File[$name],
    alias     => "concat_${snipdir}",
    require   => [ 
      File["/usr/local/bin/concatsnippets.sh"], 
      File["${snipdir}/snippets"], 
      File["${snipdir}/snippets.concat"] 
    ],
    unless  => "/usr/local/bin/concatsnippets.sh -o ${name} -d ${snipdir} -t",
    command => "/usr/local/bin/concatsnippets.sh -o ${name} -d ${snipdir}",
  }

  file{$name:
    ensure   => present,
    alias    => "concat_${name}",
  }
}
