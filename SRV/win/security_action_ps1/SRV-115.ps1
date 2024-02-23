function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$global:TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-115] 로그의 정기적 검토 및 보고 미수행"

Add-Content -Path $global:TMP1 -Value "[양호]: 로그가 정기적으로 검토 및 보고되고 있는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 로그가 정기적으로 검토 및 보고되지 않는 경우"

BAR

# 로그 검토 및 보고 스크립트 존재 여부 확인
$logReviewScriptPath = "C:\Path\To\Log\Review\Script.ps1"
if (-not (Test-Path -Path $logReviewScriptPath)) {
    Add-Content -Path $global:TMP1 -Value "WARN: 로그 검토 및 보고 스크립트가 존재하지 않습니다."
} else {
    Add-Content -Path $global:TMP1 -Value "OK: 로그 검토 및 보고 스크립트가 존재합니다."
}

# 로그 보고서 존재 여부 확인
$logReportPath = "C:\Path\To\Log\Report.txt"
if (-not (Test-Path -Path $logReportPath)) {
    Add-Content -Path $global:TMP1 -Value "WARN: 로그 보고서가 존재하지 않습니다."
} else {
    Add-Content -Path $global:TMP1 -Value "OK: 로그 보고서가 존재합니다."
}

# 결과 파일 출력
Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n"

1. 이벤트 로그 감사 설정
1. 제어판을 이용한 설정
        : gpedit.msc ▶ 컴퓨터 구성 ▶ 
Windows 설정 ▶ 보안 설정 ▶ 로컬 정책 ▶ 감사 정책
                            : gpedit.msc ▶ 컴퓨터 구성 
Windows 설정 ▶ 보안 설정 ▶ 고급 감사 정책 구성 ▶ 
시스템 감사 정책 ▶ 계정 로그온, 계정 관리, 세부 추적, 
로그온/로그오프, 개체 액세스, 시스템
자격 증명 유효성 검사 감사 (성공, 실패)
기타 계정 로그온 이벤트 감사 (성공, 실패)
컴퓨터 계정 관리 감사 (성공, 실패)
사용자 계정 관리 감사 (성공, 실패)
프로세스 만들기 감사 (성공, 실패)
 RPC 이벤트 감사 (성공, 실패)
로그오프 감사 (성공, 실패)
로그온 감사 (성공, 실패)
기타 로그온/로그오프 이벤트 감사 (성공, 실패)
특수 로그온 감사 (성공, 실패)
파일 공유 감사 (성공, 실패)
기타 개체 액세스 이벤트 감사 (성공, 실패)
보안 상태 변경 감사 (성공, 실패)
 12
 13. 시스템 복원 설정
시스템 설정 및 이전 버전 파일 복원 (체크)
디스크 공간 사용 : 20GB 이상으로 설정%SystemDrive%\System Volume Information
 1. 제어판을 이용한 설정
                      : 시작 프로그램, 관리 도구 ▶
 Windows Server 백업 ▶ 백업 일정
(윈도우 서버는 다음 위치에서 기능 설치후 설정 가능 : 
시작 프로그램 ▶ 서버 관리자 ▶ 기능 추가 ▶ 
Windows Server 백업 기능)
               : 제어판 ▶ 시스템 속성 ▶ 시스템 보호 ▶ 
볼륨 선택, 구성 ▶ 복원 설정, 디스크 공간 사용
12
 12
 9. 로컬 방화벽 로그 설정
1. 제어판을 이용한 설정
        : 시작 프로그램, 관리 도구 ▶ 
고급 보안이 설정된 Windows 방화벽 ▶ 속성 ▶ 
로깅, 사용자 지정
                            : 제어판 ▶ Windows 방화벽 ▶ 
