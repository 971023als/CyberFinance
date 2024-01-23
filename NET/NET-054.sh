#!/bin/bash

# 함수 라이브러리 포함
. function.sh

# 임시 로그 파일 생성
TMP1=$(mktemp)
> "$TMP1"

# 로그 시작과 끝 구분선
BAR

# 점검 코드
CODE [NET-054] 스위치 허브 보안강화

cat << EOF >> "$result"
[양호]: 스위치 허브 보안 설정이 적절하게 구성된 경우
[취약]: 스위치 허브 보안 설정이 적절하게 구성되지 않은 경우
EOF

BAR

# 점검할 네트워크 장비 목록
DEVICES=("Switch1" "Switch2" "Switch3") # 실제 장비 목록으로 교체 필요

# 각 스위치의 보안 설정 점검
for device in "${DEVICES[@]}"; do
    # 각 장비에 SSH 접속하여 보안 설정 확인
    # 예: 포트 보안, VLAN 설정, MAC 주소 필터링 등
    PORT_SECURITY=$(ssh $device "show port-security")
    VLAN_CONFIG=$(ssh $device "show vlan")
    MAC_FILTER=$(ssh $device "show mac address-table | include static")

    # 보안 설정이 제대로 되어 있는지 확인
    if [[ $PORT_SECURITY && $VLAN_CONFIG && $MAC_FILTER ]]; then
        OK "$device 에서 스위치 허브 보안 설정이 적절하게 구성되었습니다."
    else
        WARN "$device 에서 스위치 허브 보안 설정이 적절하게 구성되지 않았습니다."
    fi
done

cat "$result"

echo ; echo
