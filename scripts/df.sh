#!/usr/bin/env bash

if [ -z "$DF_FILESYSTEMS" ]; then
    echo "DF_FILESYSTEMS is not set, not checking anything"
    exit 0
fi

DF_HIGHWATERMARK=${DF_HIGHWATERMARK:-90}

# Convert the comma separated list into an array
IFS=',' read -r -a filesystems <<< "$DF_FILESYSTEMS"

echo "Checking filesystems: ${filesystems[*]}. Highwatermark: $DF_HIGHWATERMARK%"

has_error=0
while read -r filesystem pcent avail; do
    if [[ " ${filesystems[*]} " == *" $filesystem "* ]]; then
        # Remove trailing % from pcent
        pcent=${pcent%?}
        if [ "$pcent" -gt "$DF_HIGHWATERMARK" ]; then
            echo "ERROR: $filesystem is $pcent% full, $avail available"
            has_error=1
        fi
    fi
done < <(df -h --output=source,pcent,avail)

if [ "$has_error" -eq 1 ]; then
    exit 1
fi

echo "OK: All filesystems are below $DF_HIGHWATERMARK%"
