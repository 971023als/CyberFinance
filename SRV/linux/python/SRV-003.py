import os
import subprocess

def bar():
    print("--------------------------------------------------")

def check_snmp_service():
    ps_snmp_count = subprocess.getoutput("ps -ef | grep -i 'snmp' | grep -v 'grep' | wc -l")
    return int(ps_snmp_count) > 0

def check_snmp_configuration(snmpdconf_file):
    if os.path.isfile(snmpdconf_file):
        with open(snmpdconf_file, 'r') as file:
            if any("public" in line.lower() or "private" in line.lower() for line in file):
                return "WARN: 기본 SNMP Set Community 스트링(public/private)이 사용됨"
            else:
                return "OK: 기본 SNMP Set Community 스트링(public/private)이 사용되지 않음"
    else:
        return "WARN: SNMP 구성 파일({})을 찾을 수 없음".format(snmpdconf_file)

def write_log(tmp1, message):
    with open(tmp1, 'a') as log_file:
        log_file.write(message + "\n")

def main():
    tmp1 = os.path.basename(__file__) + ".log"
    open(tmp1, 'w').close()  # Clear or create log file

    bar()
    write_log(tmp1, "CODE [SRV-002] SNMP 서비스 Set Community 스트링 설정 오류\n")
    write_log(tmp1, "[양호]: SNMP Community 스트링이 복잡하고 예측 불가능하게 설정된 경우\n[취약]: SNMP Community 스트링이 기본값이거나 예측 가능하게 설정된 경우\n")
    bar()
    write_log(tmp1, "[SRV-002] SNMP 서비스 Set Community 스트링 설정 오류")

    if check_snmp_service():
        result = check_snmp_configuration("/etc/snmp/snmpd.conf")
        write_log(tmp1, result)
    else:
        write_log(tmp1, "OK: SNMP 서비스가 실행 중이지 않습니다.")
    bar()

    with open(tmp1, 'r') as log_file:
        print(log_file.read())

if __name__ == "__main__":
    main()
