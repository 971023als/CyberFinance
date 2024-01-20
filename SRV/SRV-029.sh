#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-029] SMB 세션 중단 관리 설정 미비

cat << EOF >> $result
[양호]: SMB 서비스의 세션 중단 시간이 적절하게 설정된 경우
[취약]: SMB 서비스의 세션 중단 시간 설정이 미비한 경우
EOF

BAR

# SMB 설정 파일을 확인합니다.
SMB_CONF_FILE="/etc/samba/smb.conf"

# SMB 세션 중단 시간 설정을 확인합니다.
# 여기서는 'deadtime' 설정을 예로 듭니다.
if grep -q "^deadtime" "$SMB_CONF_FILE"; then
    deadtime=$(grep "^deadtime" "$SMB_CONF_FILE" | awk '{print $NF}')
    if [ "$deadtime" -gt 0 ]; then
        OK "SMB 세션 중단 시간(deadtime)이 적절하게 설정되어 있습니다: $deadtime 분"
    else
        WARN "SMB 세션 중단 시간(deadtime) 설정이 미비합니다."
    fi
else
    WARN "SMB 세션 중단 시간(deadtime) 설정이 '$SMB_CONF_FILE' 파일에 존재하지 않습니다."
fi

cat $result

echo ; echo
