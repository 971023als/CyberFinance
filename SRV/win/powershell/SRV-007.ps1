﻿# 결과 파일 정의
$TMP1 = "{0}.log" -f $MyInvocation.MyCommand.Name
# 결과 파일 초기화
"" | Set-Content $TMP1

# 로그 파일에 정보 추가
@"
------------------------------------------------
CODE [SRV-007] 취약한 버전의 SMTP 서비스 사용
------------------------------------------------
[양호]: SMTP 서비스 버전이 최신 버전일 경우 또는 취약점이 없는 버전을 사용하는 경우
[취약]: SMTP 서비스 버전이 최신이 아니거나 알려진 취약점이 있는 버전을 사용하는 경우
------------------------------------------------
"@ | Out-File -FilePath $TMP1 -Append

# SMTP 서비스 버전 확인 (Exchange 서버 버전 확인을 예로 사용)
$ExchangeVersion = Get-ExchangeServer | Select-Object -ExpandProperty AdminDisplayVersion
If ($ExchangeVersion -ne $null) {
    # 안전한 버전 정보 설정 (실제 환경에 맞게 수정 필요)
    $SafeVersion = 'Version 15.1 (Build 1713.5)' # 예시 버전

    If ($ExchangeVersion -ge $SafeVersion) {
        "Exchange 서버 버전이 안전합니다. 현재 버전: $ExchangeVersion" | Out-File -FilePath $TMP1 -Append
    } Else {
        "Exchange 서버 버전이 취약할 수 있습니다. 현재 버전: $ExchangeVersion" | Out-File -FilePath $TMP1 -Append
    }
} Else {
    "Exchange 서버가 설치되어 있지 않습니다." | Out-File -FilePath $TMP1 -Append
}

"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content $TMP1 | Write-Output
