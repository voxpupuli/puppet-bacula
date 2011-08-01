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

