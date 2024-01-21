#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-016] 불필요한 RPC서비스 활성화

cat << EOF >> $result
[양호]: RPC 서비스가 필요에 따라 비활성화되어 있는 경우
[취약]: RPC 서비스가 필요 없음에도 활성화되어 실행 중인 경우
EOF

BAR

# RPC 관련 서비스 목록
RPC_SERVICES=("rpcbind" "rpc.statd" "rpc.mountd")  # 이 서비스 목록은 시스템에 따라 다를 수 있습니다.

for service in "${RPC_SERVICES[@]}"; do
  if systemctl is-active --quiet $service; then
    WARN "$service 서비스가 활성화되어 실행 중입니다."
  else
    OK "$service 서비스가 비활성화되어 있거나 실행 중이지 않습니다."
  fi
done

cat $result

echo ; echo
