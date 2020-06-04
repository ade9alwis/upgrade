#!/bin/bash

#Disable SELinux until reboot
setenforce 0

#install prerequisites for upgrade
yum install epel-release -y 
yum install yum-utils -y 
yum install rpmconf -y 
rpmconf -a 
yum makecache fast

#Show programs unaffected by upgrade
package-cleanup --leaves 

#Show orphaned packages that neeed attention
package-cleanup --orphans 

#Remove these packages
#yum remove -y bind-libs-lite-9.11.4-9.P2.el7.x86_64 
yum remove -y bind-libs-lite-*

#yum remove -y libsysfs-2.1.0-16.el7.x86_64  
yum remove -y libsysfs-*

#yum remove -y kernel-3.10.0-957.el7.x86_64
 yum remove -y kernel-3.*
 dnf makecache

#Install Centos 8 installer program dnf
yum -y install dnf 

#remove yum and components

dnf -y remove yum yum-metadata-parser 
rm -Rf /etc/yum 

#install the upgrade
#dnf -y upgrade http://mirror.centos.org/centos/8.1.1911/BaseOS/x86_64/os/Packages/centos-release-8.1-1.1911.0.9.el8.x86_64.rpm
#install the gpg-keys
#dnf -y upgrade http://mirror.centos.org/centos/8.1.1911/BaseOS/x86_64/os/Packages/centos-gpg-keys-8.1-1.1911.0.9.el8.noarch.rpm

#install epel for Centos 8
#dnf -y install http://mirror.centos.org/centos/8.1.1911/BaseOS/x86_64/os/Packages/centos-repos-8.1-1.1911.0.9.el8.x86_64.rpm 

dnf install http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/{centos-release-8.1-1.1911.0.8.el8.x86_64.rpm,centos-gpg-keys-8.1-1.1911.0.8.el8.noarch.rpm,centos-repos-8.1-1.1911.0.8.el8.x86_64.rpm}

#dnf -y upgrade https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm 
dnf upgrade -y epel-release

dnf clean all 

rpm -e `rpm -q kernel` 

rpm -e --nodeps sysvinit-tools 

dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync 


dnf -y install kernel-core 

dnf -y groupupdate "Core" "Minimal Install"

dnf -y install kernel

cat /etc/redhat-release 

dnf -y install gcc 

dnf -y install annobin

yum install 'dnf-command(config-manager)'

dnf config-manager --set-enabled AppStream

dnf config-manager --set-enabled BaseOS

dnf config-manager --set-enabled centosplus

dnf config-manager --set-enabled extras

dnf config-manager --set-enabled fasttrack

dnf config-manager --set-enabled PowerTools

dnf config-manager --set-enabled HighAvailability

dnf config-manager --set-enabled AppStream-source

dnf config-manager --set-enabled BaseOS-source

dnf config-manager --set-enabled extras-source

dnf config-manager --set-enabled centosplus-source

dnf -y update 

echo "The script finished successfully. Please see unaffteced programs.txt and orphaned programs.txt in Upgrade_Log on the root (/) of the drive. You may need to update, remove and reinstall the orphaned packages to the correct version."

touch /.autorelabel

