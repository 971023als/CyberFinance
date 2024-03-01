@echo off
setlocal

echo =============================================
echo 공용(PUBLIC) 역할에 부여된 불필요한 권한 확인
echo =============================================

set /p DBType="데이터베이스 유형을 입력하세요 (MySQL/Oracle): "
set /p DBUser="데이터베이스 사용자 이름을 입력하세요: "
set /p DBPass="데이터베이스 비밀번호를 입력하세요: "

if "%DBType%"=="MySQL" (
    echo MySQL이 선택되었습니다. 다음 쿼리를 MySQL 클라이언트에서 수동으로 실행해 주세요:
    echo SELECT GRANTEE, PRIVILEGE_TYPE FROM information_schema.user_privileges WHERE GRANTEE = 'PUBLIC';
    echo.
) else if "%DBType%"=="Oracle" (
    echo Oracle이 선택되었습니다. 다음 쿼리를 SQL*Plus 클라이언트에서 수동으로 실행해 주세요:
    echo CONNECT %DBUser%/%DBPass%
    echo SET HEADING OFF;
    echo SET FEEDBACK OFF;
    echo SELECT PRIVILEGE FROM dba_sys_privs WHERE GRANTEE = 'PUBLIC';
    echo EXIT;
    echo.
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
    goto end
)

echo 실행된 쿼리의 결과를 검토하여 PUBLIC 역할에 부여된 불필요한 권한이 있는지 확인하세요.
echo 불필요한 권한이 발견되면 보안을 강화하기 위해 해당 권한을 회수하는 것을 고려하세요.

:end
endlocal
