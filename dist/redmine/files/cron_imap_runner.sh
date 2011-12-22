#!/bin/sh
#
# This was just sitting in a cron entry, thusly emailing the following
# password around as it went. So I threw it in a file instead.
# 
# Merely calls the UGLY rake task for badly pulling emails out of GMail
# and in to Redmine. Prone to spewing crap to STDOUT, hence the --silent
# (which does very little) and the /dev/nulling.
#
# In a perfect world, some of these things could become, say, variables,
# so the commands could become readable, but really, you don't care enough
# to see what it's doing anyway.

help() {
	echo "Either say 'infras','tickets' or 'all' to run the IMAP slurping rake task."
	exit 10
}

tickets() {
	rake --silent -f /opt/projects.puppetlabs.com/Rakefile redmine:email:receive_imap RAILS_ENV="production" host=imap.gmail.com username=tickets@puppetlabs.com password="5JjteNVs" port=993 ssl=true move_on_success=read move_on_failure=failed project=puppet allow_override=project folder=tickets >/dev/null
}

infras() {
	rake --silent -f /opt/projects.puppetlabs.com/Rakefile redmine:email:receive_imap RAILS_ENV="production" host=imap.gmail.com username=tickets@puppetlabs.com password="5JjteNVs" port=993 ssl=true move_on_success=read move_on_failure=failed project=puppetlabs-infras allow_override=project folder=infras >/dev/null
}

case $1 in
	'infras')
		infras
		;;
	'tickets')
		tickets
		;;
	'all')
		infras
		tickets
		;;
	*)
		help
		;;
esac

