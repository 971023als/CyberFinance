import os

def BAR():
    print("=" * 40)

# 결과 파일 초기화
tmp1 = os.path.basename(__file__) + '.log'

# 로그 파일 초기화
with open(tmp1, 'w') as f:
    pass

BAR()

code = "[SRV-011] 시스템 관리자 계정의 FTP 사용 제한 미비"
with open(tmp1, 'a') as f:
    f.write(f"{code}\n")
    f.write("[양호]: FTP 서비스에서 시스템 관리자 계정의 접근이 제한되는 경우\n")
    f.write("[취약]: FTP 서비스에서 시스템 관리자 계정의 접근이 제한되지 않는 경우\n")

BAR()

# FTP 사용자 제한 설정 파일 경로
ftp_users_file = "/etc/vsftpd/ftpusers"

# 'root' 계정의 FTP 접근 제한 여부 확인
if os.path.isfile(ftp_users_file):
    with open(ftp_users_file, 'r') as file:
        if "root" in file.read():
            result = "OK: FTP 서비스에서 root 계정의 접근이 제한됩니다."
        else:
            result = "WARN: FTP 서비스에서 root 계정의 접근이 제한되지 않습니다."
else:
    result = "WARN: FTP 사용자 제한 설정 파일({})이 존재하지 않습니다.".format(ftp_users_file)

with open(tmp1, 'a') as f:
    f.write(result + "\n")

# 결과 출력
with open(tmp1, 'r') as f:
    print(f.read())
print()
