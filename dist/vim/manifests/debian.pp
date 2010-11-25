class vim::debian {
  package{'vim':
    ensure => installed,
  }

  file {
    "/etc/vim/vimrc.local": owner => root, group => root, mode => 0644,
      source => "puppet:///modules/vim/vimrc.local";
    "/etc/vim/syntax": ensure => directory, owner => root, group => root, mode => 755;
    "/etc/vim/syntax/puppet.vim": owner => root, group => root, mode => 755,
      source => "puppet:///modules/vim/syn_puppet.vim";
    "/etc/vim/ftdetect": ensure => directory, owner => root, group => root, mode => 755;
    "/etc/vim/ftdetect/puppet.vim": owner => root, group => root, mode => 755,
      source => "puppet:///modules/vim/ft_puppet.vim";
  }

}

