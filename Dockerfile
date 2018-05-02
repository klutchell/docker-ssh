FROM resin/raspberrypi3-alpine

LABEL maintainer="kylemharding@gmail.com"

# allow building on x86
RUN test -n "$(uname -m | grep 'arm')" \
	&& echo 'building on arm' \
	|| cross-build-start

# install git, openssh, and rsync
RUN apk add --no-cache \
	openssh \
	rsync \
	tzdata

# adjust sshd config
RUN sed -i \
	-e 's/#PasswordAuthentication yes/PasswordAuthentication no/' \
	-e 's/#GatewayPorts no/GatewayPorts yes/' \
	/etc/ssh/sshd_config

# store ssh data in a volume
VOLUME /root/.ssh

# install start script
COPY start.sh /usr/bin/start.sh

# run start script to generate keys if required
CMD [ "/usr/bin/start.sh" ]

# end cross build
RUN test -n "$(uname -m | grep 'arm')" \
	&& echo 'building on arm' \
	|| cross-build-end

