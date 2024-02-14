import os
import re
import subprocess

def BAR():
    print("=" * 40)

def WARN(message):
    return "WARNING:" + message

def OK(message):
    return "OK:" + message

# 파일 이름 설정
tmp1 = os.path.basename(__file__) + '.log'

# 로그 파일 초기화
with open(tmp1, 'w') as f:
    pass

BAR()

code = "[SRV-009] SMTP 서비스 스팸 메일 릴레이 제한 미설정"
with open(tmp1, 'a') as f:
    f.write(f"{code}\n")
    f.write("[양호]: SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있는 경우\n")
    f.write("[취약]: SMTP 서비스를 사용하거나 릴레이 제한이 설정이 없는 경우\n")

BAR()

if os.path.isfile('/etc/services'):
    smtp_ports = [line.split()[1].split('/')[0] for line in open('/etc/services') if 'smtp' in line.lower() and 'tcp' in line]
    if smtp_ports:
        for port in smtp_ports:
            netstat_output = subprocess.getoutput(f"netstat -nat | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ':{port} '")
            if netstat_output:
                sendmailcf_files = subprocess.getoutput("find / -name 'sendmail.cf' -type f 2>/dev/null").split('\n')
                if sendmailcf_files:
                    for file in sendmailcf_files:
                        with open(file, 'r') as f:
                            content = f.read()
                            if not re.search(r'^#|^\s#', content, re.MULTILINE) and 'R$*' in content and 'Relaying denied' in content:
                                with open(tmp1, 'a') as log_file:
                                    log_file.write(WARN(f" {file} 파일에 릴레이 제한이 설정되어 있지 않습니다.\n"))
                                    break

smtp_process_count = subprocess.getoutput("ps -ef | grep -iE 'smtp|sendmail' | grep -v 'grep'").count('\n')
if smtp_process_count > 0:
    sendmailcf_files = subprocess.getoutput("find / -name 'sendmail.cf' -type f 2>/dev/null").split('\n')
    if sendmailcf_files:
        for file in sendmailcf_files:
            with open(file, 'r') as f:
                content = f.read()
                if not re.search(r'^#|^\s#', content, re.MULTILINE) and 'R$*' in content and 'Relaying denied' in content:
                    with open(tmp1, 'a') as log_file:
                        log_file.write(WARN(f" {file} 파일에 릴레이 제한이 설정되어 있지 않습니다.\n"))
                        break
else:
    with open(tmp1, 'a') as log_file:
        log_file.write(OK("SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정\n"))

# 결과 출력
with open(tmp1, 'r') as f:
    print(f.read())
