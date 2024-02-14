import os
import stat
import pwd

def BAR():
    print("=" * 40)

def WARN(message):
    return f"WARNING: {message}\n"

def OK(message):
    return f"OK: {message}\n"

def INFO(message):
    return f"INFO: {message}\n"

# 결과 파일 초기화
tmp1 = "SCRIPTNAME.log"  # 'SCRIPTNAME'을 실제 스크립트 이름으로 바꿔주세요.
with open(tmp1, 'w') as f:
    pass

BAR()

code = "[SRV-025] 취약한 hosts.equiv 또는 .rhosts 설정 존재"
log_message = f"{code}\n[양호]: hosts.equiv 및 .rhosts 파일이 없거나, 안전하게 구성된 경우\n[취약]: hosts.equiv 또는 .rhosts 파일에 취약한 설정이 있는 경우\n"
with open(tmp1, 'a') as f:
    f.write(log_message)

BAR()

# hosts.equiv 및 .rhosts 파일의 존재 및 내용을 확인합니다.
host_files = ["/etc/hosts.equiv"]
user_dirs = [user.pw_dir for user in pwd.getpwall() if user.pw_shell not in ("/bin/false", "/sbin/nologin") and os.path.isdir(user.pw_dir)]
user_dirs += [os.path.join("/home", d) for d in os.listdir("/home") if os.path.isdir(os.path.join("/home", d))]

for user_dir in user_dirs:
    host_files.append(os.path.join(user_dir, ".rhosts"))

for host_file in host_files:
    if os.path.isfile(host_file):
        file_stat = os.stat(host_file)
        if (file_stat.st_uid == 0 and oct(file_stat.st_mode)[-3:] in ('600', '400')) or \
                (file_stat.st_uid != 0 and oct(file_stat.st_mode)[-3:] == '000'):
            if '+' in open(host_file).read():
                result = WARN(f"{host_file} 파일에 '+' 설정이 있습니다.")
            else:
                result = OK(f"{host_file} 파일이 안전하게 구성되어 있습니다.")
        else:
            result = WARN(f"{host_file} 파일의 권한이 취약합니다.")
    else:
        result = INFO(f"{host_file} 파일이 존재하지 않습니다.")
    with open(tmp1, 'a') as f:
        f.write(result)

BAR()

# 최종 결과를 출력합니다.
with open(tmp1, 'r') as f:
    print(f.read())
print()
