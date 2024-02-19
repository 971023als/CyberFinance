#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-150] 로컬 로그온 허용

cat << EOF >> $result
[양호]: 웹 서버에서 버전 정보 및 운영체제 정보 노출이 제한된 경우
[취약]: 웹 서버에서 버전 정보 및 운영체제 정보가 노출되는 경우
EOF

BAR


cat $result

echo ; echo
