@echo off
setlocal

echo 지원하는 데이터베이스:
echo 1. MySQL
echo 2. PostgreSQL
set /p DBType="데이터베이스 유형에 해당하는 번호를 입력하세요: "

set /p DBUser="데이터베이스 사용자 이름을 입력하세요: "
set /p DBPass="데이터베이스 비밀번호를 입력하세요: "

if "%DBType%"=="1" (
    echo MySQL 선택됨. 비밀번호 재사용 방지 설정 확인 중...
    echo 다음 쿼리를 MySQL 클라이언트에서 수동으로 실행해 주세요:
    echo SELECT VARIABLE_VALUE FROM information_schema.global_variables WHERE VARIABLE_NAME = 'validate_password_history';
    echo 비밀번호 재사용 방지 설정이 구성되어 있는지 확인하세요.
) else if "%DBType%"=="2" (
    echo PostgreSQL 선택됨. 비밀번호 재사용 방지 설정 확인 중...
    echo 다음 명령어를 PostgreSQL 클라이언트에서 수동으로 실행해 주세요:
    echo SHOW password_encryption;
    echo 주의: PostgreSQL의 비밀번호 재사용 방지는 구성 설정의 수동 검증이 필요할 수 있습니다.
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
)

echo 비밀번호 재사용 방지 설정의 출력 결과를 검토하세요.

:end
endlocal
