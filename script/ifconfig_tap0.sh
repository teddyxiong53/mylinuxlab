#!/bin/sh 

#wait qemu start, then the tap0 will exist.
sleep 5

ifconfig tap0 192.168.0.1 netmask 255.255.255.0

