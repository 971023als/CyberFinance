#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-123] 최종 로그인 사용자 계정 노출

cat << EOF >> $result
[양호]: 최종 로그인 사용자 정보가 노출되지 않는 경우
[취약]: 최종 로그인 사용자 정보가 노출되는 경우
EOF

BAR

# 로그인 메시지 파일 확인
files=("/etc/motd" "/etc/issue" "/etc/issue.net")

for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    if grep -q 'Last login' "$file"; then
      WARN "파일 $file 에 최종 로그인 사용자 정보가 포함되어 있습니다."
    else
      OK "파일 $file 에 최종 로그인 사용자 정보가 포함되지 않았습니다."
    fi
  else
    INFO "파일 $file 이(가) 존재하지 않습니다."
  fi
done

cat $result

echo ; echo
