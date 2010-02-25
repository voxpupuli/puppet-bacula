# Puts a file snippet into a directory previously setup using fragment::concat
#
# OPTIONS:
#   - filename          Name of file that this fragment belongs to.
#   - content           If present puts the content into the file
#   - source            If content was not specified, use the source
#   - order             By default all files gets a 10_ prefix in the directory
#                       you can set it to anything else using this to influence 
#                       the order of the content in the file
#   - mode              Mode for the file
#   - owner             Owner of the file
#   - group             Owner of the file
define fragment(
  $filename, $content='', $source='', $order=10,
  $mode = 0644, $owner = root, $group = root
  ) {
  # if content is passed, use that, else if source is passed use that
  case $content {
    '':      {
      case $source {
        '':      { crit('No content or source specified')  }
        default: { File{ source => $source } }
      }
    }
    default: { File{ content => $content } }
  }

  $file = regsubst($filename,'/','_', 'G')

  # this should be changed to $vardir when the fact exists.
  file{"/tmp/${file}.d/snippets/${order}_${name}":
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    ensure  => present,
    # this requires that a matching concat be declared in the same scope
    require => File["/tmp/${file}.d/snippets"],
    alias   => "concat_snippet_${name}",
    notify  => Exec["concat_${file}"]
  }
}
