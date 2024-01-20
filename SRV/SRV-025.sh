#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-025] 취약한 hosts.equiv 또는 .rhosts 설정 존재

cat << EOF >> $result
[양호]: hosts.equiv 및 .rhosts 파일이 없거나, 안전하게 구성된 경우
[취약]: hosts.equiv 또는 .rhosts 파일에 취약한 설정이 있는 경우
EOF

BAR

# hosts.equiv 및 .rhosts 파일의 존재 및 내용을 확인합니다.
HOSTS_EQUIV="/etc/hosts.equiv"
RHOSTS="/root/.rhosts"

check_file() {
  file=$1
  if [ -f "$file" ]; then
    if grep -qE '^\+' "$file"; then
      WARN "$file 파일에 취약한 설정이 존재합니다 ('+' 항목 발견)."
    else
      OK "$file 파일에 안전한 설정이 존재합니다."
    fi
  else
    OK "$file 파일이 존재하지 않습니다."
  fi
}

check_file "$HOSTS_EQUIV"
check_file "$RHOSTS"

cat $result

echo ; echo
