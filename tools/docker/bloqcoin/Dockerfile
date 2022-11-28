FROM ubuntu:16.04 as ubuntu-bloqcoin
LABEL maintainer="Kris Henriksen"

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && \
	apt --yes --no-install-recommends install \
	linux-image-virtual \
	grub2 \
	systemd \
	initramfs-tools \
	net-tools \
	iputils-ping \
	iproute2 \
	libboost-system1.58.0 \
	libboost-filesystem1.58.0 \
	libboost-program-options1.58.0 \
	libboost-thread1.58.0 \
	libboost-chrono1.58.0 \
	libssl1.0.0 \
	libevent-pthreads-2.0-5 \
	libevent-2.0-5 \
	xserver-xorg-input-evdev \
	xserver-xorg-video-fbdev \
	xserver-xorg-video-vesa \
	xinit \
	x11-xserver-utils \
	dbus-x11 \	
	libterm-readline-perl-perl \
	xterm \
	libqt5network5 \
	libqt5widgets5 \
	libprotobuf9v5

RUN touch /root/.Xauthority && \
	chsh -s /bin/bash && \
	echo "root:root" | chpasswd && \
	mkdir -p /etc/systemd/system/serial-getty@ttyS0.service.d/ && \
	rm /lib/systemd/system/getty.target.wants/getty-static.service && \
	rm /etc/issue && \
	chmod -x /etc/update-motd.d/* && \
	touch /root/.hushlogin && \
	echo "tmpfs /tmp tmpfs nodev,nosuid 0 0" >> /etc/fstab

RUN systemctl enable serial-getty@ttyS0.service && \
	systemctl disable apt-daily-upgrade.timer && \
	systemctl mask apt-daily-upgrade.service && \
	systemctl disable apt-daily.timer && \
	systemctl mask apt-daily.service && \
	systemctl disable systemd-timesyncd.service && \
	systemctl mask systemd-timesyncd.service && \
	systemctl disable systemd-journald.service && \
	systemctl mask systemd-journald.service && \
	systemctl disable systemd-journal-flush.service && \
	systemctl mask systemd-journal-flush.service && \
	systemctl disable motd-news.timer && \
	systemctl mask motd-news.timer

COPY getty-autologin-serial.conf /etc/systemd/system/serial-getty@ttyS0.service.d/
COPY getty-noclear.conf /etc/systemd/system/getty@tty1.service.d/
COPY getty-override.conf /etc/systemd/system/getty@tty1.service.d/
COPY logind.conf /etc/systemd/
COPY boot-9p /etc/initramfs-tools/scripts/
COPY grub /etc/default/
COPY xorg.conf /etc/X11/

COPY networking.sh /root/

# this needs to be commented out in order to boot from hdd
RUN printf '%s\n' 9p 9pnet 9pnet_virtio virtio virtio_ring virtio_pci | tee -a /etc/initramfs-tools/modules && \
	echo 'BOOT=boot-9p' | tee -a /etc/initramfs-tools/initramfs.conf && \
	update-initramfs -u

# ReducingDiskFootprint
RUN apt-get --yes clean && \
	rm -r /var/lib/apt/lists/* && \
	rm -r /usr/share/doc/* && \
	rm -r /usr/share/man/* && \
	rm -r /usr/share/locale/?? && \	
	rm /var/log/*.log /var/log/lastlog /var/log/wtmp /var/log/apt/*.log

# Not technically necessary, but significantly reduces the amount of files loaded
# (prevents glxgears and possibly some other applications from working)
RUN rm -rf /usr/lib/i386-linux-gnu/libLLVM* \
	/usr/lib/i386-linux-gnu/dri/swrast_dri.so \
	/usr/lib/i386-linux-gnu/dri/kms_swrast_dri.so \
	/usr/lib/i386-linux-gnu/dri/i915_dri.so \
	/usr/lib/i386-linux-gnu/dri/i965_dri.so \
	/usr/lib/i386-linux-gnu/dri/nouveau_dri.so \
	/usr/lib/i386-linux-gnu/dri/nouveau_vieux_dri.so \
	/usr/lib/i386-linux-gnu/dri/r200_dri.so \
	/usr/lib/i386-linux-gnu/dri/r300_dri.so \
	/usr/lib/i386-linux-gnu/dri/r600_dri.so \
	/usr/lib/i386-linux-gnu/dri/radeon_dri.so \
	/usr/lib/i386-linux-gnu/dri/radeonsi_dri.so \
	/usr/lib/i386-linux-gnu/dri/virtio_gpu_dri.so \
	/usr/lib/i386-linux-gnu/dri/vmwgfx_dri.so

# Bloqcoin
COPY bloqcoin-0.12.2-ubuntu-16.04-x86.tar.gz /root/
RUN tar -xf /root/bloqcoin-0.12.2-ubuntu-16.04-x86.tar.gz -C /usr/local/
RUN rm -rf /root/bloqcoin-0.12.2-ubuntu-16.04-x86.tar.gz
RUN mkdir /root/.bloqcoin
COPY bloqcoin.conf /root/.bloqcoin/bloqcoin.conf
EXPOSE 28333