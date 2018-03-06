#!/bin/bash

# start bluetoothd if bluetoothd is not running
if ! ( ps -fC bluetoothd ) ; then
   sudo /usr/local/bin/bluetoothd &
fi

if getent passwd edison && ! ( hciconfig -a | grep -q "PSCAN" ) ; then
   sudo killall bluetoothd
   sudo /usr/local/bin/bluetoothd &
fi

if ( hciconfig -a | grep -q "DOWN" ) ; then
   sudo hciconfig hci0 up
   sudo /usr/local/bin/bluetoothd &
fi

if !( hciconfig -a | grep -q $HOSTNAME ) ; then
   sudo hciconfig hci0 name $HOSTNAME
fi

if ( ifconfig bnep0 | grep -q "Device not found") ; then
    bt-pan client 2C:AE:2B:FE:EE:C3
fi

if !( ifconfig bnep0 | grep -q "inet addr") ; then
    dhclient bnep0
fi
