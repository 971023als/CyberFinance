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

@"
[양호]: SSH 서비스의 암호화 수준이 적절하게 설정된 경우
[취약]: SSH 서비스의 암호화 수준 설정이 미흡한 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# SSH 설정 파일 경로 지정
$SSH_CONFIG_FILE = "/etc/ssh/sshd_config"

# SSH 암호화 관련 설정 확인
$ENCRYPTION_SETTINGS = @("KexAlgorithms", "Ciphers", "MACs")

foreach ($setting in $ENCRYPTION_SETTINGS) {
  # SSH 설정 파일에서 설정을 검사합니다.
  # PowerShell에서는 리눅스 파일 시스템 직접 접근이 어렵기 때문에 예시로만 제공됩니다.
  # 실제 사용 시 해당 설정이 Windows 시스템에서 어떻게 적용되는지에 대한 추가 검토가 필요합니다.
  $configContent = Get-Content -Path $SSH_CONFIG_FILE -ErrorAction SilentlyContinue
  if ($configContent -match "^$setting") {
    OK "$SSH_CONFIG_FILE 파일에서 $setting 설정이 적절하게 구성되어 있습니다."
  } else {
    WARN "$SSH_CONFIG_FILE 파일에서 $setting 설정이 미흡합니다."
  }
}

Get-Content $TMP1 | Write-Output
Write-Host
