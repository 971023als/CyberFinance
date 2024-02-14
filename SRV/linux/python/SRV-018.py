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

code = "[SRV-018] 불필요한 하드디스크 기본 공유 활성화"
with open(tmp1, 'a') as f:
    f.write(f"{code}\n")
    f.write("[양호]: NFS 또는 SMB/CIFS의 불필요한 하드디스크 공유가 비활성화된 경우\n")
    f.write("[취약]: NFS 또는 SMB/CIFS에서 불필요한 하드디스크 기본 공유가 활성화된 경우\n")

BAR()

# NFS와 SMB/CIFS 설정 파일을 확인합니다.
NFS_EXPORTS_FILE = "/etc/exports"
SMB_CONF_FILE = "/etc/samba/smb.conf"

def check_share_activation(file, service_name):
    result = ""
    if os.path.isfile(file):
        with open(file, 'r') as f:
            if any(line.strip().startswith('/') for line in f):
                result += WARN(f"{service_name} 서비스에서 불필요한 공유가 활성화되어 있습니다: {file}")
            else:
                result += OK(f"{service_name} 서비스에서 불필요한 공유가 비활성화되어 있습니다: {file}")
    else:
        result += INFO(f"{service_name} 서비스 설정 파일({file})을 찾을 수 없습니다.")
    return result

with open(tmp1, 'a') as f:
    f.write(check_share_activation(NFS_EXPORTS_FILE, "NFS"))
    f.write(check_share_activation(SMB_CONF_FILE, "SMB/CIFS"))

BAR()

# 결과 출력
with open(tmp1, 'r') as f:
    print(f.read())
