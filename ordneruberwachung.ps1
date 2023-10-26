#Script zur Orderüberwachung wann und ob sich was an einem Ordner verändert
# Falls die Skript ausführung in der Powershell nicht erlaubt ist oder blockiert kann mit der PowerShell mit diesem 
# Befehl das ausführen erlaubt werden Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
#
#
# by PLM Baker
#
# 2023

$folder = 'C:\Test' # Bitte ändere diesen Pfad zum gewünschten Ordner.
$filter = '*.*' # Überwache alle Dateitypen

$watcher = New-Object IO.FileSystemWatcher $folder, $filter -Property @{
    IncludeSubdirectories = $false # Wenn du Unterverzeichnisse auch überwachen möchtest, ändere dies auf $true
    NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite, Size'
}

function DisplayMessage {
    param ([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host ("$timestamp >>> $message" + "`n" + ("-" * 80)) -BackgroundColor Yellow -ForegroundColor Black
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

$onChanged = Register-ObjectEvent $watcher 'Changed' -Action {
    $path = $Event.SourceEventArgs.FullPath
    $fileInfo = Get-Item $path
    
    $message = "Änderung an Datei: $path `n"
    $message += "Größe: $($fileInfo.Length) Bytes `n"
    $message += "Datum: $($fileInfo.LastWriteTime)"

    DisplayMessage $message
}

$onCreated = Register-ObjectEvent $watcher 'Created' -Action {
    $path = $Event.SourceEventArgs.FullPath
    $fileInfo = Get-Item $path
    
    $message = "Neue Datei hinzugefügt: $path `n"
    $message += "Größe: $($fileInfo.Length) Bytes `n"
    $message += "Datum: $($fileInfo.LastWriteTime)"

    DisplayMessage $message
}

$onDeleted = Register-ObjectEvent $watcher 'Deleted' -Action {
    $path = $Event.SourceEventArgs.FullPath
    DisplayMessage "Datei entfernt: $path"
}

$onRenamed = Register-ObjectEvent $watcher 'Renamed' -Action {
    $oldPath = $Event.SourceEventArgs.OldFullPath
    $newPath = $Event.SourceEventArgs.FullPath
    DisplayMessage "Datei umbenannt von $oldPath zu $newPath"
}

while ($true) {
    # Halte das Skript am Laufen
    Start-Sleep -Seconds 10
}

