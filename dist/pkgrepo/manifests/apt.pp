define pkgrepo::apt ($package_dir = '/var/packages', $origin, $label, $codename, $architectures, $components, $signwith = yes ) {
  include pkgrepo
  $repodir = "${name}/${package_dir}"
  
  File { owner => root, group => root }
  file {
    $repodir: ensure => directory; 
    "${repodir}/conf": ensure => directory;
     
  }
}
#Origin: Lone Wolves
#Label: Lone Wolves
#Codename: dapper
#Architectures: i386 amd64 source
#Components: main
#Description: Lone Wolves APT Repository
#SignWith: yes
#DebOverride: override.dapper
#DscOverride: override.dapper
