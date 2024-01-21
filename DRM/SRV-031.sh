#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-031] 계정 목록 및 네트워크 공유 이름 노출

cat << EOF >> $result
[양호]: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 노출되지 않는 경우
[취약]: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 노출되는 경우
EOF

BAR

# SMB 설정 파일을 확인합니다.
SMB_CONF_FILE="/etc/samba/smb.conf"

# 공유 목록 및 계정 정보 노출을 방지하는 설정을 확인합니다.
# 예: 'enum shares', 'enum users' 설정을 확인
if grep -E "(enum shares|enum users)" "$SMB_CONF_FILE"; then
    WARN "SMB 서비스에서 계정 목록 또는 네트워크 공유 이름이 노출될 수 있습니다."
else
    OK "SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 적절하게 보호되고 있습니다."
fi

cat $result

echo ; echo
