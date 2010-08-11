class virtual::users {
 include virtual::groups
 @account::user {'teyo':
    comment => 'Teyo, Tyree',
    group => sysadmin,
    tag => sysadmin,
 }
 @account::user {'james':
    comment => 'James Turnbull',
    group => sysadmin,
    tag => sysadmin,
 }
 @account::user {'dan':
    comment => 'Dan Bode',
    group => sysadmin,
    tag => sysadmin,
 }
 @account::user {'luke':
    comment => 'Luke Kanies',
    group => sysadmin,
    tag => sysadmin,
 }
 @account::user {'igal':
    comment => 'Igal Koshevoy',
    group => sysadmin,
    tag => sysadmin,
 }
 @account::user { 'deploy':
    comment => 'Deployment User',
    group => www-data,
    tag => deploy,
}
 @account::user { 'git':
    comment => 'Git User',
    group => sysadmin,
    tag => git,
 }
}
