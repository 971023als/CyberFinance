# 결과 파일 경로 설정
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_AnonymousSIDNameTranslationCheck.log"

# 결과 파일에 헤더 추가
"익명 SID/이름 변환 허용 정책 확인" | Out-File -FilePath $TMP1
"====================================" | Out-File -FilePath $TMP1 -Append

# 보안 정책 설정 확인을 위한 준비
$secpolExportPath = "secpol_export.cfg"
secedit /export /cfg $secpolExportPath

# 파일 내용 검색
$secpolContent = Get-Content $secpolExportPath
$anonymousNameTranslationPolicy = $secpolContent | Where-Object { $_ -match "SeDenyNetworkLogonRight\s*=\s*S-1-1-0" }

# 정책 확인
if ($anonymousNameTranslationPolicy) {
    "익명 SID/이름 변환을 허용하지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "익명 SID/이름 변환을 허용합니다." | Out-File -FilePath $TMP1 -Append
}

# 임시 파일 제거
Remove-Item $secpolExportPath -Force

# 결과 파일 내용 출력
Get-Content -Path $TMP1 | Write-Output

# 추가 안내 메시지
"`n추가 확인이 필요한 경우, secpol.msc 또는 그룹 정책 편집기(GPEDIT.MSC)를 통해 '보안 설정 > 로컬 정책 > 사용자 권한 할당'에서 정책을 확인하세요." | Out-File -FilePath $TMP1 -Append
