#!/bin/bash

# Function library inclusion
. function.sh

# Temporary log file creation
TMP1=$(mktemp)
> "$TMP1"

# Start delimiter
BAR
CODE [NET-043] ICMP Redirect 차단 미설정

cat << EOF >> "$result"
[양호]: 네트워크 장비에 ICMP Redirect 차단이 적절하게 설정된 경우
[취약]: 네트워크 장비에 ICMP Redirect 차단이 설정되지 않은 경우
EOF

# End delimiter
BAR

# Network devices list
DEVICES=("Device1" "Device2" "Device3") # Replace with actual device list

# Checking ICMP redirect blocking on each device
for device in "${DEVICES[@]}"; do
    # Connect to each device and check ICMP redirect blocking configuration
    ICMP_REDIRECT_BLOCKING=$(ssh $device "show running-config | include icmp-redirect-block") # Replace with the actual command for checking ICMP redirect

    # Checking the status of ICMP redirect blocking
    if [[ $ICMP_REDIRECT_BLOCKING ]]; then
        OK "$device 에서 ICMP Redirect 차단이 적절하게 설정되었습니다."
    else
        WARN "$device 에서 ICMP Redirect 차단이 설정되지 않았습니다."
    fi
done

cat "$result"

echo ; echo
