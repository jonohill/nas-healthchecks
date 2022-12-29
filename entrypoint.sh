#!/usr/bin/env bash

set -e

if [ -z "$PING_URL" ]; then
    echo "PING_URL is not set"
    exit 1
fi

while true; do

    logs=""

    for script in /scripts/*; do
        echo "Running $script"
        if ! output=$("$script"); then
            logs="$logs\n\n$output"
        fi
    done

    if [ -n "$logs" ]; then
        curl --data-raw "$logs" "$PING_URL/fail"
    else
        curl "$PING_URL"
    fi

    sleep "$RUN_FREQ"

done
