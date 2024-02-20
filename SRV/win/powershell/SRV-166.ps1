# 모든 드라이브의 숨김 파일 및 디렉터리 검색
$drives = Get-PSDrive -PSProvider FileSystem

foreach ($drive in $drives) {
    $hiddenItems = Get-ChildItem -Path $drive.Root -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.Attributes -match "Hidden" }
    
    if ($hiddenItems) {
        Write-Host "드라이브 $($drive.Name)에 다음의 숨김 파일 또는 디렉터리가 존재합니다:"
        foreach ($item in $hiddenItems) {
            Write-Host $item.FullName
        }
    } else {
        Write-Host "드라이브 $($drive.Name)에 불필요한 숨김 파일 또는 디렉터리가 존재하지 않습니다."
    }
}
