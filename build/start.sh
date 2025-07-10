#!/bin/sh
set -e
set -x
echo Installing Rocky $UBUNTU_RELEASE
dnf update -y --setopt=fastestmirror=1
dnf install unzip vim-enhanced -y
dnf groupinstall "GNOME" -y --allowerasing --setopt=fastestmirror=1
dnf clean all

# disable services we do not need
systemctl disable gdm upower fstrim.timer fstrim

# Prevents apt-get upgrade issue when upgrading in a container environment.
# Similar to https://bugs.launchpad.net/ubuntu/+source/makedev/+bug/1675163

cp locale.conf /etc/locale.conf
cp locale /etc/default/locale

# make sure we get fresh ssh keys on first boot
/bin/rm -f -v /etc/ssh/ssh_host_*_key*
cp *.service /etc/systemd/system
systemctl enable regenerate_ssh_host_keys
