import os

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

code = "[SRV-016] 불필요한 RPC서비스 활성화"
with open(tmp1, 'a') as f:
    f.write(f"{code}\n")
    f.write("[양호]: 불필요한 RPC 서비스가 비활성화 되어 있는 경우\n")
    f.write("[취약]: 불필요한 RPC 서비스가 활성화 되어 있는 경우\n")

BAR()

# RPC 관련 서비스 목록
rpc_services = ["rpc.cmsd", "rpc.ttdbserverd", "sadmind", "rusersd", "walld", "sprayd", "rstatd", "rpc.nisd", "rexd", "rpc.pcnfsd", "rpc.statd", "rpc.ypupdated", "rpc.rquotad", "kcms_server", "cachefsd"]

# /etc/xinetd.d 디렉터리에서 RPC 서비스 검사
if os.path.isdir("/etc/xinetd.d"):
    for service in rpc_services:
        service_file = f"/etc/xinetd.d/{service}"
        if os.path.isfile(service_file):
            with open(service_file, 'r') as f:
                content = f.read()
                if 'disable' in content and 'yes' not in content.lower():
                    result = WARN(" 불필요한 RPC 서비스가 /etc/xinetd.d 디렉터리 내 서비스 파일에서 실행 중입니다.")
                    break
    else:
        result = OK("불필요한 RPC 서비스가 비활성화 되어 있는 경우")
else:
    result = OK("불필요한 RPC 서비스가 비활성화 되어 있는 경우")

# /etc/inetd.conf 파일에서 RPC 서비스 검사
if os.path.isfile("/etc/inetd.conf"):
    with open("/etc/inetd.conf", 'r') as f:
        content = f.read()
        for service in rpc_services:
            if service in content:
                result = WARN(" 불필요한 RPC 서비스가 /etc/inetd.conf 파일에서 실행 중입니다.")
                break
        else:
            result = OK("불필요한 RPC 서비스가 비활성화 되어 있는 경우")

with open(tmp1, 'a') as f:
    f.write(result + "\n")

BAR()

# 결과 출력
with open(tmp1, 'r') as f:
    print(f.read())
print()
