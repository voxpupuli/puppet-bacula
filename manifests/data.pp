class gitolite::data {

  ##############################################################################
  # gitolite::package
  ##############################################################################
  $gitolite_package_source = 'backports'

  ##############################################################################
  # gitolite::instance
  ##############################################################################
  $gitolite_instance_manage_user = true
  $gitolite_instance_user  = 'git'
  $gitolite_instance_group = 'git'
  $gitolite_instance_home  = '/home/git'

  # DIRTY
  $gitolite_instance_key   = 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key'

  ##############################################################################
  # gitolite::rc
  ##############################################################################
  $gitolite_rc_gl_wildrepos  = '1'
  $gitolite_rc_gl_wildrepos_defperms = 'R @all'
  $gitolite_rc_gl_wildrepos_perm_cats = 'READERS WRITERS'

  $gitolite_rc_projects_list = "${gitolite_instance_home}/projects.list"
  $gitolite_rc_repo_umask    = '0077'

  $gitolite_rc_gl_adc_path   = "/home/git/adc"
}
