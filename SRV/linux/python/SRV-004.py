import os
import subprocess

def bar():
    print("--------------------------------------------------", file=log_file)

def check_service_status(service_name):
    status = subprocess.run(["systemctl", "is-active", "--quiet", service_name], stdout=subprocess.DEVNULL)
    if status.returncode == 0:
        return f"WARN: {service_name} 서비스가 실행 중입니다."
    else:
        return f"OK: {service_name} 서비스가 비활성화되어 있거나 실행 중이지 않습니다."

def check_port_status(port):
    result = subprocess.run(["ss", "-tuln"], capture_output=True, text=True)
    if f":{port} " in result.stdout:
        return "WARN: SMTP 포트(25)가 열려 있습니다. 불필요한 서비스가 실행 중일 수 있습니다."
    else:
        return "OK: SMTP 포트(25)는 닫혀 있습니다."

def main():
    tmp1 = os.path.basename(__file__) + ".log"
    global log_file
    with open(tmp1, 'w') as log_file:
        bar()
        print("CODE [SRV-004] 불필요한 SMTP 서비스 실행", file=log_file)
        print("[양호]: SMTP 서비스가 비활성화되어 있거나 필요한 경우에만 실행되는 경우\n[취약]: SMTP 서비스가 필요하지 않음에도 실행되고 있는 경우", file=log_file)
        bar()
        print("[SRV-004] 불필요한 SMTP 서비스 실행", file=log_file)

        # Check SMTP service status
        smtp_service = "postfix"
        service_status = check_service_status(smtp_service)
        print(service_status, file=log_file)

        # Check for SMTP service on port 25
        port_status = check_port_status(25)
        print(port_status, file=log_file)

        bar()

    with open(tmp1, 'r') as log_file:
        print(log_file.read())

if __name__ == "__main__":
    main()
