@echo off
setlocal

echo Supported databases: MySQL
set /p DB_TYPE="Enter the type of your database (MySQL): "

if /I "%DB_TYPE%"=="MySQL" (
    set /p MYSQL_USER="Enter MySQL username: "
    set /p MYSQL_PASS="Enter MySQL password: "

    echo Checking for unencrypted important data in MySQL...
    mysql -u%MYSQL_USER% -p%MYSQL_PASS% -e "SELECT COUNT(*) FROM your_table WHERE your_field IS NOT NULL AND your_field != AES_DECRYPT(AES_ENCRYPT(your_field, 'your_key'), 'your_key');" > tmp_result.txt

    set /p ENCRYPTED_COUNT=<tmp_result.txt
    if "%ENCRYPTED_COUNT%" GTR "0" (
        echo WARNING: Unencrypted important data exists.
    ) else (
        echo OK: All important data is encrypted.
    )

    del tmp_result.txt
) else (
    echo Unsupported database type.
)

pause
:end
