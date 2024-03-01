@echo off
echo ============================================
echo CODE [DBM-012] Listener Control Utility(lsnrctl) 보안 설정 미흡
echo ============================================

set /p listener_ora="Listener 설정 파일(listener.ora)의 경로를 입력하세요: "

if not exist "%listener_ora%" (
    echo 경고: Listener 설정 파일이 존재하지 않습니다.
    goto end
)

findstr /C:"ADMIN_RESTRICTIONS_LISTENER=ON" "%listener_ora%" > nul
if errorlevel 1 (
    echo 경고: Listener Control Utility에 ADMIN_RESTRICTIONS_LISTENER 설정이 적용되지 않았습니다.
) else (
    echo 양호: Listener Control Utility 보안 설정이 적절히 적용되었습니다.
)

:end
echo ============================================
pause
