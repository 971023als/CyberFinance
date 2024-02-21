# Create a log file
$TMP1 = "{0}.log" -f $MyInvocation.MyCommand.Name
$TMP1 = Join-Path $env:TEMP $TMP1
"" > $TMP1

# Header for the log file
Add-Content $TMP1 "CODE [SRV-044] Web Service File Upload and Download Size Limit Not Set"
Add-Content $TMP1 "[Good]: File upload and download size is appropriately limited in the web service"
Add-Content $TMP1 "[Vulnerable]: File upload and download size is not limited in the web service"
Add-Content $TMP1 "---------------------------------------------------------"

# Check IIS for file upload size limits
Import-Module WebAdministration

# Iterate through all sites
Get-Website | ForEach-Object {
    $siteName = $_.Name
    $configPath = "IIS:\Sites\$siteName"
    $requestFiltering = Get-WebConfigurationProperty -pspath $configPath -filter "system.webServer/security/requestFiltering/requestLimits" -name "maxAllowedContentLength"
    
    $maxSize = $requestFiltering.Value / 1024 / 1024 # Convert from bytes to MB
    if ($maxSize -lt 30) { # Example threshold of 30 MB
        Add-Content $TMP1 "OK: `$siteName` limits file uploads to $maxSize MB."
    } else {
        Add-Content $TMP1 "WARN: `$siteName` has a high file upload limit ($maxSize MB) or it's not set."
    }
}

# Display the results
Get-Content $TMP1 | Out-Host
