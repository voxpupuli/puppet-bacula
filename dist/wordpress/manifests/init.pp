class wordpress {
  require apache
  include php::mysql
  include apache::php

  # We assume for our modules, we have the motd module, & use it.
  motd::register{ 'Wordpress weblog engine': }


  realize(A2mod['rewrite'])

  Exec["wp_download"] -> Exec["wp_unzip"]

  exec { "wp_download":
    cwd     => "/usr/local/src",
    creates => "/usr/local/src/latest.zip",
    command => "/usr/bin/wget http://wordpress.org/latest.zip";
  }

  exec { "wp_unzip":
    cwd     => "/usr/local/src",
    creates => "/usr/local/src/wordpress",
    command => "/usr/bin/unzip latest.zip";
  }


}
