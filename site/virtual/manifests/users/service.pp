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
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAr/PYSBs0degY8/NxTZAsidGG+9Wnqb6RQxqm+HRK+Jc4toetKOvXVfwCKQczTwpuKlS3bT0MREv2Ur4boFm7jWGy01y0cJBLjBQEsefWjb3jlQIuYZcaYBlzSq1PlzeuTHcc86k34gvL0uKojYmc43kX/ao3o3yIp4/7SlKJVpYikWNB0NDOokeGEr440GwAGUzybgur/Vfm+aYa9k0wigCC386S1/l4MQ3dDI8D83fOZnyHVOmyjBFL/Nz2Q3Xy4P/Sey8g40SoO4UjNtGmZRmwmdUaF1p1i1BDW7wqsFBYwKeLKv8ZjNo+zy0Mflm2KFnrHBd1FOzymYV3g1biyw==",
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

