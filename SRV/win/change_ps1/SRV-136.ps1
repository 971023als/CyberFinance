# 결과 파일 정의
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_SystemShutdownPermissions.log"

# 시스템 종료 권한 확인 (Local Security Policy)
$seShutdownPrivilege = secpol.exe /export /cfg secpol.cfg 2>$null
$shutdownPrivilege = Get-Content -Path .\secpol.cfg | Select-String "SeShutdownPrivilege"

if ($shutdownPrivilege -match "SeShutdownPrivilege") {
    "OK: 시스템 종료 권한이 적절히 제한되어 있습니다." | Out-File -FilePath $TMP1
} else {
    "WARN: 시스템 종료 권한이 제한되지 않은 것으로 보입니다." | Out-File -FilePath $TMP1
}

Remove-Item -Path .\secpol.cfg -Force

# 결과 파일 출력
Get-Content -Path $TMP1
