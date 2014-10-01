FROM ubuntu:14.04
MAINTAINER LifeGadget <contact-us@lifegadget.co>
 
# Basic environment setup
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y librtmp0 python-httplib2
ENV CB_USERNAME Adminstrator
ENV CB_PASSWORD password

# Download Couchbase
ENV CB_VERSION 2.5.1
ENV CB_FILENAME couchbase-server-enterprise_${CB_VERSION}_x86_64.deb
ENV CB_SOURCE http://packages.couchbase.com/releases/$CB_VERSION/$CB_FILENAME
# Add download to tmp directory
ADD $CB_SOURCE /tmp/

# Installing Couchbase
RUN dpkg -i /tmp/$CB_FILENAME
# Create directory structure for volume sharing
RUN mkdir -p /app \
	&& mkdir -p /app/data \
	&& mkdir -p /app/resources \
	&& mkdir -p /app/conf 
VOLUME ["/app/data"]
# Add bootstrapper
ADD resources/docker-couchbase /usr/local/bin/docker-couchbase
RUN chmod 755 /usr/local/sbin/couchbase
EXPOSE 8091 8092 11210
# Cleaning up
RUN rm /tmp/$CB_FILENAME

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
RUN mkdir /opt/couchbase/ascii
ADD ascii/couchbase.txt /app/resources/couchbase.txt
ADD ascii/docker.txt /app/resources/docker.txt

ENTRYPOINT ["docker-couchbase"]
CMD	["start"]