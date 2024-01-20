#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-015] 불필요한 NFS 서비스 실행

cat << EOF >> $result
[양호]: NFS 서비스가 비활성화되어 있거나 필요에 따라 실행되고 있는 경우
[취약]: NFS 서비스가 필요 없음에도 활성화되어 실행 중인 경우
EOF

BAR

# NFS 서비스 상태를 확인합니다.
NFS_SERVICES=("nfs-server" "nfsd" "rpcbind")  # NFS 관련 서비스 이름은 배포판에 따라 다를 수 있습니다.

for service in "${NFS_SERVICES[@]}"; do
  if systemctl is-active --quiet $service; then
    WARN "$service 서비스가 활성화되어 실행 중입니다."
  else
    OK "$service 서비스가 비활성화되어 있거나 실행 중이지 않습니다."
  fi
done

cat $result

echo ; echo
