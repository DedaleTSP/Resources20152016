#!/bin/sh
wget --spider www.google.fr
while [ "$?" != 0 ] ; do 
	sleep 2
	wget --spider www.google.fr 
done
while [ `cat /sys/class/net/wlan1/operstate` != "up" ] ; do
	sleep 2
done
ip addr show wlan1 | mail -s "RaspberryIP" qsdsqd@qsdsqd.com
