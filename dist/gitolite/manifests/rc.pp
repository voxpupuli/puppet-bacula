# = Class: gitolite::rc
#
# == Purpose
#
# This class generates the gitolite configuration file. It performs basic
# variable munging that cannot be done through hiera and templates the
# aforementioned config file.
#
# == External Parameters
#
# The following variables are pulled from hiera.
#
# * gitolite_instance_user          - The name of the gitolite user
# * gitolite_instance_group         - The name of the gitolite group
# * gitolite_instance_home          - The name of the gitolite home directory
#
# The following parameters can be tuned as parameters or through hiera
#
#  gl_wildrepos             - Whether to enable wildrepos
#  gl_wildrepos_defperms    - Default permssions for wildrepos
#  gl_wildrepos_perm_cats   - Possible permission categories for wildrepos
#  projects_list            - The location of the projects list.
#  repo_umask               - The umask for repositories.
#  gl_adc_path              - The path to load and store ADCs in
#  gl_htpasswd_file         - The location of the htpasswd file.
#
class gitolite::rc (
  $gl_wildrepos           = hiera('gitolite_rc_gl_wildrepos'),
  $gl_wildrepos_defperms  = hiera('gitolite_rc_gl_wildrepos_defperms'),
  $gl_wildrepos_perm_cats = hiera('gitolite_rc_gl_wildrepos_perm_cats'),
  $projects_list          = hiera('gitolite_rc_projects_list'),
  $repo_umask             = hiera('gitolite_rc_repo_umask'),
  $gl_adc_path            = hiera('gitolite_rc_gl_adc_path', 'UNSET'),
  $gl_htpasswd_file       = hiera('gitolite_rc_gl_htpasswd_file', 'UNSET')
) {

  require gitolite::instance


  $user  = hiera('gitolite_instance_user')
  $group = hiera('gitolite_instance_group')
  $home  = hiera('gitolite_instance_home')

  $gl_share_dir = hiera('gitolite_install_source') ? {
    'git'   => "${home}/share",
    default => "/usr/share",
  }

  file { "${home}/.gitolite.rc":
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('gitolite/_gitolite.rc.erb'),
  }
}
