#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-172] 불필요한 시스템 자원 공유 존재

cat << EOF >> $result
[양호]: 불필요한 시스템 자원이 공유되지 않는 경우
[취약]: 불필요한 시스템 자원이 공유되는 경우
EOF

BAR

# NFS 공유 확인
nfs_shares=$(showmount -e localhost)
if [ -z "$nfs_shares" ]; then
    OK "NFS에서 불필요한 공유가 존재하지 않습니다."
else
    WARN "NFS에서 다음 공유가 발견되었습니다: $nfs_shares"
fi

# Samba 공유 확인
samba_shares=$(smbstatus -S)
if [ -z "$samba_shares" ]; then
    OK "Samba에서 불필요한 공유가 존재하지 않습니다."
else
    WARN "Samba에서 다음 공유가 발견되었습니다: $samba_shares"
fi

cat $result

echo ; echo
