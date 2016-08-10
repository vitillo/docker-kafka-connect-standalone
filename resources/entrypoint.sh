#!/bin/bash

function addProperty() {
    local path=$1
    local key=$2
    local value=$3

    local entry="$key=$value"
    echo $entry >> $path
}

function configure() {
    local path=$1
    local envPrefix=$2

    echo "Configuring connector"
    for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do
        name=`echo ${c} | perl -pe 's/_/./g'`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        addProperty $path $name "$value"
    done
}

if [[ $CONNECTOR_HIVE_METASTORE_URIS =~ thrift://(.*) ]]; then
    dockerize -wait tcp://${BASH_REMATCH[1]} -timeout 300s
fi

configure connector.properties CONNECTOR
dockerize -wait tcp://$KAFKA_SERVER:9092 \
          -wait http://$SCHEMA_SERVER:8081 \
          -timeout 300s \
          -template connect-standalone.properties.template:connect-standalone.properties

OLD_IFS=$IFS
IFS=','
for topic in $CONNECTOR_topics; do
    kafka-topics --create --zookeeper $ZOOKEEPER_SERVER:2181 --replication-factor ${TOPICS_REPLICATION_FACTOR:-1} --partitions ${TOPICS_PARTITIONS:-1} --topic $topic
done
IFS=$OLD_IFS

exec $@
