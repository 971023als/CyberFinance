# SNMP 구성 파일의 경로 설정
$snmpdconfFile = "C:\Path\To\snmpd.conf" # 실제 경로로 수정 필요

# 구성 파일이 존재하는지 확인
if (Test-Path $snmpdconfFile) {
    # 구성 파일 내용을 읽어옴
    $fileContent = Get-Content $snmpdconfFile

    # "public" 또는 "private" 스트링을 안전한 값으로 변경
    # 여기서 "YourSecureString"을 각각 고유하고 복잡한 값으로 대체해야 함
    $fileContent = $fileContent -replace 'public', 'YourSecureString1'
    $fileContent = $fileContent -replace 'private', 'YourSecureString2'

    # 변경된 내용을 구성 파일에 다시 씀
    $fileContent | Out-File -FilePath $snmpdconfFile

    Write-Host "SNMP Community 스트링이 안전하게 업데이트되었습니다."
} else {
    Write-Host "SNMP 구성 파일($snmpdconfFile)을 찾을 수 없습니다."
}
