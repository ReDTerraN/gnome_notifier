#!/bin/bash
# Used by Update Notifier module inside puppet
#notify_interval=$(hiera update_notifier::notify_interval)
notify_interval=10
#message=$(hiera update_notifier::message)
updates=$(/usr/local/bin/check-update)
last_notification_file="/var/tmp/update-notify.last-notification"

if [[ $updates -gt 0 ]]; then
	if [[ ! -f "$last_notification_file" || $(($(date +%s) - $(cat $last_notification_file))) -gt $notify_interval ]]; then
	#su -l $user -c "/usr/bin/notify-send -i /usr/share/icons/Adwaita/48x48/apps/help-contents-symbolic.symbolic.png '$updates updates available, message'"
    	echo $(date +%s) > $last_notification_file
    	# Detect the name of the display in use
    	display=":$(ls /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"

    	# Detect the user using such display
    	user=$(who | grep '('$display')' | awk '{print $1}' | head -n 1)

    	# Detect the id of the user
     	uid=$(id -u $user)
    	# Now we actually do it
    	sudo -u $user DISPLAY=$display DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus notify-send "$updates updates available" -i /etc/puppet/modules/update_notifier/files/exclmark.png

	fi
fi
