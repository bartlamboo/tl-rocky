FROM rockylinux:9
ENV container=docker
RUN dnf -y install systemd systemd-libs systemd-pam dbus
RUN systemctl mask dev-hugepages.mount sys-fs-fuse-connections.mount sys-kernel-config.mount display-manager.service getty@.service console-getty.service systemd-logind.service systemd-remount-fs.service systemd-udevd.service systemd-udev-trigger.service gdm.service upower.service fstrim.timer fstrim.service
VOLUME [ "/sys/fs/cgroup" ]
RUN dnf update -y
RUN dnf install epel-release -y
RUN dnf install wget git unzip vim-enhanced htop screen openssh-server sudo dialog curl lsb-release joe man-db net-tools dbus-x11 -y --allowerasing
RUN dnf groupinstall "GNOME" -y --allowerasing
STOPSIGNAL SIGRTMIN+3
RUN curl https://www.cendio.com/downloads/server/tl-4.19.0-server.zip > tl.zip; 
RUN unzip tl.zip
RUN rm -f tl.zip
RUN dnf localinstall tl-*-server/packages/*.rpm -y
RUN dnf clean all
RUN rm -rf /tl-*-server
COPY tl-setup-answers /root/tl-setup-answers
RUN /opt/thinlinc/sbin/tl-setup -a /root/tl-setup-answers
COPY tlcfg.sh /sbin/tlcfg
RUN chmod 755 /sbin/tlcfg
CMD ["/usr/sbin/init"]
