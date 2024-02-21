@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
> "%TMP1%" echo 결과 로그 파일

:: 웹 사이트 루트 디렉터리 설정
set "WebRoot=C:\inetpub\wwwroot"

:: 불필요한 파일 유형 정의 (예: .bak, .tmp 등)
set "UnnecessaryFiles=*.bak *.tmp *.old"

echo 웹 서비스 경로 내 불필요한 파일 검사 중... >> "%TMP1%"

:: 웹 사이트 루트 디렉터리 내 불필요한 파일 검색
for %%F in (%UnnecessaryFiles%) do (
    echo 검색: %%F >> "%TMP1%"
    for /r "%WebRoot%" %%I in (%%F) do (
        echo 발견: %%I >> "%TMP1%"
    )
)

echo 검사 완료. >> "%TMP1%"
type "%TMP1%"

echo.
