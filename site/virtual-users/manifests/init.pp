class virtual-users {
  include virtual-users::groups
  @account::user {'teyo':
    comment => 'Teyo, Tyree',
    password => 'foopresent',
    group => sysadmin,
  }

}