고급 설정 ▶ 속성 ▶ 로깅, 사용자 지정
손실된 패킷을 로그에 기록: 활성화 
성공한 연결을 로그에 기록: 활성화 
LogFileSize: 0x19000 
(102400 KB)(100 MB 이상)
 %SystemRoot%\System32\LogFiles
 \Firewall\pfirewall.log
 12
 12
 6. 이벤트 로그 설정 (윈도우 방화벽)
 1. 로그 크기 설정
이벤트 뷰어 ▶ 응용 프로그램 및 서비스 로그 ▶ 
Microsoft ▶ Windows ▶ Windows Defender ▶
 Operational ▶ 속성
로깅 : 사용
크기 : 0x06400000 
(102400 KB) (100MB 이상)
 12
    Microsoft-Windows-Windows Defender%
 4Operational.evtx
       은 Desktop Experience 설치 후 기능 
활성화 가능
       는 Microsoft Security Essentials in 
Windows Server 2012 설치 후 활성화 가능
12
 5. 이벤트 로그 설정 (저장매체 연결)
로깅 : 사용
크기 : 0x06400000 
(102400 KB) (100MB 이상)
 1. 로그 크기 설정
이벤트 뷰어 ▶ 응용 프로그램 및 서비스 로그 ▶
 Microsoft ▶ Windows ▶
 DriverFrameworks-UserMode ▶ Operational ▶ 속성
12
 8. 이벤트 로그 설정 (네트워크 연결)
로깅 : 사용
크기 : 0x06400000 
(102400 KB) (100MB 이상)
 1. 로그 크기 설정
이벤트 뷰어 ▶ 응용 프로그램 및 서비스 로그 ▶ 
Microsoft ▶ Windows ▶ NetworkProfile ▶ 
Operational ▶ 속성 
12
 4. 이벤트 로그 설정 (시간 변경)
 1. 로그 크기 설정
이벤트 뷰어 ▶ 응용 프로그램 및 서비스 로그 ▶ 
Microsoft ▶ Windows ▶ DateTimeControlPanel ▶ 
Operational ▶ 속성
로깅 : 사용
크기 : 0x06400000 
(102400 KB) (100MB 이상)
 12
 2. 이벤트 로그 크기 설정
보안, 시스템, 애플리케이션 : 
0xFFFF0000 (4194240 KB) (4GB 이상)
파워쉘 : 
0x06400000 (102400 KB) (100MB 이상)
 1. 레지스트리를 이용한 설정
 : HKLM\SYSTEM\CurrentControlSet\services\
   eventlog\Security\MaxSize (REG_DWORD)
 : HKLM\SYSTEM\CurrentControlSet\services\
   eventlog\System\MaxSize (REG_DWORD)
 : HKLM\SYSTEM\CurrentControlSet\services\
   eventlog\Application\MaxSize (REG_DWORD)
 : HKLM\SYSTEM\CurrentControlSet\services\
   eventlog\Windows PowerShell\MaxSize 
   (REG_DWORD)
 12
 Security, System, Application 이벤트 로그는 
여유 공간 확보 후 저장
     Security.evtx
     System.evtx
     Application.evtx
     Windows PowerShell.evtx
 12
 7. 이벤트 로그 설정 (원격 데스크톱)
 1. 로그 크기 설정
이벤트 뷰어 ▶ 응용 프로그램 및 서비스 로그 ▶ 
Microsoft ▶ Windows
 : RemoteDesktopServices-RdpCoreTS ▶ 
   Operational ▶ 속성
 : TerminalServices-LocalSessionManager ▶ 
   Operational ▶ 속성
 : TerminalService-RemoteConnectionManager ▶ 
   Operational ▶ 속성
로깅 : 사용
크기 : 0x06400000 
(102400 KB) (100MB 이상)
 12
 상기 설정은 각 윈도우 순정버전에서 테스트되었으며 OS 세부 버전에 따라 달라질 수 있습니다.
고급 감사정책 구성 GUI는 쓸 수 없으며 
auditpol.exe를 통한 수동 설정만 가능