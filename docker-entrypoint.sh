#!/bin/sh
date

if [ -z "$INTERFACE_SIP" ]; then
    INTERFACE_SIP="eth0"
fi
SIP_IP=$(ip -o -4 a | awk '$2 == "'$INTERFACE_SIP'" { gsub(/\/.*/, "", $4); print $4 }')

HOSTNAME=$(hostname)
export KAMAILIO=$(which kamailio)
export PATH_KAMAILIO_CFG=/etc/kamailio/kamailio.cfg

mkdir -p /etc/kamailio/

echo '#!define LISTEN '$LISTEN > /etc/kamailio/kamailio-local.cfg
if ! [ -z "$DISPATCHER_ALG" ]; then
    echo '#!define DISPATCHER_ALG "'$DISPATCHER_ALG'"' >> /etc/kamailio/kamailio-local.cfg
fi
if ! [ -z "$LISTEN_ADVERTISE" ]; then
    echo '#!define LISTEN_ADVERTISE '$LISTEN_ADVERTISE >> /etc/kamailio/kamailio-local.cfg
fi
if ! [ -z "$ALIAS" ]; then
    echo '#!define ALIAS '$ALIAS >> /etc/kamailio/kamailio-local.cfg
fi

if ! [ -z "$DISPATCHER_LIST" ]; then
    echo "$DISPATCHER_LIST" | sed 's/\\n */\n/g' > /etc/kamailio/dispatcher.list
else
    echo '# setid(int) destination(sip uri) flags(int,opt) priority(int,opt) attributes(str,opt)' > /etc/kamailio/dispatcher.list
fi

# Test the syntax.
$KAMAILIO -f $PATH_KAMAILIO_CFG -c

# Run kamailio
$KAMAILIO -m 512 -M 32 -f $PATH_KAMAILIO_CFG -DD -E -e
