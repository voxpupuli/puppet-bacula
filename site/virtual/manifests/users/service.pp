class virtual::users::service {

  include virtual::groups

  ### Service Accounts ###
  # UID range 22000-22999
  #

  @account::user { 'deploy':
    uid     => 22000,
    comment => 'Deployment User',
    group   => www-data,
    tag     => deploy,
  }

  @account::user { 'gitbackups':
    uid     => 22001,
    group   => 'backupusers',
    tag     => 'backupusers',
    comment => 'Backup acount for for git.puppetlabs.net',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDOE5KtdIIAzQZG74pu1QHZDgrCT+qv7UhDpEGZIrgcqmxEOeFWdjj7o8N4nRLm224pys1Zg2sDIzV/73YnTcyC4LiJkpCS60cC9nW2dQ4wx/nV31XnnndIqB1S5wlODLAhvYGPBu6xFotxeOXb4x5Pk9jThtk7Ol5yqab6IJn+hsp2dGph/ZQZ7xQR9IyfeOHCxF3IEShGNbISozLqWdnU9QkAlwudGcIlycxO9WNW0tmcrZDgI+B03zOsZzLrsPIH4T+QCxbimz0xjKmgl0XGbTnnR3C58+Z01o4VBYdR97N9nsXnIECuHb5xA/xXOUIVJJKs9h9G3kJ+O5YT0mfJ',
    keytype => 'ssh-rsa',
  }

  @account::user { 'git':
    comment => 'Git User',
    group   => git,
    tag     => git,
  }

  @account::user { 'hudson':
    comment => 'Hudson User',
    group   => hudson,
    tag     => hudson,
  }

  @account::user { 'patchwork':
    comment => 'Patchwork User',
    usekey  => false,
    group   => patchwork,
    tag     => patchwork,
  }

  @account::user { 'osqa':
    comment => 'OSQA User',
    usekey  => false,
    group   => osqa,
    tag     => osqa,
  }
}
