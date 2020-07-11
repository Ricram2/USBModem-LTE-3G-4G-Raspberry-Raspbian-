#!/bin/bash
# close other connections to avoid routing trouble
idconfig wlan0 down
#ifconfig eth0 down
# start services if not running yet
service modemmanager restart
service network-manager restart
# remind me to plug in the surf stick ;-)
echo insert stick
# wait until it is there and switch to modem mode
while [ ! -e /dev/sr0 ] ; do sleep 1 ; done
echo Stick found
sleep 3
echo ejecting sr0
eject sr0
# be verbose to make the 60 seconds more comfortable... 
# we watch syslog to see what's happening
echo "waiting 60s for unlocking of stick (when it's green you can ctrl-c and call wvdial)"
tail -f /var/log/syslog &
for s in $(seq 60) ; do 
 echo ; echo -n "${s}s: "
 sleep 1
done
# hoping that we were waiting long enough (modem-manager asks us to enter the PIN in the meantime) - we stop watching syslog
kill %1
echo
echo to disconnect press ctrl-c
# dial in
wvdial
# after user hits ctrl-c we stop the managers again so that we can manually start other network connections again
service modemmanager stop
service network-manager stop
route add default dev ppp0
