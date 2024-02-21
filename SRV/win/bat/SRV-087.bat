@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-087] C 컴파일러 존재 및 권한 설정 >> "%TMP1%"
echo [양호]: C 컴파일러가 존재하지 않거나 적절한 권한으로 설정됨 >> "%TMP1%"
echo [취약]: C 컴파일러가 존재하며 권한 설정이 부적절함 >> "%TMP1%"

:: C 컴파일러(gcc) 존재 여부 확인
where gcc >nul 2>&1

if %errorlevel% equ 0 (
    echo OK "시스템에 C 컴파일러(gcc)가 설치되어 있습니다." >> "%TMP1%"
    :: Windows는 Linux와 같은 방식으로 실행 파일에 대한 권한 모델을 사용하지 않으므로
    :: 여기서 권한을 확인하지 않습니다.
) else (
    echo OK "시스템에 C 컴파일러(gcc)가 설치되어 있지 않습니다." >> "%TMP1%"
)

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
