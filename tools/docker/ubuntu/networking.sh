#!/bin/bash
rmmod ne2k-pci
modprobe ne2k-pci
sleep 1
INF=`ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d' | head -n 1`
ifconfig $INF hw ether 00:22:15:19:01:25
ifconfig $INF 10.5.225.253 netmask 255.255.0.0 up
EXIST=`ip route show 10.5.0.1 | wc -l`
if [ $EXIST -eq 0 ]
then
  route add default gw 10.5.0.1
fi