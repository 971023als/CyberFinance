import os

def BAR():
    print("=" * 40)

def log_message(message, file_path):
    with open(file_path, 'a') as f:
        f.write(message + "\n")

# 결과 파일 초기화
tmp1 = os.path.basename(__file__) + '.log'

with open(tmp1, 'w') as f:
    pass

BAR()

code = "[SRV-022] 계정의 비밀번호 미설정, 빈 암호 사용 관리 미흡"
log_message(code, tmp1)
log_message("[양호]: 모든 계정에 비밀번호가 설정되어 있고 빈 비밀번호를 사용하는 계정이 없는 경우", tmp1)
log_message("[취약]: 비밀번호가 설정되지 않거나 빈 비밀번호를 사용하는 계정이 있는 경우", tmp1)

BAR()

# /etc/shadow 파일을 확인하여 빈 비밀번호가 설정된 계정을 찾습니다.
empty_passwords = 0
try:
    with open("/etc/shadow", 'r') as shadow_file:
        for line in shadow_file:
            user, enc_passwd, *_ = line.split(":")
            if enc_passwd in ("", "!", "*"):
                message = f"WARN 비밀번호가 설정되지 않은 계정: {user}" if enc_passwd == "" else f"OK 비밀번호가 잠긴 계정: {user}"
                log_message(message, tmp1)
                if enc_passwd == "":
                    empty_passwords += 1
            else:
                log_message(f"OK 비밀번호가 설정된 계정: {user}", tmp1)
except FileNotFoundError:
    log_message("ERROR: /etc/shadow 파일을 찾을 수 없습니다.", tmp1)

# 비밀번호가 설정되지 않거나 빈 비밀번호를 사용하는 계정이 있는지 확인합니다.
result = "[결과] 취약: 비밀번호가 설정되지 않거나 빈 비밀번호를 사용하는 계정이 존재합니다." if empty_passwords > 0 else "[결과] 양호: 모든 계정에 비밀번호가 설정되어 있고 빈 비밀번호를 사용하는 계정이 없습니다."
log_message(result, tmp1)

BAR()

# 최종 결과를 출력합니다.
with open(tmp1, 'r') as f:
    print(f.read())
print()
