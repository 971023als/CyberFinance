#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-032] 데이터베이스 접속 시 통신구간에 비밀번호 평문 노출

cat << EOF >> "$result"
[양호]: 데이터베이스 접속 시 비밀번호가 암호화되어 전송되는 경우
[취약]: 데이터베이스 접속 시 비밀번호가 평문으로 노출되는 경우
EOF

BAR

# 데이터베이스 연결 설정 확인
DB_CONNECTION_CMD="your_database_connection_check_command"

# SSL/TLS 설정 확인
SECURE_CONNECTION=$($DB_CONNECTION_CMD -e "SHOW SSL/TLS SETTINGS;")

# 연결 보안 설정 검사
if [[ "$SECURE_CONNECTION" =~ "SSL ENABLED" || "$SECURE_CONNECTION" =~ "TLS ENABLED" ]]; then
    OK "데이터베이스 접속 시 비밀번호가 안전하게 암호화되어 전송됩니다."
else
    WARN "데이터베이스 접속 시 비밀번호가 평문으로 노출될 위험이 있습니다."
fi

cat "$result"

echo ; echo
