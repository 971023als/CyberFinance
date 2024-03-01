@echo off
echo ============================================
echo CODE [DBM-014] 취약한 운영체제 역할 인증 기능(OS_ROLES, REMOTE_OS_ROLES) 사용
echo ============================================

echo Oracle 데이터베이스에서 OS_ROLES 및 REMOTE_OS_ROLES 확인 방법:
echo 1. SQL*Plus를 엽니다.
echo 2. Oracle DB 사용자 이름과 비밀번호를 사용하여 데이터베이스에 연결합니다.
echo    예시: CONNECT 사용자이름/비밀번호@데이터베이스
echo 3. OS_ROLES 및 REMOTE_OS_ROLES의 상태를 확인하기 위해 다음 쿼리를 실행합니다:
echo    SELECT value FROM v$parameter WHERE name = 'os_roles';
echo    SELECT value FROM v$parameter WHERE name = 'remote_os_roles';
echo 4. 안전한 구성을 위해 두 설정 모두 FALSE로 설정되어 있는지 확인합니다.

echo ============================================
echo 수동 조치 필요: Oracle 데이터베이스 역할을 확인하기 위해 위의 지시사항을 따르십시오.
echo ============================================
pause
