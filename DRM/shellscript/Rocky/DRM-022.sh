#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-022] 데이터베이스 설정 파일의 접근 권한 설정 확인

cat << EOF >> "$result"
[양호]: MySQL, Oracle, PostgreSQL 설정 파일의 접근 권한이 적절한 경우
[취약]: 설정 파일의 접근 권한이 미흡한 경우
EOF

BAR

# Define the list of critical files for MySQL, Oracle, and PostgreSQL
FILES_TO_CHECK=("/etc/mysql/my.cnf" "/u01/app/oracle/product/11.2.0/dbhome_1/network/admin/listener.ora" "/var/lib/pgsql/data/postgresql.conf")

# Check permissions for each file
for file in "${FILES_TO_CHECK[@]}"; do
    if [ -e "$file" ]; then
        PERMS=$(stat -c '%a' "$file")
        if [ "$PERMS" -gt "600" ]; then # Replace 600 with the desired permission level
            WARN "File $file has insecure permissions: $PERMS"
        else
            OK "File $file has secure permissions: $PERMS"
        fi
    else
        WARN "File $file does not exist"
    fi
done

cat "$result"

echo ; echo
