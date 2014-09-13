FROM ubuntu:14.04
MAINTAINER LifeGadget <contact-us@lifegadget.co>
 
RUN echo "Basic Environment Setup"
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y librtmp0 python-httplib2
ENV CB_USERNAME Adminstrator
ENV CB_PASSWORD password

RUN echo "Downloading Couchbase"
ENV CB_VERSION 2.5.1
ENV CB_FILENAME couchbase-server-enterprise_${CB_VERSION}_x86_64.deb
ENV CB_SOURCE http://packages.couchbase.com/releases/$CB_VERSION/$CB_FILENAME
RUN echo "Couchbase version: "$CB_VERSION
RUN echo "Couchbase source: "$CB_SOURCE
ADD $CB_SOURCE /tmp/

RUN echo "Installing Couchbase"
RUN dpkg -i /tmp/$CB_FILENAME
RUN echo "Configuring DATA directory"
VOLUME ["/data"]
ADD https://raw.githubusercontent.com/ksnyde/docker-couchbase/master/scripts/couch-bootstrap.sh /usr/local/sbin/couchbase
RUN chmod 755 /usr/local/sbin/couchbase
EXPOSE 9081 8092 11210

RUN echo "Cleaning Up"
RUN rm /tmp/$CB_FILENAME
 
# ADD http://cbfs-ext.hq.couchbase.com/dustin/software/confsed/confsed.lin64.gz /usr/local/sbin/confsed.gz
# RUN gzip -d /usr/local/sbin/confsed.gz
# RUN chmod 755 /usr/local/sbin/confsed

RUN echo "Setting container's entry point"
ENTRYPOINT ["/usr/local/sbin/couchbase"]