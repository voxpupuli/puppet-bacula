#! /bin/bash

# the intent of this script is to be run on the www-dev.puppetlabs.com node to sync up the entire installation and sql server with that of the production wordpress installation

# Log into www-dev.puppetlabs.com
if [ ! -d ~/tmp ]; then mkdir ~/tmp; fi

# pull the data down
ssh www.puppetlabs.com "sudo cat /var/lib/bacula/mysql/puppetlabscom.sql | gzip" > ~/tmp/puppetlabscom.sql.gz
ssh www.puppetlabs.com "sudo tar -cz --exclude downloads --exclude ps -C /var/www puppetlabs.com" > ~/tmp/puppetlabscom.tar.gz

# Populate the new box
sudo -i zcat ~/tmp/puppetlabscom.sql.gz | mysql -pgosh-if-no-hull -u wwwdev wwwdevpuppetlabscom
sudo -i rm -Rf ~/tmp/puppetlabs.com
sudo -i tar -xzf ~/tmp/puppetlabscom.tar.gz -C ~/tmp
sudo -i rsync -a --del ~/tmp/puppetlabs.com/wp-content/ /var/www/www-dev.puppetlabs.com/wp-content/
sudo -i puppet agent -tv

sudo -i chown -R www-data:www-dev /var/www/www-dev.puppetlabs.com
sudo -i "find /var/www/www-dev.puppetlabs.com -type f -print0 | xargs -0 -I {} chmod 0664 {}"
sudo -i "find /var/www/www-dev.puppetlabs.com -type d -print0 | xargs -0 -I {} chmod 0775 {}"

