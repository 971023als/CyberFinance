import subprocess
import os

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

code = "[SRV-024] 취약한 Telnet 인증 방식 사용"
log_message = f"{code}\n[양호]: Telnet 서비스가 비활성화되어 있거나 보안 인증 방식을 사용하는 경우\n[취약]: Telnet 서비스가 활성화되어 있고 보안 인증 방식을 사용하지 않는 경우\n"
with open(tmp1, 'a') as f:
    f.write(log_message)

BAR()

# Telnet 서비스 상태를 확인합니다.
try:
    # systemctl is-active 명령어를 사용하여 telnet.socket의 상태를 확인합니다.
    subprocess.check_output(["systemctl", "is-active", "--quiet", "telnet.socket"])
    result = WARN("Telnet 서비스가 활성화되어 있습니다. 추가 보안 설정 확인이 필요할 수 있습니다.")
except subprocess.CalledProcessError:
    # systemctl is-active가 non-zero exit status를 반환할 경우, 서비스가 비활성화되었다고 가정합니다.
    result = OK("Telnet 서비스가 비활성화되어 있습니다.")

with open(tmp1, 'a') as f:
    f.write(result)

BAR()

# 최종 결과를 출력합니다.
with open(tmp1, 'r') as f:
    print(f.read())
print()
