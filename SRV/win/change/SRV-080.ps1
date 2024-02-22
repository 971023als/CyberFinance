$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
Clear-Content -Path $TMP1

Add-Content -Path $TMP1 -Value "일반 사용자에 의한 프린터 드라이버 설치 제한 상태 확인"

# Group Policy 결과를 파일로 출력
$gpResultFile = "$(Get-Location)\gpresult.html"
gpresult /H $gpResultFile

# gpresult.html 파일에서 "Point and Print Restrictions" 정책을 검사
$gpResultContent = Get-Content -Path $gpResultFile
$pointAndPrintRestrictions = $gpResultContent -join "" | Select-String -Pattern "Point and Print Restrictions" -SimpleMatch

if ($pointAndPrintRestrictions) {
    Add-Content -Path $TMP1 -Value "OK: 'Point and Print Restrictions' 정책이 구성되어 있습니다."
} else {
    Add-Content -Path $TMP1 -Value "WARN: 'Point and Print Restrictions' 정책이 구성되어 있지 않습니다."
}

Remove-Item -Path $gpResultFile -ErrorAction SilentlyContinue

Get-Content -Path $TMP1
