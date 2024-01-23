#!/bin/bash

# Include the function library
. function.sh

# Create a temporary log file
TMP1=$(mktemp)
> "$TMP1"

# Start and end delimiter for the log
BAR

# Specific code for the check
CODE [NET-045] ICMP Mask-Reply 차단 미설정

cat << EOF >> "$result"
[양호]: ICMP Mask-Reply 차단이 적절하게 설정된 경우
[취약]: ICMP Mask-Reply 차단이 설정되지 않은 경우
EOF

BAR

# List of network devices to check
DEVICES=("Device1" "Device2" "Device3") # Replace with actual device list

# Check ICMP mask-reply blocking on each device
for device in "${DEVICES[@]}"; do
    # SSH into each device and check the ICMP mask-reply blocking configuration
    ICMP_MASK_REPLY_BLOCKING=$(ssh $device "show running-config | include icmp-mask-reply-block") # Replace with the actual command for your devices

    # Check if the ICMP mask-reply blocking is properly configured
    if [[ $ICMP_MASK_REPLY_BLOCKING ]]; then
        OK "$device 에서 ICMP Mask-Reply 차단이 적절하게 설정되었습니다."
    else
        WARN "$device 에서 ICMP Mask-Reply 차단이 설정되지 않았습니다."
    fi
done

cat "$result"

echo ; echo
