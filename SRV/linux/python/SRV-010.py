import os
import subprocess

def BAR():
    print("=" * 40)

# 결과 파일 정의
tmp1 = os.path.basename(__file__) + '.log'

# 로그 파일 초기화
with open(tmp1, 'w') as f:
    pass

BAR()

code = "[SRV-010] SMTP 서비스의 메일 queue 처리 권한 설정 미흡"
with open(tmp1, 'a') as f:
    f.write(f"{code}\n")
    f.write("[양호]: SMTP 서비스의 메일 queue 처리 권한을 업무 관리자에게만 부여되도록 설정한 경우\n")
    f.write("[취약]: SMTP 서비스의 메일 queue 처리 권한이 업무와 무관한 일반 사용자에게도 부여되도록 설정된 경우\n")

BAR()

# Sendmail 설정 점검
sendmail_cf = "/etc/mail/sendmail.cf"
try:
    with open(sendmail_cf, 'r') as file:
        content = file.read()
        if "O PrivacyOptions=.*restrictqrun" in content:
            result = "OK: Sendmail의 PrivacyOptions에 restrictqrun 설정이 적용되어 있습니다."
        else:
            result = "WARN: Sendmail의 PrivacyOptions에 restrictqrun 설정이 누락되었습니다."
except FileNotFoundError:
    result = "INFO: Sendmail 설정 파일이 존재하지 않습니다."

with open(tmp1, 'a') as f:
    f.write(result + "\n")

# Postfix 메일 queue 디렉터리 권한 확인
postsuper = "/usr/sbin/postsuper"
if os.path.exists(postsuper) and os.access(postsuper, os.X_OK):
    # others 권한 점검
    perm = oct(os.stat(postsuper).st_mode)[-3:]
    if perm == "750":
        result = "OK: Postfix의 postsuper 실행 파일이 others에 대해 실행 권한이 없습니다."
    else:
        result = "WARN: Postfix의 postsuper 실행 파일이 others에 대해 과도한 권한을 부여하고 있습니다."
else:
    result = "INFO: Postfix postsuper 실행 파일이 존재하지 않습니다."

with open(tmp1, 'a') as f:
    f.write(result + "\n")

# 결과 출력
with open(tmp1, 'r') as f:
    print(f.read())
print()
