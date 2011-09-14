# This is hack, and just to get something off the ground. I need to
# move this around, make it check for debian, as that's all it will
# work on. Probably map some things.

# Defaults to 9.0 on squeeze, via backports.

class postgres::install::debian {

  $pgversion = '9.0' # if you wish, this could move to it's
                             # own params class.

  if $operatingsystem != 'debian' {
    fail( "$module_name is Debian only." )
  }

  # Install postgres from backports
  apt::pin{
    [ "postgresql-${pgversion}", "postgresql-client-${pgversion}", 'postgresql-common' ,
      'postgresql-client-common' , 'libpq5']:
    release  => 'squeeze-backports',
    priority => '1001'
  }

  package{ "postgresql-${pgversion}": ensure => present }

}
