FROM ubuntu:14.04
MAINTAINER LifeGadget <contact-us@lifegadget.co>
 
# Basic environment setup
# note: SpiderMonkey build req's: https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Build_Instructions/Linux_Prerequisites
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

# SpiderMonkey dependencies
ENV MOZ_JS_VERSON 24.2.0
RUN apt-get install -y unzip mercurial g++ make autoconf2.13 yasm libgtk2.0-dev libglib2.0-dev  \
	&& apt-get install -y libdbus-1-dev libdbus-glib-1-dev libasound2-dev libcurl4-openssl-dev libiw-dev libxt-dev mesa-common-dev \
	&& apt-get install -y libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libpulse-dev m4 flex ccache 
# Download and Configure SpiderMonkey
RUN mkdir -p /tmp/spidermonkey \
	&& cd /tmp/spidermonkey \
	&& wget -O/tmp/spidermonkey/mozjs-$MOZ_JS_VERSON.tar.bz2 http://ftp.mozilla.org/pub/mozilla.org/js/mozjs-$MOZ_JS_VERSON.tar.bz2 \
	&& tar -xjf mozjs-$MOZ_JS_VERSON.tar.bz2 \
	&& cd mozjs-24.2.0/js/src \
	&& autoconf2.13 \
	&& mkdir build-release \
	&& cd build-release \
	&& ../configure 
# Make and Install SpiderMonkey (and add jsawk and resty too)
RUN make \
	&& make install \
	&& wget -O/usr/local/bin/jsawk http://github.com/micha/jsawk/raw/master/jsawk \
	&& wget -O/usr/local/bin/resty http://github.com/micha/resty/raw/master/resty \
	&& { \
		echo ""; \
		echo "source /usr/local/bin/resty"; \
		echo ""; \
	} >> /etc/bash.bashrc
	
	
# Create directory structure for volume sharing
RUN mkdir -p /app \
	&& mkdir -p /app/data \
	&& mkdir -p /app/index \
	&& mkdir -p /app/resources \
	&& mkdir -p /app/conf \
	&& mkdir -p /app/backup \
	&& chown -R couchbase:couchbase /app
VOLUME ["/app/data"]
VOLUME ["/app/backup"]
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