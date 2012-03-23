class vmware::tools::centos {

  package { "vmware-open-vm-tools":
    name  => "vmware-open-vm-tools",
    ensure  => present,

    #In order for centOS 'virtual' fact to return 'vmware' if it is on vmware,
    #dmidecode package is to be installed before installing the vmware tools
    require => Package["dmidecode"],
  }

  #At this point assuming dmidecode is already installed
  #      require => Package["dmidecode"],

  if ($operatingsystemrelease == "6.0" ) { 
    $centOS_dist = "rhel6"
  }
  elsif ( $operatingsystemrelease == "5.0") {
    $centOS_dist = "rhel5"
  }
  else {
    notice("Only CentOS 6 and CentOS 5 releases are supported for vmware tools instalation")
  }

  $str = "[vmware-tools]
name=VMware Tools
baseurl=http://packages.vmware.com/tools/esx/4.1/$centOS_dist/$architecture
enabled=1
gpgcheck=1"

  #Call the function to download and install the vmware tools package keys
  vmware::download_and_install_key {
    [ "VMWARE-PACKAGING-GPG-DSA-KEY.pub",
      "VMWARE-PACKAGING-GPG-RSA-KEY.pub" , ]:
      site    => "http://packages.vmware.com/tools/keys",
      cwd     => "/etc/vmware_keys",
      icmnd   => "rpm --import ",
      creates => "/etc/vmware_keys/${name}",
      require => File[ "/etc/vmware_keys"],
      user    => "root",
  }

  file { '/etc/yum.repos.d/vmware_tools.repo' :
    ensure   => present,
    content  => $str
  }

  package { "vmware-tools":
    ensure  => present,
  }

  File[ '/etc/yum.repos.d/vmware_tools.repo'] -> Package['vmware-tools']
}
