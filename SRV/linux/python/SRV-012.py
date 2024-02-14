import os
import subprocess

def BAR():
    print("=" * 40)

# 결과 파일 초기화
tmp1 = os.path.basename(__file__) + '.log'

with open(tmp1, 'w') as f:
    pass

BAR()

code = "[SRV-012] .netrc 파일 내 중요 정보 노출"
with open(tmp1, 'a') as f:
    f.write(f"{code}\n")
    f.write("[양호]: 시스템 전체에서 .netrc 파일이 존재하지 않는 경우\n")
    f.write("[취약]: 시스템 전체에서 .netrc 파일이 존재하는 경우\n")

BAR()

# 시스템 전체에서 .netrc 파일 찾기
try:
    netrc_files = subprocess.check_output(["find", "/", "-name", ".netrc"], stderr=subprocess.DEVNULL).decode('utf-8').strip().split('\n')
except subprocess.CalledProcessError:
    netrc_files = []

if not netrc_files[0]:  # 첫 번째 요소가 빈 문자열인 경우, 파일이 없는 것임
    with open(tmp1, 'a') as f:
        f.write("OK: 시스템에 .netrc 파일이 존재하지 않습니다.\n")
else:
    with open(tmp1, 'a') as f:
        f.write("WARN: 다음 위치에 .netrc 파일이 존재합니다: {}\n".format(", ".join(netrc_files)))
        # .netrc 파일의 권한 확인 및 출력
        for file in netrc_files:
            permissions = os.stat(file).st_mode
            f.write("권한 확인: {} {}\n".format(file, oct(permissions)[-3:]))

BAR()

# 결과 출력
with open(tmp1, 'r') as f:
    print(f.read())
print()
