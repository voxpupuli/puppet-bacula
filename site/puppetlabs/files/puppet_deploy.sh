#! /bin/bash

# This will apply the latest puppet code that has been pushed to github to the /etc/puppet/modules directory and erase any local modifications.  Meant to be run as a cronjob.

module_dir="/etc/puppet/modules"

if [ -d $module_dir ]; then
  cd $module_dir
fi

git fetch --all
git reset --hard origin/master

