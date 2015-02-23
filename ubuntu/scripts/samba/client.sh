#!/usr/bin/env bash


# TODO: add kerberos client parameters 
# TODO: add /etc/hosts configuration check

source config.sh
[ $(id -u) != 0 ] && echo 'please execute as super user' && exit 1
export PATH=/sbin:/usr/sbin:/bin:/usr/bin:${PATH}
export DEBIAN_FRONTEND=noninteractive


apt-get update
apt-get dist-upgrade -y
apt-get install -y ntp winbind samba krb5-user smbclient cifs-utils libnss-winbind libpam-winbind cups


cat << EOF > /etc/samba/smb.con
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
        default_realm = LOCALDOMAIN.COM
        krb4_config = /etc/krb.conf
        krb4_realms = /etc/krb.realms
        kdc_timesync = 1
        ccache_type = 4
        forwardable = true
        proxiable = true
        fcc-mit-ticketflags = true
[realms]
        LOCALDOMAIN.COM = {
                kdc = SAMBA.LOCALDOMAIN.COM
                admin_server = SAMBA.LOCALDOMAIN.COM
        }
[domain_realm]
        .localdomain.com = LOCALDOMAIN.COM
[login]
        krb4_convert = true
        krb4_get_tickets = false
EOF


