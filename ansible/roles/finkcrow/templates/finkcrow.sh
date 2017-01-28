#!/bin/bash

## Finkcrow is a simple monitoring and alerting script for checking
## stopped or running unix services. Finkcrow has written
## by Roozbeh Shafiee (me@roozbeh.cloud).

source /etc/finkcrow.conf

while sleep $check_interval
do
	service_is_up=`service $service_check status >/dev/null ; echo $?`
	if [ "$service_is_up" != "0" ]; then
		echo "--------------`date`-------------------" >> $log_file
		echo "Service $service_check is down" >> $log_file
		num=0
		set_down_up_to=$down_up_to
		while [ "$set_down_up_to" != "0" ]
		do
			sleep $down_interval_check
			((++num))
			echo "Start attemp $num" >> $log_file
			service_is_restarted=`service $service_check restart >/dev/null ; echo $?`
			if [ "$service_is_restarted" = "0" ]; then
				echo "Attemp $num result: Successful" >> $log_file
				break
			else
				((--set_down_up_to))
				echo "Attemp $num result: Unsuccessful" >> $log_file
			fi
		done
		if [ "$set_down_up_to" = "0" ]; then
			echo "Service $service_check is Down." > /tmp/email
			echo "Service $service_check can't be started after $down_up_to attemps." >> /tmp/email
			cat /tmp/email | mailx -s "Watchdog notification" $email_send_to
			rm -f /tmp/email
			exit 1
		else
			echo "Service $service_check is Down." > /tmp/email
			echo "Service $service_check has been started after $num attemps." >> /tmp/email
			cat /tmp/email | mailx -s "Watchdog notification" $email_send_to
			rm -f /tmp/email
		fi
	fi
done
