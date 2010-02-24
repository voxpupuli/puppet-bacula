class virtual::users {
 include virtual::groups
 @account::user {'teyo':
    comment => 'Teyo, Tyree',
    group => sysadmin,
    tag => sysadmin,
 }
 @account::user {'bruce':
    comment => 'Bruce, Williams',
    group => sysadmin,
    tag => sysadmin,
 }
}
