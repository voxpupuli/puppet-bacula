class vim::debian {

  # Karmic is now so old, that it breaks this. Until we can get rid of
  # the last Karmic box we have to stop it trying to update things.
  # Yes, this is horrible, but you'd rather it to a machine never
  # completing a puppet run. It does make baby jesus cry. -BenH 2012
  if $lsbdistcodename != 'karmic' {

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
}

