#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-041] 웹 서비스의 CGI 스크립트 관리 미흡

cat << EOF >> $result
[양호]: CGI 스크립트 관리가 적절하게 설정된 경우
[취약]: CGI 스크립트 관리가 미흡한 경우
EOF

BAR

# Apache 설정 파일 확인
APACHE_CONFIG_FILE="/etc/apache2/apache2.conf"

# CGI 스크립트 실행 및 관리 설정 확인
# 예: 'ExecCGI' 옵션 및 'AddHandler' 또는 'ScriptAlias' 지시어를 확인
cgi_exec_option=$(grep -E "^[ \t]*Options.*ExecCGI" "$APACHE_CONFIG_FILE")
cgi_handler_directive=$(grep -E "(AddHandler cgi-script|ScriptAlias)" "$APACHE_CONFIG_FILE")

if [ -n "$cgi_exec_option" ] || [ -n "$cgi_handler_directive" ]; then
    WARN "Apache에서 CGI 스크립트 실행이 허용되어 있습니다: $cgi_exec_option, $cgi_handler_directive"
else
    OK "Apache에서 CGI 스크립트 실행이 적절하게 제한되어 있습니다."
fi

cat $result

echo ; echo
