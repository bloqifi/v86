FROM ubuntu:16.04 as ubuntu-blockchain
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
		libevent-2.0-5

RUN chsh -s /bin/bash && \
    echo "root:random" | chpasswd && \
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
	systemctl disable getty@tty1.service && \
	systemctl mask getty@tty1.service && \
	systemctl disable remote-fs.target && \
	systemctl mask remote-fs.target && \
	systemctl disable motd-news.timer && \
	systemctl mask motd-news.timer

COPY getty-autologin-serial.conf /etc/systemd/system/serial-getty@ttyS0.service.d/
COPY logind.conf /etc/systemd/
COPY boot-9p /etc/initramfs-tools/scripts/
COPY grub /etc/default/

# init network
COPY networking.sh /root/

# keep Bloqcoin alive
COPY bloqcoind.service /etc/systemd/system/
RUN systemctl enable bloqcoind.service

# this needs to be commented out in order to boot from hdd
RUN printf '%s\n' 9p 9pnet 9pnet_virtio virtio virtio_ring virtio_pci | tee -a /etc/initramfs-tools/modules && \
    echo 'BOOT=boot-9p' | tee -a /etc/initramfs-tools/initramfs.conf && \
    update-initramfs -u

# ReducingDiskFootprint
RUN apt-get remove --purge perl && \
	apt-get autoremove --purge
RUN apt-get --yes clean && \
    rm -r /var/lib/apt/lists/* && \
    rm -r /usr/share/doc/* && \
    rm -r /usr/share/man/* && \
    rm -r /usr/share/locale/?? && \	
    rm /var/log/*.log /var/log/lastlog /var/log/wtmp /var/log/apt/*.log && \
	# aggressively
	rm -rf /var/lib/apt/* && \
	rm -rf /var/lib/systemd/* && \
	rm -rf /var/lib/dpkg/* && \
	rm -rf /var/cache/* && \
	rm -rf /var/log/* && \
	rm -rf /usr/share/* && \
	rm -rf /bin/journalctl && \
	rm -rf /bin/journalctl && \
	rm -rf /usr/lib/locale && \
	rm -rf /usr/lib/i386-linux-gnu/gconv && \
	rm -rf /usr/lib/i386-linux-gnu/libdb-5.3.so && \
	rm -rf /usr/lib/i386-linux-gnu/libapt-pkg.so.5.0.0 && \
	rm -rf /usr/bin/gpg* && \
	rm -rf /usr/bin/grub* && \
	rm -rf /usr/sbin/* && \
	rm -rf /usr/lib/i386-linux-gnu/perl && \
	rm -rf /usr/lib/i386-linux-gnu/perl-base && \
	rm -rf /usr/lib/i386-linux-gnu/libperl.so.5.22* && \
	rm -rf /usr/bin/perl* && \
	rm -rf /usr/bin/systemd-analyze* && \
	rm -rf /lib/firmware/4.4.0-210-generic/* && \
	rm -rf /lib/modules/4.4.0-210-generic/kernel/lib/test_bpf.ko && \
	rm -rf /lib/modules/4.4.0-210-generic/kernel/lib/raid6 && \
	rm -rf /lib/modules/4.4.0-210-generic/kernel/wireguard && \
	rm -rf /lib/modules/4.4.0-210-generic/kernel/sound && \
	rm -rf /lib/modules/4.4.0-210-generic/kernel/drivers/scsi && \
	rm -rf /lib/modules/4.4.0-210-generic/kernel/drivers/usb && \
	rm -rf /lib/modules/4.4.0-210-generic/kernel/drivers/gpu && \
	rm -rf /lib/modules/4.4.0-210-generic/kernel/drivers/md && \
	rm -rf /lib/modules/4.4.0-210-generic/kernel/drivers/target && \
	rm -rf /lib/modules/4.4.0-210-generic/kernel/drivers/infiniband && \
	mv /lib/modules/4.4.0-210-generic/kernel/drivers/net/ethernet /lib/modules/4.4.0-210-generic/kernel/drivers/ && \
	rm -rf /lib/modules/4.4.0-210-generic/kernel/drivers/net/* && \
	mv /lib/modules/4.4.0-210-generic/kernel/drivers/ethernet /lib/modules/4.4.0-210-generic/kernel/drivers/net/


# Bloqcoin
COPY bloqcoin-0.12.2-ubuntu-16.04-x86.tar.gz /root/
RUN tar -xf /root/bloqcoin-0.12.2-ubuntu-16.04-x86.tar.gz -C /usr/local/
RUN rm -rf /root/bloqcoin-0.12.2-ubuntu-16.04-x86.tar.gz
RUN mkdir /root/.bloqcoin
COPY bloqcoin.conf /root/.bloqcoin/bloqcoin.conf
EXPOSE 28333