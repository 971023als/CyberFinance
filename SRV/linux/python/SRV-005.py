import os
import subprocess

def bar(log_file):
    print("--------------------------------------------------", file=log_file)

def check_smtp_service(service_name, config_file, restrictions):
    if subprocess.run(["systemctl", "is-active", "--quiet", service_name]).returncode == 0:
        service_status = f"{service_name} 서비스가 실행 중입니다."
        config_status = check_config_restrictions(service_name, config_file, restrictions)
    else:
        service_status = f"{service_name} 서비스가 비활성화되어 있거나 실행 중이지 않습니다."
        config_status = None
    return service_status, config_status

def check_config_restrictions(service_name, config_file, restrictions):
    if os.path.isfile(config_file):
        with open(config_file, 'r') as file:
            content = file.read()
            if all(restriction in content for restriction in restrictions):
                return f"OK: {service_name}에서 명령어 사용이 제한됨"
            else:
                return f"WARN: {service_name}에서 명령어 사용이 제한되지 않음"
    else:
        return f"WARN: {config_file} 파일을 찾을 수 없음"

def main():
    tmp1 = os.path.basename(__file__) + ".log"
    with open(tmp1, 'w') as log_file:
        bar(log_file)
        print("CODE [SRV-005] SMTP 서비스의 expn/vrfy 명령어 실행 제한 미비", file=log_file)
        print("[양호]: SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하고 있는 경우\n[취약]: SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하지 않는 경우", file=log_file)
        bar(log_file)

        smtp_services = {
            "postfix": ("/etc/postfix/main.cf", ["disable_vrfy_command = yes"]),
            "sendmail": ("/etc/mail/sendmail.cf", ["O PrivacyOptions=.*noexpn.*", "O PrivacyOptions=.*novrfy.*"])
        }

        for service, (config_file, restrictions) in smtp_services.items():
            service_status, config_status = check_smtp_service(service, config_file, restrictions)
            print(service_status, file=log_file)
            if config_status:
                print(config_status, file=log_file)

        bar(log_file)

    with open(tmp1, 'r') as log_file:
        print(log_file.read())

if __name__ == "__main__":
    main()
