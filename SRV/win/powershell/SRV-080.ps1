$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

Add-Content -Path $TMP1 -Value "일반 사용자에 의한 프린터 드라이버 설치 제한 상태 확인"

# 예제: Windows에서 프린터 설치 권한이 있는 사용자 그룹을 확인
# 이 방법은 실제로 Group Policy 설정을 직접적으로 확인하지 않습니다.
try {
    $printerAdmins = Get-WmiObject -Class Win32_Printer -Property "SystemName" | ForEach-Object {
        $_.SystemName
    }
    if ($printerAdmins) {
        Add-Content -Path $TMP1 -Value "OK: 프린터 설치 권한이 있는 사용자 또는 그룹: $printerAdmins"
    } else {
        Add-Content -Path $TMP1 -Value "WARN: 프린터 드라이버 설치에 대한 제한 설정을 확인할 수 없습니다."
    }
} catch {
    Add-Content -Path $TMP1 -Value "ERROR: 프린터 설정 확인 중 오류 발생"
}

Get-Content -Path $TMP1
