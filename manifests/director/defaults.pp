# Some default resources for the bacula director.  These are referenced by
# defaults in other parts of this module, but need not be used.  They are here
# to ensure that the simple case of deploying a director and storage on the
# same machine, allows clients to receive the correct configuration.
#
class bacula::director::defaults {

  bacula::jobdefs { 'Default': }

  bacula::schedule { 'Default':
    runs => [
      'Level=Full sun at 2:05',
      'Level=Incremental mon-sat at 2:05',
    ],
  }

  bacula::director::pool { 'Default':
    pooltype => 'Backup',
    label    => 'Default-',
    storage  => $bacula::director::storage,
  }
}
