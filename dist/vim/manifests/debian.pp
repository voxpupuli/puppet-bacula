class vim::debian {


  package{ ['vim', 'vim-nox']:
    ensure => installed,
  }

  file {
    "/etc/vim/vimrc.local": 
      owner  => root,
      group  => root,
      mode   => 0644,
      source => "puppet:///modules/vim/vimrc.local";
    "/etc/vim/syntax":
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => 755;
    "/etc/vim/syntax/puppet.vim":
      owner  => root,
      group  => root,
      mode   => 755,
      source => "puppet:///modules/vim/syn_puppet.vim";
    "/etc/vim/ftdetect":
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => 755;
    "/etc/vim/ftdetect/puppet.vim":
      owner  => root,
      group  => root,
      mode   => 755,
      source => "puppet:///modules/vim/ft_puppet.vim";
  }

  exec { "set_vimnox_default_editor":
    command => "/usr/sbin/update-alternatives --set editor /usr/bin/vim.nox",
    require => Package["vim-nox"],
    unless  => "/usr/sbin/update-alternatives --display editor | awk '/link currently points to/ { print $NF }' | grep -q vim.nox"
  }

  exec { "set_vimnox_default_vim":
    command => "/usr/sbin/update-alternatives --set editor /usr/bin/vim.nox",
    require => Package["vim-nox"],
    unless  => "/usr/sbin/update-alternatives --display vim | awk '/link currently points to/ { print $NF }' | grep -q vim.nox"
  }

}

