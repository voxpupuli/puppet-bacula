#! /bin/bash

sudo rm -Rf /usr/local/src/{latest.zip,wordpress}
sudo puppet agent -tv
sudo tar -czf ~/wp-content.gz -C /var/www/www-dev.puppetlabs.com wp-content
sudo rsync -ap /usr/local/src/wordpress/ /var/www/www-dev.puppetlabs.com/
sudo tar -xzf ~/wp-content.gz -C /var/www/www-dev.puppetlabs.com
sudo puppet agent -tv

