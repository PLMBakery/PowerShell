$folderPath = "D:\MDTEMP\TC\z004rxsw\Teamcenter\RAC-4T\TC13\"
$fileNamePattern = "z004rxsw*.log"

# Function to get the latest log file
function Get-LatestLogFile {
    param (
        [string]$folderPath,
        [string]$fileNamePattern
    )

    # Get all log files with the specified criteria
    $logFiles = Get-ChildItem -Path $folderPath -Filter $fileNamePattern | Sort-Object LastWriteTime -Descending

    if ($logFiles.Count -gt 0) {
        return $logFiles[0].FullName
    }
    
    return $null
}

# Get the latest log file
$latestLogFile = Get-LatestLogFile $folderPath $fileNamePattern

if (-not $latestLogFile) {
    Write-Host "No log files found with the specified criteria."
    exit
}

# Monitor the latest log file
Write-Host "Monitoring the latest log file: $latestLogFile"
Get-Content -Path $latestLogFile -Wait
