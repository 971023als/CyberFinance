#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-024] 불필요하게 'WITH GRANT OPTION' 옵션이 설정된 권한 확인

cat << EOF >> "$result"
[양호]: 'WITH GRANT OPTION'이 불필요하게 설정되지 않은 경우
[취약]: 'WITH GRANT OPTION'이 불필요하게 설정된 권한이 있는 경우
EOF

BAR

# Database credentials (prompt user for actual credentials)
read -p "Enter the database username: " DB_USER
read -sp "Enter the database password: " DB_PASS
echo

# Check for unnecessary WITH GRANT OPTION privileges
# The specific query will depend on the database system
# For example, for MySQL:
MYSQL_CMD="mysql -u $DB_USER -p$DB_PASS -Bse"
GRANT_OPTION_PRIVILEGES=$($MYSQL_CMD "SELECT GRANTEE, PRIVILEGE_TYPE FROM information_schema.user_privileges WHERE IS_GRANTABLE = 'YES';")

# Check if any unnecessary privileges are found
if [ -n "$GRANT_OPTION_PRIVILEGES" ]; then
    WARN "The following privileges are granted with WITH GRANT OPTION unnecessarily: $GRANT_OPTION_PRIVILEGES"
else
    OK "No unnecessary privileges are granted with WITH GRANT OPTION."
fi

cat "$result"

echo ; echo
