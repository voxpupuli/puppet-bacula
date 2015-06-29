#: Class bacul::director::defaults
#
# Some default valuse for the bacula director
#
class bacula::director::defaults {

  bacula::jobdefs { 'Default': }

  bacula::schedule { 'Default':
    runs => [
      'Level=Full sun at 2:05',
      'Level=Differential 2nd-5th sun at 06:05',
      'Level=Incremental mon-sat at 2:05'
    ]
  }
}
