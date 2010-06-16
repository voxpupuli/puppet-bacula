# Definition: fragment
#
# Puts a file snippet into a directory previously setup using fragment::concat
#
# Parameters:
#
#   - filename          Name of file that this fragment belongs to.
#   - content           If present puts the content into the file
#   - source            If content was not specified, use the source
#   - order             By default all files gets a 10_ prefix in the directory
#                       you can set it to anything else using this to influence 
#                       the order of the content in the file
#   - mode              Mode for the file
#   - owner             Owner of the file
#   - group             Owner of the file
#
# Actions:
#
# Requires:
#
define fragment( $content='source', $source='content', $order=10, $mode = 0644, $owner = root, $group = root, $target, $path ) {
  #
  #  Add function to test for existence of con 
  #
  file {"${path}/${target}.snippets/${order}_${name}":
    mode => $mode,
    owner => $owner,
    group => $group,
    ensure => present,
    source => $source ? {content => undef, default => $source}, 
    content => $content ? { source => undef, default => $content}, 
    notify => Exec["concat_${target}"],
  }
}
