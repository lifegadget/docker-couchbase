FROM ubuntu:14.04
MAINTAINER LifeGadget <contact-us@lifegadget.co>
 
# Basic environment setup
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
	&& apt-get install -y librtmp0 python-httplib2 language-pack-en-base vim wget \
	&& dpkg-reconfigure locales
ENV CB_USERNAME Adminstrator
ENV CB_PASSWORD password

# Downloading and Installing Couchbase
ENV CB_VERSION 2.5.1
ENV CB_FILENAME couchbase-server-enterprise_${CB_VERSION}_x86_64.deb 
ENV CB_SOURCE http://packages.couchbase.com/releases/$CB_VERSION/$CB_FILENAME
RUN wget -O/tmp/$CB_FILENAME $CB_SOURCE  \
	&& dpkg -i /tmp/$CB_FILENAME  \
	&& rm /tmp/$CB_FILENAME

# Create directory structure for volume sharing
RUN mkdir -p /app \
	&& mkdir -p /app/data \
	&& mkdir -p /app/index \
	&& mkdir -p /app/resources \
	&& mkdir -p /app/conf \
	&& chown -R couchbase:couchbase /app
VOLUME ["/app/data"]
# Add bootstrapper
ADD resources/docker-couchbase /usr/local/bin/docker-couchbase
RUN export PATH=$PATH:/opt/couchbase/bin \
	&& echo "export PATH=$PATH:/opt/couchbase/bin" >> /etc/bash.bashrc
EXPOSE 8091 8092 11210

# Add a nicer bashrc config
ADD https://raw.githubusercontent.com/lifegadget/bashrc/master/snippets/history.sh /etc/bash.history
ADD https://raw.githubusercontent.com/lifegadget/bashrc/master/snippets/color.sh /etc/bash.color
ADD https://raw.githubusercontent.com/lifegadget/bashrc/master/snippets/shortcuts.sh /etc/bash.shortcuts
RUN { \
		echo ""; \
		echo 'source /etc/bash.history'; \
		echo 'source /etc/bash.color'; \
		echo 'source /etc/bash.shortcuts'; \
	} >> /etc/bash.bashrc

# Add Resources
ADD resources/couchbase.txt /app/resources/couchbase.txt
ADD resources/docker.txt /app/resources/docker.txt

ENTRYPOINT ["docker-couchbase"]
CMD	["start"]