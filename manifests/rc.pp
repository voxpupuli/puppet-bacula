class gitolite::rc (
  $gl_wildrepos           = hiera('gitolite_rc_gl_wildrepos'),
  $gl_wildrepos_defperms  = hiera('gitolite_rc_gl_wildrepos_defperms'),
  $gl_wildrepos_perm_cats = hiera('gitolite_rc_gl_wildrepos_perm_cats'),
  $projects_list          = hiera('gitolite_rc_projects_list'),
  $repo_umask             = hiera('gitolite_rc_repo_umask'),
) {
  $gl_adc_path           = hiera('gitolite_rc_gl_adc_path', undef)

  $user  = hiera('gitolite_instance_user')
  $group = hiera('gitolite_instance_group')
  $home  = hiera('gitolite_instance_home')

  file { "${home}/.gitolite.rc":
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('gitolite/_gitolite.rc.erb'),
  }
}
