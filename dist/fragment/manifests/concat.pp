# Concatanates file snippets into one file. 
# NOTE: the purge feauture will not work on .24.8 or earlier
# OPTIONS:
#  - name       The name of the file we are creating
#  - mode		    The mode of the final file
#  - owner		  owner of final file
#  - group		  group for final file
#  - directory  directory prefix for snippet and target 
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
define fragment::concat ( $path, $mode = 0644, $owner = "root", $group = "root") {
  $concatscript = '/usr/local/bin/concatsnippets.sh'
  $target = "${path}/${name}"
  $fragdir = "${path}/${name}.snippets"
  File { owner => $owner, group => $group, mode => $mode }
  file {
    $path: mode => 755, ensure => directory;  
    $concatscript: mode => 755, source => 'puppet:///modules/fragment/concatsnippets.sh';
    "${fragdir}": ensure => directory, recurse => true, purge => true, force => true, ignore => ['.svn', '.git'], notify => Exec["concat_${name}"];
    "${fragdir}/snippets.concat": ensure => present;
    $target: ensure => present; 
  }
  exec{"concat_${name}":
    user => $owner,
    group => $group,
    notify => File [$target],
    require => File [ $concatscript, $path, $fragdir ], 
    unless  => "${concatscript} -o ${name} -p ${path} -t",
    command => "${concatscript} -o ${name} -p ${path}",
  }
}
