# 결과 파일 정의
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_DEPStatus.log"
New-Item -Path $TMP1 -ItemType File

# 스택 영역 실행 방지 설정 확인
$depStatus = Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty DataExecutionPrevention_SupportPolicy

# DEP 상태에 따른 결과 출력
switch ($depStatus) {
    0 {"WARN: DEP가 모든 프로세스에 대해 비활성화되어 있습니다." | Out-File -FilePath $TMP1}
    1 {"OK: DEP가 필수 Windows 프로그램과 서비스에 대해서만 활성화되어 있습니다." | Out-File -FilePath $TMP1}
    2 {"WARN: DEP가 모든 프로세스에 대해 활성화되어 있지만, 사용자에 의해 예외가 설정될 수 있습니다." | Out-File -FilePath $TMP1}
    3 {"OK: DEP가 모든 프로세스에 대해 활성화되어 있습니다." | Out-File -FilePath $TMP1}
    default {"INFO: DEP 상태를 확인할 수 없습니다." | Out-File -FilePath $TMP1}
}

# 결과 파일 출력
Get-Content -Path $TMP1
