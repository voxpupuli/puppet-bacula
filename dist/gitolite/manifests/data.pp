class gitolite::data {

  ##############################################################################
  # gitolite::install
  ##############################################################################
  $gitolite_install_source = 'package'

  ##############################################################################
  # gitolite::instance
  ##############################################################################
  $gitolite_instance_manage_user = false
  $gitolite_instance_user  = 'git'
  $gitolite_instance_group = 'git'
  $gitolite_instance_home  = '/home/git'

  ##############################################################################
  # gitolite::rc
  ##############################################################################
  $gitolite_rc_gl_wildrepos  = '0'
  $gitolite_rc_gl_wildrepos_defperms = 'R @all'
  $gitolite_rc_gl_wildrepos_perm_cats = 'READERS WRITERS'

  $gitolite_rc_projects_list = "${gitolite_instance_home}/projects.list"
  $gitolite_rc_project_root  = "${gitolite_instance_home}/repositories"
  $gitolite_rc_repo_umask    = '0077'
  $gitolite_rc_htpasswd_file = 'UNSET'

  $gitolite_rc_gl_adc_path   = 'UNSET'
}
