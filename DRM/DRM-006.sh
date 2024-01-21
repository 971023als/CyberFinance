#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-006] SMTP 서비스 로그 수준 설정 미흡

cat << EOF >> $result
[양호]: SMTP 서비스의 로그 수준이 적절하게 설정되어 있는 경우
[취약]: SMTP 서비스의 로그 수준이 낮거나, 로그가 충분히 수집되지 않는 경우
EOF

BAR

# Postfix의 경우 master.cf 및 main.cf 파일을 검사합니다.
POSTFIX_CONFIG_FILES=("/etc/postfix/main.cf" "/etc/postfix/master.cf")
LOGGING_SETTING="log_level"

# SMTP 서비스의 로그 설정을 확인합니다.
for config_file in "${POSTFIX_CONFIG_FILES[@]}"; do
  if [ -f "$config_file" ]; then
    if grep -q "$LOGGING_SETTING" "$config_file"; then
      OK "SMTP 서비스의 로그 수준이 '$config_file' 파일에 설정되어 있습니다."
    else
      WARN "SMTP 서비스의 로그 수준이 '$config_file' 파일에 설정되어 있지 않습니다."
    fi
  else
    INFO "'$config_file' 파일을 찾을 수 없습니다."
  fi
done

cat $result

echo ; echo
