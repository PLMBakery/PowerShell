# Copyright by PLM Baler erstellt 2023

$ErrorActionPreference = "Stop"

$quelle = "\\192.168.178.50\SeagateWhite"
$ziel = "\\192.168.178.50\Black1"
$logDatei = Join-Path (Get-Location) "KopierLog.txt"

# Überprüfen, ob die Netzwerkordner erreichbar sind
if (-Not (Test-Path -Path $quelle)) {
    Write-Error "Quellordner ist nicht erreichbar."
    Read-Host "Drücken Sie eine Taste, um das Skript zu beenden."
    return
} else {
    Write-Output "Quellordner ist erreichbar." | Out-File -Append -FilePath $logDatei
}

if (-Not (Test-Path -Path $ziel)) {
    Write-Error "Zielordner ist nicht erreichbar."
    Read-Host "Drücken Sie eine Taste, um das Skript zu beenden."
    return
} else {
    Write-Output "Zielordner ist erreichbar." | Out-File -Append -FilePath $logDatei
}

# Dateien kopieren
$files = Get-ChildItem -Path $quelle -Recurse

# Überprüfen, ob Dateien zum Kopieren gefunden wurden
$totalFiles = $files.Count
Write-Host "Anzahl Dateien zum Kopieren: $totalFiles"

# Fortschrittsanzeige initialisieren
$progress = 0

$files | ForEach-Object {
    $zielPfad = $_.FullName.Replace($quelle, $ziel)
    $fehlerAufgetreten = $false
    
    do {
        try {
            if (Test-Path -Path $zielPfad) {
                $zielDatei = Get-Item -Path $zielPfad
                if ($_.LastWriteTime -gt $zielDatei.LastWriteTime) {
                    Copy-Item -Path $_.FullName -Destination $zielPfad -Force
                    Write-Output "Kopiert: $($_.FullName) -> $zielPfad" | Out-File -Append -FilePath $logDatei
                }
            } else {
                Copy-Item -Path $_.FullName -Destination $zielPfad
                Write-Output "Kopiert: $($_.FullName) -> $zielPfad" | Out-File -Append -FilePath $logDatei
            }
            
            $fehlerAufgetreten = $false
        } catch {
            Write-Host "Fehler beim Kopieren von $($_.FullName) -> $zielPfad" -ForegroundColor Red
            $fehlerAufgetreten = $true
            Read-Host "Drücken Sie eine Taste, um es erneut zu versuchen."
        }
    } while ($fehlerAufgetreten)
    
    # Fortschrittsanzeige aktualisieren
    $progress++
    Write-Progress -Activity "Kopiere Dateien..." -Status "$progress von $totalFiles Dateien kopiert" -PercentComplete (($progress / $totalFiles) * 100)
}

# Abschlussmeldung
Write-Host "Kopieren abgeschlossen!" -ForegroundColor Green
Read-Host "Drücken Sie eine Taste, um das Skript zu beenden."
