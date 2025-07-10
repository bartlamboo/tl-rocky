ARG ROCKY_RELEASE=9
FROM rockylinux:${ROCKY_RELEASE}
# yes got to repeat this line ... after FROM all is forgotten
ARG ROCKY_RELEASE=9
ENV ROCKY_RELEASE=${ROCKY_RELEASE}
STOPSIGNAL SIGRTMIN+3
COPY build /build
RUN cd /build; sh start.sh
RUN curl https://www.cendio.com/downloads/server/tl-4.18.0-server.zip > tl.zip; unzip tl.zip; rm -f tl.zip; cd tl-*-server/packages; rm -f *deb *_i386.deb; dnf localinstall *.rpm -y; cd /;rm -rf /tl-*-server; /opt/thinlinc/sbin/tl-setup -a /build/tl-setup-answers; rm -rf /build
#RUN curl https://www.cendio.com/downloads/beta/tl-4.13.0beta1-server.zip > tl.zip; unzip tl.zip;rm tl.zip; cd tl-*-server/packages;rm *rpm *_i386.deb;dpkg --install *.deb; cd /;rm -rf /tl-*-server; /opt/thinlinc/sbin/tl-setup -a /build/tl-setup-answers; rm -rf /build
# when the image actually runs, then systemd will be runnnig
# so put things in order again ...
COPY tlcfg.sh /sbin/tlcfg
RUN chmod 755 /sbin/tlcfg
CMD ["/sbin/init"]
