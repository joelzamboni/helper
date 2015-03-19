#!/usr/bin/env bash

# TODO: add pam-auth-update
# TODO: automate domain join (net ads join -U administrator)
# TODO: fix mkhomedir
# TODO: add cache credentials (sudo apt-get install libpam-ccreds)

source config.sh
[ $(id -u) != 0 ] && echo 'please execute as super user' && exit 1
export PATH=/sbin:/usr/sbin:/bin:/usr/bin:${PATH}
export DEBIAN_FRONTEND=noninteractive
client_ip=$(ip route get 8.8.8.8|grep 8.8.8.8 |awk '{print $NF}')

apt-get update
apt-get dist-upgrade -y
apt-get install -y ntp winbind samba krb5-user smbclient cifs-utils libnss-winbind libpam-winbind cups acl

cat << EOF > /etc/hosts
127.0.0.1 localhost
127.0.0.1 $(hostname).${domainname} $(hostname)
${client_ip} $(hostname).${domainname} $(hostname)
# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF

cat << EOF > /etc/samba/smb.conf
[global]
        security = ads
        realm = ${domainname}
        password server = ${ip}
        workgroup = ${netbiosdomain}
        idmap uid = 10000-20000
        idmap gid = 10000-20000
        winbind enum users = yes
        winbind enum groups = yes
        template homedir = /home/%D/%U
        template shell = /bin/bash
        client use spnego = yes
        client ntlmv2 auth = yes
        encrypt passwords = yes
        winbind use default domain = yes
        restrict anonymous = 2
EOF

cat << EOF > /etc/nsswitch.conf
passwd:         compat winbind
group:          compat winbind
shadow:         compat
hosts:          files dns
networks:       files
protocols:      db files
services:       db files
ethers:         db files
rpc:            db files
netgroup:       nis
EOF

cat << EOF > /usr/share/pam-configs/mkhomedir
Name: Create home directory on login
Default: no
Priority: 0
Session-Type: Additional
Session-Interactive-Only: yes
Session:
	optional			pam_mkhomedir.so
EOF

cat << EOF > /etc/krb5.conf
[libdefaults]
        default_realm = $(echo $domainname | tr 'a-z' 'A-Z')
        krb4_config = /etc/krb.conf
        krb4_realms = /etc/krb.realms
        kdc_timesync = 1
        ccache_type = 4
        forwardable = true
        proxiable = true
        fcc-mit-ticketflags = true
[realms]
        $(echo $domainname | tr 'a-z' 'A-Z') = {
                kdc = $(echo $(hostname).${domainname} | tr 'a-z' 'A-Z')
                admin_server = $(echo $(hostname).${domainname} | tr 'a-z' 'A-Z') 
        }
[domain_realm]
        .${domainname} = $(echo $domainname | tr 'a-z' 'A-Z')
[login]
        krb4_convert = true
        krb4_get_tickets = false
EOF

cat << EOF > /etc/resolvconf/resolv.conf.d/base
nameserver $ip
search $domainname
EOF


