@echo off
setlocal

echo =============================================
echo CODE [DBM-015] Public Role에 불필요한 권한 존재
echo =============================================
echo [양호]: Public Role에 불필요한 권한이 부여되지 않은 경우
echo [취약]: Public Role에 불필요한 권한이 부여된 경우
echo =============================================

echo 지원하는 데이터베이스: MySQL, Oracle
set /p DB_TYPE="사용 중인 데이터베이스 유형을 입력하세요: "

set /p DB_USER="데이터베이스 사용자 이름을 입력하세요: "
set /p DB_PASS="데이터베이스 비밀번호를 입력하세요: "

if "%DB_TYPE%"=="MySQL" (
    echo MySQL을 위한 쿼리:
    echo SELECT GRANTEE, PRIVILEGE_TYPE FROM information_schema.user_privileges WHERE GRANTEE = 'PUBLIC';
) else if "%DB_TYPE%"=="Oracle" (
    echo Oracle을 위한 쿼리:
    echo CONNECT %DB_USER%/%DB_PASS%
    echo SET HEADING OFF;
    echo SET FEEDBACK OFF;
    echo SELECT PRIVILEGE FROM dba_sys_privs WHERE GRANTEE = 'PUBLIC';
    echo EXIT;
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
    goto end
)

echo "PUBLIC 역할에 부여된 불필요한 권한을 확인해 주세요."
echo "불필요한 권한이 있다면, 보안을 강화하기 위해 적절한 조치를 취하세요."

:end
pause
