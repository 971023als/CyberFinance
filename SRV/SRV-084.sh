#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-084] 시스템 주요 파일 권한 설정 미흡

cat << EOF >> $result
[양호]: 시스템 주요 파일의 권한이 적절하게 설정된 경우
[취약]: 시스템 주요 파일의 권한이 적절하게 설정되지 않은 경우
EOF

BAR

# 주요 시스템 파일 목록
KEY_FILES=("/etc/passwd" "/etc/shadow" "/etc/group" "/etc/gshadow" "/etc/ssh/sshd_config")

# 각 파일의 권한 확인
for file in "${KEY_FILES[@]}"; do
  if [ -f "$file" ]; then
    permissions=$(stat -c "%a" "$file")
    # 일반적으로 권장되는 권한 설정 확인
    case "$file" in
      "/etc/passwd")
        [ "$permissions" -eq "644" ] && OK "$file 권한이 적절합니다 (644)" || WARN "$file 권한이 적절하지 않습니다 (현재: $permissions)"
        ;;
      "/etc/shadow" | "/etc/gshadow")
        [ "$permissions" -eq "000" ] && OK "$file 권한이 적절합니다 (000)" || WARN "$file 권한이 적절하지 않습니다 (현재: $permissions)"
        ;;
      "/etc/group")
        [ "$permissions" -eq "644" ] && OK "$file 권한이 적절합니다 (644)" || WARN "$file 권한이 적절하지 않습니다 (현재: $permissions)"
        ;;
      "/etc/ssh/sshd_config")
        [ "$permissions" -eq "600" ] && OK "$file 권한이 적절합니다 (600)" || WARN "$file 권한이 적절하지 않습니다 (현재: $permissions)"
        ;;
      *)
        WARN "$file는 확인 대상 목록에 없습니다"
        ;;
    esac
  else
    WARN "$file 파일이 존재하지 않습니다"
  fi
done

cat $result

echo ; echo
