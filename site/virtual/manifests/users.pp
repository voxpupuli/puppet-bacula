class virtual::users {
 include virtual::groups
 @account::user {'teyo':
    comment => 'Teyo, Tyree',
    group => developers,
    tag => developers,
 }
 @account::user {'james':
    comment => 'James Turnbull',
    group => sysadmin,
    tag => sysadmin,
 }
 @account::user {'nan':
    comment => 'Nan Liu',
    group => prosvc,
    tag => prosvc,
 }
 @account::user {'dan':
    comment => 'Dan Bode',
    group => prosvc,
    tag => prosvc,
 }
 @account::user {'nigel':
    comment => 'Nigel Kersten',
    group => prosvc,
    tag => prosvc,
}
 @account::user {'luke':
    comment => 'Luke Kanies',
    group => developers,
    tag => developers,
 }
 @account::user {'igal':
    comment => 'Igal Koshevoy',
    group => sysadmin,
    tag => sysadmin,
 }
 @account::user {'matt':
    comment => 'Matt Robinson',
    group => developers,
    tag => developers,
 }
 @account::user {'jhelwig':
    comment => 'Jacob Helwig',
    group => developers,
    tag => developers,
 }
 @account::user {'pberry':
    comment => 'Paul Berry',
    group => developers,
    tag => developers,
 }
 @account::user {'jeff':
    comment => 'Jeff McCune',
    group => sysadmin,
    tag => sysadmin,
 }
  @account::user {'zach':
    comment => 'Zach Leslie',
    group => sysadmin,
    tag => sysadmin,
 }
 @account::user {'djm':
    comment => 'Dominic Maraglia',
    group => sysadmin,
    tag => sysadmin,
 }
 @account::user {'nfagerlund':
    comment => 'Nick Fagerlund',
    group => prosvc,
    tag => prosvc,
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
 @account::user { 'hudson':
    comment => 'Hudson User',
    group => hudson,
    tag => hudson,
 }
}
