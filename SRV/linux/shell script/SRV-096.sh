#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-096] 사용자 환경파일의 소유자 또는 권한 설정 미흡

cat << EOF >> $result
[양호]: 사용자 환경 파일의 소유자가 해당 사용자이고, 권한이 적절하게 설정된 경우
[취약]: 사용자 환경 파일의 소유자가 해당 사용자가 아니거나, 권한이 부적절하게 설정된 경우
EOF

BAR

# 사용자 홈 디렉터리 및 환경 파일 목록
home_dirs=$(awk -F: '{print $6}' /etc/passwd)
env_files=(".bashrc" ".profile")

# 각 사용자 홈 디렉터리 및 환경 파일을 확인
for dir in $home_dirs; do
  for file in "${env_files[@]}"; do
    if [ -f "$dir/$file" ]; then
      owner=$(stat -c '%U' "$dir/$file")
      permission=$(stat -c '%a' "$dir/$file")

      if [ "$owner" != "$(basename $dir)" ]; then
        WARN "$file 파일의 소유자가 $owner로 설정되어 있습니다 (예상: $(basename $dir))"
      fi

      if [ "$permission" -gt 644 ]; then
        WARN "$file 파일의 권한이 $permission로 설정되어 있습니다 (예상: 644 이하)"
      else
        OK "$file 파일의 권한이 적절하게 설정되어 있습니다."
      fi
    else
      INFO "$file 파일이 $dir에 존재하지 않습니다."
    fi
  done
done

cat $result

echo ; echo
