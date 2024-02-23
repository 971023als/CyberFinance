# 임시 로그 파일 생성
$TMP1 = "$([IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1
BAR

# IIS 버전 확인
$IISVersion = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\InetStp" -Name "VersionString" -ErrorAction SilentlyContinue

if ($IISVersion -ne $null) {
    $currentVersion = $IISVersion.VersionString -replace "Version ", ""
    # 여기에 최신 버전과 비교하는 로직을 추가해야 함
    $latestVersion = "여기에 최신 버전 입력" # 최신 버전 정보는 Microsoft 공식 문서나 안전한 출처에서 확인
    if ($currentVersion -eq $latestVersion) {
        OK "IIS (SMTP 서비스 포함)가 최신 버전입니다: $currentVersion" | Out-File -FilePath $TMP1 -Append
    } else {
        WARN "IIS 버전이 최신이 아닙니다. 최신 버전으로 업데이트하세요: 현재 버전 $currentVersion, 최신 버전 $latestVersion" | Out-File -FilePath $TMP1 -Append
        # 업데이트 권장 사항 또는 방법 제공
    }
} else {
    INFO "IIS가 설치되어 있지 않습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1
Write-Host `n
