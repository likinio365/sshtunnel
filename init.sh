#!/bin/bash

# Configuration
LOG_FILE="/var/log/tunnel_script.log"

# Function to log messages
log_message() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
}

# Function to create SSH tunnel
create_tunnel() {
    local index=$1
    local forwarding=" -fN ${TUNNEL_HOST_USER[$index]}@${TUNNEL_HOST_ARRAY[$index]} -L *:${LOCAL_PORT_ARRAY[$index]}:${REMOTE_HOST_ARRAY[$index]}:${REMOTE_PORT_ARRAY[$index]}"
    local key="${KEY_ARRAY[$index]}"

    log_message "Using Key ${key} to create tunnel_$index ${forwarding}"

    ssh \
        -v \
        -o TCPKeepAlive=yes \
        -o ServerAliveCountMax=20 \
        -o ServerAliveInterval=15 \
        -o StrictHostKeyChecking=no \
        ${forwarding} \
        -i ${key}
}

# Main script execution
if [ "$REMOTE" = "true" ]; then
    IFS=',' read -r -a REMOTE_HOST_ARRAY <<< "$REMOTE_HOST"
    IFS=',' read -r -a LOCAL_PORT_ARRAY <<< "$LOCAL_PORT"
    IFS=',' read -r -a REMOTE_PORT_ARRAY <<< "$REMOTE_PORT"
    IFS=',' read -r -a TUNNEL_HOST_ARRAY <<< "$TUNNEL_HOST"
    IFS=',' read -r -a TUNNEL_HOST_USER <<< "$TUNNEL_USER"
    IFS=',' read -r -a KEY_ARRAY <<< "$KEY"

    for i in $(seq 0 $((${#REMOTE_HOST_ARRAY[@]} - 1))); do
        create_tunnel "$i"
    done

    log_message "All tunnels created. Entering sleep loop."
    while true; do sleep 10; done
else
    log_message "Invalid Environment options"
    echo "Invalid Environment options"
fi
