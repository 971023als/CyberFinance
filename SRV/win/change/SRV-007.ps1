# 임시 로그 파일 생성
$TMP1 = "$([IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1
BAR

CODE "SRV-007 취약한 버전의 SMTP 서비스 사용"

@"
[양호]: SMTP 서비스 버전이 최신 버전일 경우 또는 취약점이 없는 버전을 사용하는 경우
[취약]: SMTP 서비스 버전이 최신이 아니거나 알려진 취약점이 있는 버전을 사용하는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR
"[SRV-007] 취약한 버전의 SMTP 서비스 사용" | Out-File -FilePath $TMP1 -Append

# IIS 버전 확인 (SMTP 서비스는 IIS의 일부로 포함될 수 있음)
$IISVersion = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\InetStp" -Name "VersionString" -ErrorAction SilentlyContinue

if ($IISVersion -ne $null) {
    $currentVersion = $IISVersion.VersionString -replace "Version ", ""
    # 예시로 버전 비교 로직을 포함하지 않음. 실제 조건에 맞게 수정 필요
    OK "IIS 버전이 확인됨: $currentVersion" | Out-File -FilePath $TMP1 -Append
} else {
    INFO "IIS가 설치되어 있지 않습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

Get-Content $TMP1
Write-Host `n
