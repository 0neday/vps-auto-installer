#!/bin/sh

yum install epel-release -y

yum install iptables-services dnsmasq libev libsodium mbedtls -y

systemctl disable firewalld
systemctl stop firewalld

systemctl enable iptables
systemctl enable dnsmasq

cd /opt/backup-for-vps

cp -rf iptables-for-wg  /etc/sysconfig/iptables
cp -rf ip6tables /etc/sysconfig/ip6tables

cp -rf dnsmasq.conf /etc/dnsmasq.conf
cp -rf block.conf /etc/dnsmasq.d/

mkdir -p ~/.ssh/
chmod 700 ~/.ssh
cp -rf id_rsa.pub ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

#yum install gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto c-ares-devel libev-devel libsodium-devel mbedtls-devel boost-system boost-program-options nginx -y

#service nginx restart
#systemctl enable nginx

cp -rf  sysctl.conf /etc/sysctl.conf
sysctl -p

hostnamectl set-hostname trojan-us

cp -rf  rc.local-for-wg  /etc/rc.local
chmod +x /etc/rc.local
/etc/rc.local

cp -rf resolv.conf /etc/resolv.conf
chattr +i /etc/resolv.conf

netstat  -nlpt

# wireguard
yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
yum -y --enablerepo=elrepo-kernel install kernel-ml
sed -i "s/GRUB_DEFAULT=saved/GRUB_DEFAULT=0/" /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

reboot


