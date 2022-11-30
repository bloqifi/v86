#!/bin/bash
rmmod ne2k-pci
modprobe ne2k-pci
sleep 1
ifconfig `ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d' | head -n 1` 10.5.225.253 netmask 255.255.0.0 up

EXIST=`ip route show 10.5.0.1 | wc -l`
if [ $EXIST -eq 0 ]
then
  route add default gw 10.5.0.1
fi