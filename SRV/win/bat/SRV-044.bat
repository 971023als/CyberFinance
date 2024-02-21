@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%" echo 결과 로그 파일

:: IIS에서 파일 업로드 크기 제한 설정 (기본값: 30000000 바이트, 약 28.6MB)
set "UploadLimitSize=30000000"

echo IIS에서 파일 업로드 크기를 제한 설정 중... >> "%TMP1%"

:: PowerShell을 사용하여 IIS의 requestLimits 설정 변경
powershell -Command "& {
    Import-Module WebAdministration;
    Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter 'system.webServer/security/requestFiltering/requestLimits' -name 'maxAllowedContentLength' -value %UploadLimitSize%;
}"

echo 설정 완료: 파일 업로드 크기가 %UploadLimitSize% 바이트로 제한됩니다. >> "%TMP1%"
type "%TMP1%"

echo.
