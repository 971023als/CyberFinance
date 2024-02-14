import os
import stat

def BAR():
    print("=" * 40)

def WARN(message):
    return f"WARNING: {message}\n"

def OK(message):
    return f"OK: {message}\n"

# 결과 파일 초기화
tmp1 = "SCRIPTNAME.log"  # 'SCRIPTNAME'을 실제 스크립트 이름으로 바꿔주세요.
with open(tmp1, 'w') as f:
    pass

BAR()

code = "[SRV-021] FTP 서비스 접근 제어 설정 미비"
with open(tmp1, 'a') as f:
    f.write(f"{code}\n")
    f.write("[양호]: ftpusers 파일의 소유자가 root이고, 권한이 640 이하인 경우\n")
    f.write("[취약]: ftpusers 파일의 소유자가 root가 아니고, 권한이 640 이상인 경우\n")

BAR()

# FTP 서비스 구성 파일에서 익명 사용자 접속을 확인합니다.
file_exists_count = 0
ftpusers_files = ["/etc/ftpusers", "/etc/pure-ftpd/ftpusers", "/etc/wu-ftpd/ftpusers", "/etc/vsftpd/ftpusers", "/etc/proftpd/ftpusers", "/etc/ftpd/ftpusers", "/etc/vsftpd.ftpusers", "/etc/vsftpd.user_list", "/etc/vsftpd/user_list"]

for file_path in ftpusers_files:
    if os.path.isfile(file_path):
        file_exists_count += 1
        file_stat = os.stat(file_path)
        mode = file_stat.st_mode
        owner = file_stat.st_uid

        # Check owner is root
        if owner == 0:
            # Check permission is 640 or less
            permission = oct(mode)[-3:]
            if int(permission, 8) <= 0o640:
                if (mode & stat.S_IROTH) or (mode & stat.S_IWOTH):
                    result = WARN(f"{file_path} 파일의 다른 사용자(other)에 대한 권한이 취약합니다.")
                else:
                    result = OK(f"ftpusers 파일의 설정이 양호합니다: {file_path}")
            else:
                result = WARN(f"{file_path} 파일의 권한이 640보다 큽니다.")
        else:
            result = WARN(f"{file_path} 파일의 소유자(owner)가 root가 아닙니다.")

        with open(tmp1, 'a') as f:
            f.write(result)
    else:
        continue

if file_exists_count == 0:
    result = WARN("ftp 접근제어 파일이 없습니다.")
else:
    result = OK("※ U-63 결과 : 양호(Good)")

with open(tmp1, 'a') as f:
    f.write(result)

BAR()

# 결과 출력
with open(tmp1, 'r') as f:
    print(f.read())
print()
