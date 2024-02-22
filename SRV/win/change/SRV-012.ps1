# 결과 파일 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Set-Content $TMP1

Function BAR {
    "--------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR

"CODE [SRV-012] .netrc 파일 내 중요 정보 노출" | Out-File -FilePath $TMP1 -Append

@"
[양호]: 시스템 전체에서 .netrc 파일이 존재하지 않는 경우
[취약]: 시스템 전체에서 .netrc 파일이 존재하는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# 시스템 전체에서 .netrc 파일 찾기
$netrcFiles = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue -Filter ".netrc" -Force

if ($netrcFiles.Count -eq 0) {
    "OK: 시스템에 .netrc 파일이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "WARN: 다음 위치에 .netrc 파일이 존재합니다:" | Out-File -FilePath $TMP1 -Append
    # .netrc 파일의 권한 확인 및 출력
    foreach ($file in $netrcFiles) {
        $permissions = (Get-Acl $file.FullName).Access | ForEach-Object { $_.FileSystemRights }
        "파일 위치: $($file.FullName)" | Out-File -FilePath $TMP1 -Append
        "권한 확인: $permissions" | Out-File -FilePath $TMP1 -Append
    }
}

BAR

Get-Content $TMP1 | Write-Output
Write-Host `n
