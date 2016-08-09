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
        name=`echo ${c} | perl -pe 's/_/./g' | perl -ne 'print lc'`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        addProperty $path $name "$value"
    done
}

configure connector.properties CONNECTOR
dockerize -template connect-standalone.properties.template:connect-standalone.properties

exec $@
