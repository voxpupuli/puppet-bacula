#!/bin/sh
# Vile script to do git auto commits of a directory.

set -e

WORDPRESS_DIR="/var/www/puppetlabs.com"

cd $WORDPRESS_DIR

CHANGES="$( git status --porcelain )"

if [ ${#CHANGES} -gt 0 ]
then
	git add --all
	git commit -m "Automatic commit by a magical script" -a
fi
