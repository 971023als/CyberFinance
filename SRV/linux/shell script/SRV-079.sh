#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-079] 익명 사용자에게 부적절한 권한(Everyone) 적용

cat << EOF >> $TMP1
[양호]: 익명 사용자에게 부적절한 권한이 적용되지 않은 경우
[취약]: 익명 사용자에게 부적절한 권한이 적용된 경우
EOF

BAR

if [ `find / -type f -perm -2 2>/dev/null | wc -l` -gt 0 ]; then
		WARN " world writable 설정이 되어있는 파일이 있습니다." >> $TMP1
		return 0
else
		OK "※ U-15 결과 : 양호(Good)" >> $TMP1
		return 0
fi

cat $TMP1

echo ; echo
