#!/bin/sh

untilsuccessful() {
    "$@"
    while [ $? -ne 0 ]
    do
	    echo Retrying...
	    sleep 1
        "$@"
    done
}

# Ensure proper directories before startup
cd /opt/couchbase
mkdir -p var/lib/couchbase var/lib/couchbase/config var/lib/couchbase/data \
    var/lib/couchbase/stats var/lib/couchbase/logs var/lib/moxi
chown -R couchbase:couchbase var
# Start the daemon
/etc/init.d/couchbase-server start

# int=`ip route | awk '/^default/ { print $5 }'`
# addr=`ip route | egrep "^[0-9].*$int" | awk '{ print $9 }'`
#
# if [ -z "$DOCKER_EXT_ADDR" ]
# then
#     DOCKER_EXT_ADDR="$addr"
# fi

# echo "{\"$addr\": \"$DOCKER_EXT_ADDR\", \"127.0.0.1\": \"$DOCKER_EXT_ADDR\"}" > /tmp/confsed.json

# /usr/local/sbin/confsed -rewriteconf /tmp/confsed.json http://localhost:8091/ &

# if [ -n "$ALPHA_PORT_7081_TCP_ADDR" ]
# then
#     echo "Joining cluster at $ALPHA_PORT_7081_TCP_ADDR"
#     untilsuccessful /opt/couchbase/bin/couchbase-cli server-add -c $ALPHA_PORT_7081_TCP_ADDR:8091 \
#         --user=Administrator --password=password --server-add=$addr:8091
# else
#     echo "Starting cluster"
#     untilsuccessful /opt/couchbase/bin/couchbase-cli cluster-init -c 127.0.0.1:8091 \
#         --cluster-init-username=Administrator --cluster-init-password=password \
#         --cluster-init-ramsize=512
#
#     untilsuccessful /opt/couchbase/bin/couchbase-cli bucket-create -c 127.0.0.1:8091 \
#         -u Administrator -p password --bucket=default -c localhost:8091 \
#         --bucket-ramsize=128
# fi

sleep 2
untilsuccessful /opt/couchbase/bin/couchbase-cli node-init -c 127.0.0.1:8091 \
	-u Administrator -p password --node-init-data-path=/data
untilsuccessful /opt/couchbase/bin/couchbase-cli node-init -c 127.0.0.1:8091 \
	-u Administrator -p password --node-init-index-path=/data

exec /bin/bash