import os
import subprocess

def bar():
    print("--------------------------------------------------")

def check_snmp_service():
    ps_snmp_count = subprocess.getoutput("ps -ef | grep -i 'snmp' | grep -v 'grep' | wc -l")
    return int(ps_snmp_count) > 0

def check_snmp_configuration():
    snmpdconf_file = "/etc/snmp/snmpd.conf"
    if os.path.isfile(snmpdconf_file):
        with open(snmpdconf_file, 'r') as file:
            if any(line.lower() for line in file if "public" in line or "private" in line):
                return "WARN: 기본 SNMP Community 스트링(public/private)이 사용됨"
            else:
                return "OK: 기본 SNMP Community 스트링(public/private)이 사용되지 않음"
    else:
        return "WARN: SNMP 구성 파일({})을 찾을 수 없음".format(snmpdconf_file)

def main():
    tmp1 = os.path.basename(__file__) + ".log"
    with open(tmp1, 'w') as log_file:
        bar()
        log_file.write("CODE [SRV-001] SNMP 서비스 Get Community 스트링 설정 오류\n")
        log_file.write("\n[양호]: SNMP Community 스트링이 복잡하고 예측 불가능하게 설정된 경우\n")
        log_file.write("[취약]: SNMP Community 스트링이 기본값이거나 예측 가능하게 설정된 경우\n")
        bar()
        log_file.write("\n[SRV-001] SNMP 서비스 Get Community 스트링 설정 오류\n")

        if check_snmp_service():
            result = check_snmp_configuration()
            log_file.write(result + "\n")
        else:
            log_file.write("OK: SNMP 서비스가 실행 중이지 않습니다.\n")
        bar()

    with open(tmp1, 'r') as log_file:
        print(log_file.read())

if __name__ == "__main__":
    main()
