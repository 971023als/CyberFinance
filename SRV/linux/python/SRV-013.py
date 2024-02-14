import os
import subprocess

def BAR():
    print("=" * 40)

def WARN(message):
    return "WARNING: " + message

def OK(message):
    return "OK: " + message

# 결과 파일 초기화
tmp1 = os.path.basename(__file__) + '.log'
with open(tmp1, 'w') as f:
    pass

BAR()

code = "[SRV-013] Anonymous 계정의 FTP 서비스 접속 제한 미비"
with open(tmp1, 'a') as f:
    f.write(f"{code}\n")
    f.write("[양호]: Anonymous FTP (익명 ftp) 접속을 차단한 경우\n")
    f.write("[취약]: Anonymous FTP (익명 ftp) 접속을 차단하지 않는 경우\n")

BAR()

# /etc/passwd에서 ftp 또는 anonymous 계정 확인
if os.path.isfile("/etc/passwd"):
    with open("/etc/passwd", 'r') as passwd_file:
        users = passwd_file.read()
        if "ftp" in users or "anonymous" in users:
            file_exists_count = 0
            proftpd_conf_files = subprocess.getoutput("find / -name 'proftpd.conf' -type f 2>/dev/null").split('\n')
            vsftpd_conf_files = subprocess.getoutput("find / -name 'vsftpd.conf' -type f 2>/dev/null").split('\n')
            
            # ProFTPD 설정 파일 검사
            for file in proftpd_conf_files:
                if file:
                    file_exists_count += 1
                    with open(file, 'r') as f:
                        content = f.read()
                        if '<Anonymous' in content and '</Anonymous>' in content:
                            result = WARN(f"{file} 파일에서 'User' 또는 'UserAlias' 옵션이 삭제 또는 주석 처리되어 있지 않습니다.")
                            break
            
            # vsFTPd 설정 파일 검사
            settings_in_vsftpdconf = 0
            for file in vsftpd_conf_files:
                if file:
                    file_exists_count += 1
                    with open(file, 'r') as f:
                        content = f.read()
                        if 'anonymous_enable' in content:
                            settings_in_vsftpdconf += 1
                            if 'anonymous_enable=YES' in content.upper():
                                result = WARN(f"{file} 파일에서 익명 ftp 접속을 허용하고 있습니다.")
                                break
            
            if settings_in_vsftpdconf == 0 and vsftpd_conf_files[0]:
                result = WARN("vsftpd.conf 파일에 익명 ftp 접속을 설정하는 옵션이 없습니다.")
            elif file_exists_count == 0:
                result = WARN("익명 ftp 접속을 설정하는 파일이 없습니다.")
        else:
            result = OK("Anonymous FTP (익명 ftp) 접속을 차단")
else:
    result = WARN("/etc/passwd 파일이 존재하지 않습니다.")

with open(tmp1, 'a') as f:
    f.write(result + "\n")

BAR()

# 결과 출력
with open(tmp1, 'r') as f:
    print(f.read())
print()
