#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-164] 구성원이 존재하지 않는 GID 존재

cat << EOF >> $result
[양호]: 시스템에 구성원이 존재하지 않는 그룹(GID)가 존재하지 않는 경우
[취약]: 시스템에 구성원이 존재하지 않는 그룹(GID)이 존재하는 경우
EOF

BAR

# /etc/group 파일에서 GID와 연결된 사용자를 검사
while IFS=: read -r groupname _ gid _; do
    if ! grep -q ":${gid}:" /etc/passwd; then
        WARN "구성원이 없는 그룹 발견: $groupname (GID: $gid)"
    fi
done < /etc/group

OK "구성원이 없는 그룹이 존재하지 않습니다."

cat $result

echo ; echo
