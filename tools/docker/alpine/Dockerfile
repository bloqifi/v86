FROM alpine:3.7 as alpine-blockchain
LABEL maintainer="Kris Henriksen"

RUN apk update && \
	apk upgrade && \
	apk add --no-cache \
	linux-vanilla \
	grub \
	openrc \
	boost \
	boost-program_options \
	libevent \
	openssl

RUN rc-update add devfs sysinit && \
	rc-update add root boot && \
	rc-update add mtab boot && \
	rc-update add mount-ro shutdown && \
	rc-update add killprocs shutdown && \
	echo 'rc_sys=""' >> /etc/rc.conf

COPY inittab fstab /etc/
COPY grub.cfg /boot/

# build Bloqcoin from source
#RUN apk add --update alpine-sdk
#RUN apk add --no-cache gcc git libffi musl-dev libffi-dev autoconf automake
#RUN apk add --no-cache openssh-client make db-dev openssl openssl-dev
#RUN apk add --no-cache boost boost-dev libtool libevent libevent-dev

#ADD ./build-bloqcoin.sh /root/
#RUN /root/build-bloqcoin.sh

ADD ./networking.sh /root/

# bloqcoin
COPY bloqcoin-0.12.2-alpine-3.7.2-x86.tar.gz /root/
RUN tar -zxvf /root/bloqcoin-0.12.2-alpine-3.7.2-x86.tar.gz -C /usr/local/
RUN rm -rf /root/bloqcoin-0.12.2-alpine-3.7.2-x86.tar.gz

RUN mkdir -p /root/.bloqcoin
ADD ./bloqcoin.conf /root/.bloqcoin

CMD ["/usr/local/bin/bloqcoind"]

EXPOSE 28333