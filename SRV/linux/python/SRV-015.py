import subprocess
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

code = "[SRV-015] 불필요한 NFS 서비스 실행"
with open(tmp1, 'a') as f:
    f.write(f"{code}\n")
    f.write("[양호]: 불필요한 NFS 서비스 관련 데몬이 비활성화 되어 있는 경우\n")
    f.write("[취약]: 불필요한 NFS 서비스 관련 데몬이 활성화 되어 있는 경우\n")

BAR()

# NFS 서비스 관련 데몬 실행 여부 확인
ps_output = subprocess.getoutput("ps -ef | grep -iE 'nfs|rpc.statd|statd|rpc.lockd|lockd' | grep -ivE 'grep|kblockd|rstatd|'")
nfs_daemons = [line for line in ps_output.split('\n') if line]

if nfs_daemons:
    result = WARN(" 불필요한 NFS 서비스 관련 데몬이 실행 중입니다.")
else:
    result = OK("불필요한 NFS 서비스 관련 데몬이 비활성화")

with open(tmp1, 'a') as f:
    f.write(result + "\n")

BAR()

# 결과 출력
with open(tmp1, 'r') as f:
    print(f.read())
print()
