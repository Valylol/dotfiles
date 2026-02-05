#!/bin/bash

# Ping target (you can change this)
TARGET="1.1.1.1"  # Cloudflare DNS - fast and reliable
# Alternative targets:
# TARGET="8.8.8.8"  # Google DNS
# TARGET="9.9.9.9"  # Quad9 DNS

# Ping once and get the time
PING_RESULT=$(ping -c 1 -W 2 $TARGET 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')

if [ -z "$PING_RESULT" ]; then
    # No connection
    echo "{\"text\":\"--ms\", \"tooltip\":\"No connection to $TARGET\"}"
else
    # Convert to integer
    PING_INT=$(echo $PING_RESULT | cut -d'.' -f1)
    
    echo "{\"text\":\"${PING_INT}ms\", \"tooltip\":\"Ping to $TARGET: ${PING_RESULT}ms\"}"
fi
