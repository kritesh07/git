#!/bin/bash

echo "Your server's Hostname"
read hostname
hostname $hostname

echo "Put Your IP Address"
read IPaddress

echo "TYPE=Ethernet
BOOTPROTO=ststic
NAME=enp0s3
DEVICE=enp0s3
ONBOOT=yes
IPADDR=$IPaddress
GATEWAY=192.168.72.1
NETMASK=255.255.255.0
BROADCAST=192.168.72.255" > /etc/sysconfig/network-scripts/ifcfg-enp0s3


echo "$IPaddress	$hostname" > /etc/hosts

echo "search $hostname
nameserver 192.168.72.1" > /etc/resolv.conf

systemctl restart network 

ping -c5 8.8.8.8