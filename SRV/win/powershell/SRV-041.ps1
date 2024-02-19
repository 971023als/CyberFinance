# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-041_log.txt"
"" | Set-Content $TMP1

Function Write-BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function Write-OK {
    Param ([string]$message)
    "$message" | Out-File -FilePath $TMP1 -Append
}

Function Write-WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Write-BAR

@"
[양호]: CGI 스크립트 관리가 적절하게 설정된 경우
[취약]: CGI 스크립트 관리가 미흡한 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# Apache 설정 파일 확인
$ApacheConfigFile = "/etc/apache2/apache2.conf"

# CGI 스크립트 실행 및 관리 설정 확인
# 'ExecCGI' 옵션 및 'AddHandler' 또는 'ScriptAlias' 지시어를 확인합니다.
$CgiExecOption = Select-String -Path $ApacheConfigFile -Pattern "^\s*Options.*ExecCGI"
$CgiHandlerDirective = Select-String -Path $ApacheConfigFile -Pattern "(AddHandler cgi-script|ScriptAlias)"

if ($CgiExecOption -or $CgiHandlerDirective) {
    $WarnMessage = "Apache에서 CGI 스크립트 실행이 허용되어 있습니다."
    if ($CgiExecOption) { $WarnMessage += " ExecCGI 옵션: $($CgiExecOption.Line)" }
    if ($CgiHandlerDirective) { $WarnMessage += " 핸들러 지시어: $($CgiHandlerDirective.Line)" }
    Write-WARN $WarnMessage
} else {
    Write-OK "Apache에서 CGI 스크립트 실행이 적절하게 제한되어 있습니다."
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output
