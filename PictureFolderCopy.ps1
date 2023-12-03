# Pfad zum Hauptordner, in den die Bilder und Videos kopiert werden sollen
$Zielverzeichnis = "C:\OFBulk2"

# Pfad zum Ordner, den Sie durchsuchen möchten
$Quellverzeichnis = "C:\OFBulk"

# Array der unterstützten Dateiendungen für Bilder und Videos
$UnterstutzteErweiterungen = @(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tif", ".tiff", ".avi", ".mp4", ".mkv", ".wmv")

# Funktion zum Kopieren von Dateien in das Zielverzeichnis
function Kopiere-Datei($Datei, $Zielverzeichnis) {
    $ZielDatei = Join-Path -Path $Zielverzeichnis -ChildPath $Datei.Name
    Copy-Item $Datei.FullName $ZielDatei
    Write-Host "Kopiere $($Datei.FullName) nach $($ZielDatei)"
}

# Durchsuche das Quellverzeichnis und kopiere Bilder und Videos
Get-ChildItem -Path $Quellverzeichnis -File -Recurse | ForEach-Object {
    $Erweiterung = $_.Extension.ToLower()
    if ($UnterstutzteErweiterungen -contains $Erweiterung) {
        Kopiere-Datei $_ $Zielverzeichnis
    }
}

Write-Host "Die Suche und das Kopieren wurden abgeschlossen."
