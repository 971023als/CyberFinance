#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-138] 백업 및 복구 권한 설정 미흡

cat << EOF >> $result
[양호]: 백업 및 복구 권한이 적절히 설정된 경우
[취약]: 백업 및 복구 권한이 적절히 설정되지 않은 경우
EOF

BAR

# 백업 관련 디렉토리 및 파일 권한 확인
backup_dirs=("/path/to/backup/dir1" "/path/to/backup/dir2") # 백업 디렉토리 예시

for dir in "${backup_dirs[@]}"; do
  if [ -d "$dir" ]; then
    permissions=$(stat -c %a "$dir")
    owner=$(stat -c %U "$dir")
    # 백업 디렉토리 소유자 및 권한 확인
    if [[ "$owner" == "backup_user" && "$permissions" -le 700 ]]; then
      OK "$dir 은 적절한 권한($permissions) 및 소유자($owner)를 가집니다."
    else
      WARN "$dir 은 부적절한 권한($permissions) 또는 소유자($owner)를 가집니다."
    fi
  else
    INFO "$dir 디렉토리가 존재하지 않습니다."
  fi
done

cat $result

echo ; echo
