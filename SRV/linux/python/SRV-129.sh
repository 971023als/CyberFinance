#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-129] 백신 프로그램 미설치

cat << EOF >> $result
[양호]: 백신 프로그램이 설치되어 있는 경우
[취약]: 백신 프로그램이 설치되어 있지 않은 경우
EOF

BAR

# 일반적으로 사용되는 백신 프로그램의 설치 여부를 확인합니다
antivirus_programs=("clamav" "avast" "avg" "avira" "eset")

installed_antivirus=()

for antivirus in "${antivirus_programs[@]}"; do
  if command -v $antivirus &> /dev/null; then
    installed_antivirus+=("$antivirus")
  fi
done

# 설치된 백신 프로그램이 있는지 확인합니다
if [ ${#installed_antivirus[@]} -eq 0 ]; then
  WARN "설치된 백신 프로그램이 없습니다."
else
  OK "설치된 백신 프로그램: ${installed_antivirus[*]}"
fi

cat $result

echo ; echo
