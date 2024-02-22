# 필요한 함수를 포함하는 외부 스크립트를 로드합니다.
. .\function.ps1

# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# SNMP 구성 파일의 경로
$snmpdconfFile = "C:\Path\To\snmpd.conf" # 실제 경로로 수정

# 구성 파일이 존재하는지 확인
if (Test-Path $snmpdconfFile) {
    # 구성 파일 내용을 읽어옴
    $fileContent = Get-Content $snmpdconfFile

    # "public" 또는 "private" 스트링을 안전한 값으로 변경
    $secureStringSet = "SecureSetString" # 안전한 Set Community 스트링으로 교체
    $fileContent = $fileContent -replace 'public', $secureStringSet
    $fileContent = $fileContent -replace 'private', $secureStringSet

    # 변경된 내용을 구성 파일에 씀
    $fileContent | Out-File -FilePath $snmpdconfFile

    # 로그 파일에 양호한 결과 기록
    BAR | Out-File -FilePath $TMP1 -Append
    OK "SNMP Set Community 스트링이 안전하게 업데이트되었습니다." | Out-File -FilePath $TMP1 -Append
    BAR | Out-File -FilePath $TMP1 -Append
} else {
    # 구성 파일을 찾을 수 없는 경우 로그 파일에 취약한 결과 기록
    BAR | Out-File -FilePath $TMP1 -Append
    WARN "SNMP 구성 파일($snmpdconfFile)을 찾을 수 없음" | Out-File -FilePath $TMP1 -Append
    BAR | Out-File -FilePath $TMP1 -Append
}

# 결과 출력
Get-Content $TMP1
Write-Host `n
