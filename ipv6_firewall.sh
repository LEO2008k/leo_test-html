#!/bin/bash
IPT6="/sbin/ip6tables"
PUBIF="eth1"
echo "Starting IPv6 firewall..."
$IPT6 -F
$IPT6 -X
$IPT6 -t mangle -F
$IPT6 -t mangle -X
 
#unlimited access to loopback
$IPT6 -A INPUT -i lo -j ACCEPT
$IPT6 -A OUTPUT -o lo -j ACCEPT
 
# DROP all incomming traffic
$IPT6 -P INPUT DROP
$IPT6 -P OUTPUT DROP
$IPT6 -P FORWARD DROP
 
# Allow full outgoing connection but no incomming stuff
$IPT6 -A INPUT -i $PUBIF -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT6 -A OUTPUT -o $PUBIF -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
 
# allow incoming ICMP ping pong stuff
$IPT6 -A INPUT -i $PUBIF -p ipv6-icmp -j ACCEPT
$IPT6 -A OUTPUT -o $PUBIF -p ipv6-icmp -j ACCEPT
 
############# add your custom rules below ############
### open IPv6  port 80 
#$IPT6 -A INPUT -i $PUBIF -p tcp --destination-port 80 -j ACCEPT
### open IPv6  port 22
#$IPT6 -A INPUT -i $PUBIF -p tcp --destination-port 22 -j ACCEPT
### open IPv6  port 25
#$IPT6 -A INPUT -i $PUBIF -p tcp --destination-port 25 -j ACCEPT
############ End custom rules ################
 
#### no need to edit below ###
# log everything else
$IPT6 -A INPUT -i $PUBIF -j LOG
$IPT6 -A INPUT -i $PUBIF -j DROP