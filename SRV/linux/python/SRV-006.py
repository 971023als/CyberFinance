import os
import subprocess

# Define the path for the log file
log_file_name = os.path.basename(__file__) + '.log'

# Clear the log file or create it if it doesn't exist
with open(log_file_name, 'w') as log_file:
    log_file.truncate(0)

def bar():
    with open(log_file_name, 'a') as log_file:
        log_file.write("=" * 40 + "\n")

def code(description):
    with open(log_file_name, 'a') as log_file:
        log_file.write(f"\nCODE [{description}] SMTP 서비스 로그 수준 설정 미흡\n")

def append_to_log(message):
    with open(log_file_name, 'a') as log_file:
        log_file.write(f"{message}\n")

# Append initial content
bar()
code("SRV-006")
append_to_log("[양호]: SMTP 서비스의 로그 수준이 적절하게 설정되어 있는 경우\n[취약]: SMTP 서비스의 로그 수준이 낮거나, 로그가 충분히 수집되지 않는 경우")
bar()
append_to_log("\"[SRV-006] SMTP 서비스 로그 수준 설정 미흡\"")

# Configuration file and LogLevel setting
sendmail_config = "/etc/mail/sendmail.cf"
log_level_setting = "O LogLevel"

# Check the LogLevel setting in the sendmail configuration
if os.path.isfile(sendmail_config):
    with open(sendmail_config, 'r') as file:
        lines = file.readlines()
        log_level = None
        for line in lines:
            if line.startswith(log_level_setting):
                log_level = line.split()[2]
                break
        if log_level and int(log_level) >= 9:
            append_to_log(f"OK SMTP 서비스의 로그 수준이 적절하게 설정됨 (현재 수준: {log_level}).")
        else:
            append_to_log(f"WARN SMTP 서비스의 로그 수준이 낮게 설정됨 (현재 수준: {log_level if log_level else '미설정'}).")
else:
    append_to_log(f"INFO sendmail 구성 파일({sendmail_config})을 찾을 수 없습니다.")

bar()

# Display the log file content
with open(log_file_name, 'r') as log_file:
    print(log_file.read())
