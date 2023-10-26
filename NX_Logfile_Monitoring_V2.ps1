# copyright by PLM Baker
#
# 2023
#
#
# This script is for monitoring the NX Logfile



$loggedInUsername = $env:USERNAME
$folderPath = "D:\[path to logfile]"
$fileNamePattern = "$loggedInUsername*.syslog"

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

while ($true) {
    # Get the latest log file
    $latestLogFile = Get-LatestLogFile $folderPath $fileNamePattern

    if (-not $latestLogFile) {
        Write-Host "No log files found with the specified criteria."
        exit
    }

    # Monitor the latest log file
    Write-Host "Monitoring the latest log file: $latestLogFile"
    Get-Content -Path $latestLogFile -Wait

    # Wait for 5 minutes before checking for a new log file
    Start-Sleep -Seconds 300
}
