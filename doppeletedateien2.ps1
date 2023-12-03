# Import der benötigten Module
Import-Module ImportExcel

# Definiere den Pfad zum Netzlaufwerk, das du überprüfen möchtest
$NetzlaufwerkPfad = "Z:\"

# Definiere den Pfad für die Excel-Datei, in der die Ergebnisse gespeichert werden
$ExcelDatei = "C:\DoppelteDateien.xlsx"

# Sammle alle Dateien im Netzlaufwerk
$AlleDateien = Get-ChildItem -Path $NetzlaufwerkPfad -Recurse -File

# Erstelle ein Array, um die Ergebnisse zu speichern
$Ergebnisse = @()

# Erstelle eine Protokolldatei
$ProtokollDatei = "C:\DoppelteDateienProtokoll.txt"

# Durchlaufe alle Dateien und prüfe auf Duplikate
foreach ($Datei in $AlleDateien) {
    Write-Host "Überprüfe Datei: $($Datei.FullName)"
    Add-Content -Path $ProtokollDatei -Value "Überprüfe Datei: $($Datei.FullName)"
    $DateiHash = Get-FileHash -Path $Datei.FullName -Algorithm SHA256
    $Duplikate = $AlleDateien | Where-Object { $_.Name -ne $Datei.Name -and (Get-FileHash -Path $_.FullName -Algorithm SHA256).Hash -eq $DateiHash.Hash }
    foreach ($Duplikat in $Duplikate) {
        $Ergebnis = New-Object PSObject -Property @{
            "OriginalDatei" = $Datei.FullName
            "DuplikatDatei" = $Duplikat.FullName
            "Datum" = $Datei.LastWriteTime
            "Größe" = $Datei.Length
        }
        $Ergebnisse += $Ergebnis
    }
}

# Exportiere die Ergebnisse in eine Excel-Datei
$Ergebnisse | Export-Excel -Path $ExcelDatei -AutoSize -WorksheetName "DoppelteDateien" -Show

# Zeige eine Abschlussmeldung
Write-Host "Skript abgeschlossen. Ergebnisse wurden in $ExcelDatei gespeichert."

# Füge eine Abschlussmeldung zum Protokoll hinzu
Add-Content -Path $ProtokollDatei -Value "Skript abgeschlossen. Ergebnisse wurden in $ExcelDatei gespeichert."
