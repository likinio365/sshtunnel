#!/bin/bash



if [ "$REMOTE" = "true" ]; then
        IFS=',' read -r -a REMOTE_HOST_ARRAY <<< "$REMOTE_HOST"
        IFS=',' read -r -a LOCAL_PORT_ARRAY <<< "$LOCAL_PORT"
        IFS=',' read -r -a REMOTE_PORT_ARRAY <<< "$REMOTE_PORT"
        IFS=',' read -r -a TUNNEL_HOST_ARRAY <<< "$TUNNEL_HOST"
        IFS=',' read -r -a TUNNEL_HOST_USER  <<< "$TUNNEL_USER"
        IFS=',' read -r -a KEY_ARRAY <<< "$KEY"
        FORWARDING=""

        for I in $(seq 0 $H); do
                FORWARDING=" -fN ${TUNNEL_HOST_USER[$I]}@${TUNNEL_HOST_ARRAY[$I]} -L *:${LOCAL_PORT_ARRAY[$I]}:${REMOTE_HOST_ARRAY[$I]}:${REMOTE_PORT_ARRAY[$I]}"
                KEYS=" ${KEY_ARRAY[$I]}"
        echo "Using Key ${KEYS} to create tunnel_$I ${FORWARDING}"

        ssh \
                -v \
                -o TCPKeepAlive=yes \
                -o ServerAliveCountMax=20 \
                -o ServerAliveInterval=15 \
                -o StrictHostKeyChecking=no \
                ${FORWARDING} \
                -i ${KEYS}

        done
        while true; do sleep 10; done;
else
    echo "Invalid Environment options"
fi
