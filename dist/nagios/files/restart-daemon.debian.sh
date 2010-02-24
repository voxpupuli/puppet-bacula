#!/bin/sh
#
# Event handler script for restarting services on the local machine
#
# This script is invoked by the Nagios server, via de nrpe daemon on the client.
# It uses 5 parameters: $SERVICESTATE$ $STATETYPE$ $SERVICEATTEMPT$ $SERVICEDESC$ maxattempts

# The tries (in soft state) before a local service restart is invoked.
# Note: This value is set in an eventhandler definition on the Nagios server.
maxattempts=$5

#### #### The actual flow of parsing the parms #### ####
# What state is the service in?
case "$1" in
OK)
	# The service just came back up, so don't do anything...
	;;
WARNING)
	# We don't really care about warning states, since the service is probably still running...
	;;
UNKNOWN)
	# We don't know what might be causing an unknown error, so don't do anything...
	;;
CRITICAL)
	# Aha!  The service appears to have a problem - perhaps we should restart the server...
	
	# Is this a "soft" or a "hard" state?
	case "$2" in
		
	# We're in a "soft" state, meaning that Nagios is in the middle of retrying the
	# check before it turns into a "hard" state and contacts get notified...
	SOFT)

		# Count the check attempt.  We don't want to restart the service on the first
		# check, because it may just be a fluke!
		case "$3" in
				
		# Wait until the check has been tried the maximum number of times as set in the
		# eventhandler definition on the Nagios server before restarting the service.
		# If the check fails on the last time (after we restart the service), the state
		# type will turn to "hard" and contacts will be notified of the problem.
		$maxattempts)
			# Put an entry in the system log for debug purposes
			/usr/bin/logger -t nrpe "restart-daemon: (Re)starting /etc/init.d/$4 (state=$1, type=$2, attempt=$3)"
			# Call the init script to restart the service in question
			/usr/bin/sudo /etc/init.d/$4 restart
			;;
			esac
		;;
				
	# The service somehow managed to turn into a hard error without getting fixed.
	# It should have been restarted by the code above, but for some reason it didn't.
	# Let's give it one last try, shall we?  
	# Note: Contacts have already been notified of a problem with the service at this
	# point (unless you disabled notifications for this service)
	HARD)
		/usr/bin/logger -t nrpe "restart-daemon: (Re)starting /etc/init.d/$4 (state=$1, type=$2, attempt=$3)"
		# Call the init script to restart the service.
		/usr/bin/sudo /etc/init.d/$4 restart
		;;
	esac
	;;
esac
exit 0
