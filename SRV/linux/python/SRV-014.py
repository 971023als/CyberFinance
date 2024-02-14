import subprocess

def BAR():
    print("=" * 40)

def WARN(message):
    return "WARNING: " + message

def INFO(message):
    return "INFO: " + message

def OK(message):
    return "OK: " + message

# 결과 파일 초기화
tmp1 = "SCRIPTNAME.log"  # SCRIPTNAME을 적절한 스크립트 이름으로 바꿔주세요.
with open(tmp1, 'w') as f:
    pass

BAR()

code = "[SRV-014] NFS 접근통제 미비"
with open(tmp1, 'a') as f:
    f.write(f"{code}\n")
    f.write("[양호]: 불필요한 NFS 서비스를 사용하지 않거나, 불가피하게 사용 시 everyone 공유를 제한한 경우\n")
    f.write("[취약]: 불필요한 NFS 서비스를 사용하거나, 불가피하게 사용 시 everyone 공유를 제한하지 않는 경우\n")

BAR()

# NFS 설정 파일을 확인합니다.
ps_output = subprocess.getoutput("ps -ef | grep -iE 'nfs|rpc.statd|statd|rpc.lockd|lockd' | grep -ivE 'grep|kblockd|rstatd|'")
nfs_processes = [line for line in ps_output.split('\n') if line]

if nfs_processes:
    if os.path.isfile("/etc/exports"):
        with open("/etc/exports", 'r') as file:
            exports_content = file.readlines()
            etc_exports_all_count = sum(1 for line in exports_content if '/' in line and '*' in line and not line.startswith('#'))
            etc_exports_insecure_count = sum(1 for line in exports_content if 'insecure' in line.lower() and not line.startswith('#'))
            etc_exports_directory_count = sum(1 for line in exports_content if '/' in line and not line.startswith('#'))
            etc_exports_squash_count = sum(1 for line in exports_content if 'root_squash' in line.lower() or 'all_squash' in line.lower() and not line.startswith('#'))

            result = ""
            if etc_exports_all_count > 0:
                result = WARN("/etc/exports 파일에 '*' 설정이 있습니다. ") + "\n" + INFO("설정 = 모든 클라이언트에 대해 전체 네트워크 공유 허용") + "\n"
            elif etc_exports_insecure_count > 0:
                result = WARN(" /etc/exports 파일에 'insecure' 옵션이 설정되어 있습니다.") + "\n"
            elif etc_exports_directory_count != etc_exports_squash_count:
                result = WARN(" /etc/exports 파일에 'root_squash' 또는 'all_squash' 옵션이 설정되어 있지 않습니다.") + "\n"
            
            if result:
                with open(tmp1, 'a') as f:
                    f.write(result)
else:
    with open(tmp1, 'a') as f:
        f.write(OK("불필요한 NFS 서비스를 사용하지 않거나, 불가피하게 사용 시 everyone 공유를 제한") + "\n")

BAR()

# 결과 출력
with open(tmp1, 'r') as f:
    print(f.read())
print()
