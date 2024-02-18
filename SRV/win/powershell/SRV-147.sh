#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-147] 불필요한 SNMP 서비스 실행

cat << EOF >> $TMP1
[양호]: SNMP 서비스가 비활성화되어 있는 경우
[취약]: SNMP 서비스가 활성화되어 있는 경우
EOF

BAR

if [ `ps -ef | grep -i 'snmp' | grep -v 'grep' | wc -l` -gt 0 ]; then
	WARN " SNMP 서비스를 사용하고 있습니다." >> $TMP1
	return 0
else
	OK "※ U-66 결과 : 양호(Good)" >> $TMP1
	return 0
fi

cat $TMP1

echo ; echo
