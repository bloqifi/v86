#!/bin/bash
modprobe ne2k-pci

FACE=`ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d' | head -n 1`

ifconfig $FACE 10.5.225.253 netmask 255.255.0.0 up
route add default gw 10.5.0.1
echo "nameserver 8.8.8.8" > /etc/resolv.conf