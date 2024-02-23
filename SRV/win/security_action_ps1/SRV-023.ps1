# 결과 파일 초기화
$TMP1 = "$(Get-Location)\$(($MyInvocation.MyCommand.Name).Replace('.ps1', '.log'))"
"" | Set-Content $TMP1

Function BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function CODE {
    Param ([string]$message)
    $message | Out-File -FilePath $TMP1 -Append
}

Function OK {
    Param ([string]$message)
    "OK: $message" | Out-File -FilePath $TMP1 -Append
}

Function WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

BAR

CODE "[양호]: SSH 서비스의 암호화 수준이 적절하게 설정된 경우
[취약]: SSH 서비스의 암호화 수준 설정이 미흡한 경우"

BAR

# SSH 설정 파일 경로 지정 (Windows OpenSSH 서버 기본 경로)
$SSH_CONFIG_FILE = "C:\ProgramData\ssh\sshd_config"

# SSH 암호화 관련 설정 확인
$ENCRYPTION_SETTINGS = @("KexAlgorithms", "Ciphers", "MACs")

if (Test-Path $SSH_CONFIG_FILE) {
  foreach ($setting in $ENCRYPTION_SETTINGS) {
    $configContent = Get-Content -Path $SSH_CONFIG_FILE -ErrorAction SilentlyContinue
    if ($configContent -match "$setting") {
      OK "$SSH_CONFIG_FILE 파일에서 $setting 설정이 적절하게 구성되어 있습니다."
    } else {
      WARN "$SSH_CONFIG_FILE 파일에서 $setting 설정이 미흡합니다. 설정을 검토하고 필요한 경우 강화하세요."
    }
  }
} else {
  WARN "OpenSSH 서버 구성 파일($SSH_CONFIG_FILE)을 찾을 수 없습니다. SSH 서버가 설치되어 있는지 확인하세요."
}

BAR

Get-Content $TMP1 | Write-Output
Write-Host
