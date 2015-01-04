#!/bin/bash

yum -y install git

if [[ ! -d /tmp/pptpd-installer ]]; then
    git clone https://github.com/xifeng/pptpd-installer.git /tmp/pptpd-installer
    cd /tmp/pptpd-installer
else
    cd /tmp/pptpd-installer
    git pull
fi

cd resources
rpm -ivh epel-release-6-8.noarch.rpm
yum -y install pptpd iptables

cp -f pptpd.conf /etc/
cp -f options.pptpd /etc/ppp/
cp -f chap-secrets /etc/ppp/

/etc/init.d/pptpd restart
chkconfig pptpd on

iptables -F
iptables -t nat -F
iptables -X
iptables -t nat -X
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P INPUT ACCEPT
iptables -t nat -P OUTPUT ACCEPT
iptables -t nat -P POSTROUTING ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.208.0/24 -j MASQUERADE
/etc/init.d/iptables save
/etc/init.d/iptables restart
chkconfig iptables on
