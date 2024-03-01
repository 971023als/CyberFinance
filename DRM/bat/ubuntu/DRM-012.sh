# Define helper functions
function Write-Bar {
    Write-Host "============================================"
}

function Write-Code {
    param($code)
    Write-Host "CODE [$code]"
}

function Warn {
    param($message)
    Write-Host "WARNING: $message"
}

function OK {
    param($message)
    Write-Host "OK: $message"
}

# Start of the script
Write-Bar
Write-Code "DBM-012] Listener Control Utility(lsnrctl) 보안 설정 미흡"

# Request user input for the location of the Listener configuration file
$listener_ora = Read-Host "Listener configuration file (listener.ora)의 경로를 입력하세요"

# Check if the listener.ora file exists
if (Test-Path $listener_ora) {
    # Check for security settings like ADMIN_RESTRICTIONS_LISTENER=ON
    $content = Get-Content $listener_ora
    if ($content -match "ADMIN_RESTRICTIONS_LISTENER=ON") {
        OK "Listener Control Utility 보안 설정이 적절히 적용되었습니다."
    } else {
        Warn "Listener Control Utility에 ADMIN_RESTRICTIONS_LISTENER 설정이 적용되지 않았습니다."
    }
} else {
    Warn "Listener configuration file이 존재하지 않습니다."
}

Write-Bar
