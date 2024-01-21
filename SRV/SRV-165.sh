#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-165] 불필요하게 Shell이 부여된 계정 존재

cat << EOF >> $result
[양호]: 불필요하게 Shell이 부여된 계정이 존재하지 않는 경우
[취약]: 불필요하게 Shell이 부여된 계정이 존재하는 경우
EOF

BAR

# /etc/passwd 파일에서 Shell이 부여된 계정을 검사
while IFS=: read -r username _ _ _ _ _ shell; do
    if [ "$shell" != "/bin/nologin" ] && [ "$shell" != "/bin/false" ]; then
        WARN "Shell이 부여된 계정 발견: $username (Shell: $shell)"
    fi
done < /etc/passwd

OK "불필요하게 Shell이 부여된 계정이 존재하지 않습니다."

cat $result

echo ; echo
