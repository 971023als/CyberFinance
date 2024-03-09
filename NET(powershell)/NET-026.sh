#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-026] Proxy ARP 차단 설정 여부

cat << EOF >> "$result"
[양호]: Proxy ARP가 모두 차단된 경우
[취약]: Proxy ARP가 차단되지 않은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비에서 Proxy ARP 차단 설정 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 Proxy ARP 차단 설정 확인
    PROXY_ARP_STATUS=$(ssh $device "show proxy-arp status") # 실제 장비의 Proxy ARP 상태 확인 명령어로 변경 필요

    # Proxy ARP 차단 설정 확인
    if [[ "$PROXY_ARP_STATUS" == *"blocked"* || "$PROXY_ARP_STATUS" == *"disabled"* ]]; then
        OK "$device 에서 Proxy ARP가 차단되었습니다."
    else
        WARN "$device 에서 Proxy ARP가 차단되지 않았습니다."
    fi
done

cat "$result"

echo ; echo
