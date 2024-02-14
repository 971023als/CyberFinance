import subprocess
import os

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

code = "[SRV-020] 공유에 대한 접근 통제 미비"
with open(tmp1, 'a') as f:
    f.write(f"{code}\n")
    f.write("[양호]: NFS 또는 SMB/CIFS 공유에 대한 접근 통제가 적절하게 설정된 경우\n")
    f.write("[취약]: NFS 또는 SMB/CIFS 공유에 대한 접근 통제가 미비한 경우\n")

BAR()

# NFS와 SMB/CIFS 설정 파일을 확인합니다.
NFS_EXPORTS_FILE = "/etc/exports"
SMB_CONF_FILE = "/etc/samba/smb.conf"

def check_access_control(file, service_name):
    if os.path.isfile(file):
        with open(file, 'r') as f:
            content = f.read()
            if "everyone" in content or "public" in content:
                return WARN(f"{service_name} 서비스에서 느슨한 공유 접근 통제가 발견됨: {file}")
            else:
                return OK(f"{service_name} 서비스에서 공유 접근 통제가 적절함: {file}")
    else:
        return INFO(f"{service_name} 서비스 설정 파일({file})을 찾을 수 없습니다.")

def check_nfs_shares():
    try:
        subprocess.check_output("showmount -e localhost", shell=True, stderr=subprocess.STDOUT)
        return WARN("NFS 서비스에서 공유 목록이 발견됨")
    except subprocess.CalledProcessError:
        return OK("NFS 서비스에서 공유 목록이 발견되지 않음")

def check_smb_shares():
    try:
        subprocess.check_output("smbclient -L localhost -N", shell=True, stderr=subprocess.STDOUT)
        return WARN("SMB/CIFS 서비스에서 공유 목록이 발견됨")
    except subprocess.CalledProcessError:
        return OK("SMB/CIFS 서비스에서 공유 목록이 발견되지 않음")

with open(tmp1, 'a') as f:
    f.write(check_access_control(NFS_EXPORTS_FILE, "NFS"))
    f.write(check_access_control(SMB_CONF_FILE, "SMB/CIFS"))
    f.write(check_nfs_shares())
    f.write(check_smb_shares())

BAR()

# 결과 출력
with open(tmp1, 'r') as f:
    print(f.read())
print()
