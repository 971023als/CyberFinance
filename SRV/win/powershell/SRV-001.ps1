﻿# function.ps1 파일을 로드합니다. 이 파일에는 BAR, CODE, WARN, OK 함수가 정의되어 있어야 합니다.
. .\function.ps1

# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
Out-File -FilePath $TMP1 -InputObject "" -Force

# 구분선과 코드 출력
BAR
CODE "SRV-001 SNMP 서비스 Get Community 스트링 설정 오류"

# 로그 파일에 내용 추가
@"
[양호]: SNMP Community 스트링이 복잡하고 예측 불가능하게 설정된 경우

[취약]: SNMP Community 스트링이 기본값이거나 예측 가능하게 설정된 경우

"@ | Out-File -FilePath $TMP1 -Append

BAR
"[SRV-001] SNMP 서비스 Get Community 스트링 설정 오류" | Out-File -FilePath $TMP1 -Append

# SNMP 서비스 실행 중인지 확인
$psSnmpCount = (Get-Process | Where-Object { $_.ProcessName -match 'snmp' }).Count

if ($psSnmpCount -gt 0) {
    $snmpdconfFile = "C:\Path\To\snmpd.conf" # Windows 환경에 맞게 경로 조정 필요

    if (Test-Path $snmpdconfFile) {
        # "public" 또는 "private" 스트링 존재 여부 확인
        $fileContent = Get-Content $snmpdconfFile
        if ($fileContent -match 'public|private') {
            WARN "기본 SNMP Community 스트링(public/private)이 사용됨" | Out-File -FilePath $TMP1 -Append
        } else {
            OK "기본 SNMP Community 스트링(public/private)이 사용되지 않음" | Out-File -FilePath $TMP1 -Append
        }
    } else {
        WARN "SNMP 구성 파일($snmpdconfFile)을 찾을 수 없음" | Out-File -FilePath $TMP1 -Append
    }
} else {
    OK "SNMP 서비스가 실행 중이지 않습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1
Write-Host `n
