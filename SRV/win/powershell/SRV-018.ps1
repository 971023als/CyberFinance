# 결과 파일 초기화
$TMP1 = "$(Split-Path -Leaf $MyInvocation.MyCommand.Definition).log"
"" | Set-Content $TMP1

Function BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function CODE {
    Param ([string]$message)
    $message | Out-File -FilePath $TMP1 -Append
}

Function WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Function OK {
    Param ([string]$message)
    "OK: $message" | Out-File -FilePath $TMP1 -Append
}

Function INFO {
    Param ([string]$message)
    "INFO: $message" | Out-File -FilePath $TMP1 -Append
}

BAR

CODE "[SRV-018] 불필요한 하드디스크 기본 공유 활성화"

@"
[양호]: NFS 또는 SMB/CIFS의 불필요한 하드디스크 공유가 비활성화된 경우
[취약]: NFS 또는 SMB/CIFS에서 불필요한 하드디스크 기본 공유가 활성화된 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# NFS와 SMB/CIFS 설정 파일을 확인합니다.
$NFS_EXPORTS_FILE = "/etc/exports"
$SMB_CONF_FILE = "/etc/samba/smb.conf"

Function Check-ShareActivation {
    Param (
        [string]$file,
        [string]$serviceName
    )

    If (Test-Path $file) {
        $content = Get-Content $file
        If ($content -match "^\s*/") {
            WARN "$serviceName 서비스에서 불필요한 공유가 활성화되어 있습니다: $file"
        } Else {
            OK "$serviceName 서비스에서 불필요한 공유가 비활성화되어 있습니다: $file"
        }
    } Else {
        INFO "$serviceName 서비스 설정 파일($file)을 찾을 수 없습니다."
    }
}

Check-ShareActivation -file $NFS_EXPORTS_FILE -serviceName "NFS"
Check-ShareActivation -file $SMB_CONF_FILE -serviceName "SMB/CIFS"

Get-Content $TMP1 | Write-Output
Write-Host
