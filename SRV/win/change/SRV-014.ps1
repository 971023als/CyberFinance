# 결과 파일 초기화
$TMP1 = "$(Split-Path -Leaf $MyInvocation.MyCommand.Definition).log"
"" | Set-Content $TMP1

Function BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR

"CODE [SRV-014] NFS 접근통제 미비" | Out-File -FilePath $TMP1 -Append

# NFS 서비스 실행 여부 및 설정 점검 (Windows 환경)
$NfsService = Get-Service -Name "NfsService" -ErrorAction SilentlyContinue

if ($NfsService -and $NfsService.Status -eq "Running") {
    WARN "NFS 서비스가 실행 중입니다. NFS 설정을 점검하세요."
    # Windows 환경에서 NFS 설정 점검 로직을 구현하는 부분은
    # NFS 설정 관리에 관한 구체적인 PowerShell cmdlet 또는 Windows 관리 도구를 참조해야 합니다.
} else {
    OK "NFS 서비스가 비활성화되었거나 실행 중이지 않습니다."
}

BAR

Get-Content $TMP1 | Write-Output
Write-Host
