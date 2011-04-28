#! /bin/bash

# This will apply the latest puppet code that has been pushed to github to the /etc/puppet/modules directory and erase any local modifications.  Meant to be run as a cronjob.


if [ -d /etc/pupppet/modules ]; then 
  cd /etc/puppet/modules
fi

git fetch --all
git reset --hard origin/master

