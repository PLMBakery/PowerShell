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

# Bestimme die Gesamtzahl der Dateien, die überprüft werden
$GesamtzahlDerDateien = $AlleDateien.Count

# Durchlaufe alle Dateien und prüfe auf Duplikate
foreach ($Index in 0..($GesamtzahlDerDateien - 1)) {
    $Datei = $AlleDateien[$Index]
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
    
    # Berechne den Fortschritt und zeige die Laufzeit an
    $Fortschritt = ($Index + 1) / $GesamtzahlDerDateien * 100
    $VerbleibendeZeit = (Measure-Command { $Index..($GesamtzahlDerDateien - 1) | ForEach-Object { } }).TotalSeconds * (100 - $Fortschritt) / $Fortschritt
    Write-Host "Fortschritt: $Fortschritt% - Verbleibende Zeit: $($VerbleibendeZeit.ToString("N2")) Sekunden"
}

# Exportiere die Ergebnisse in eine Excel-Datei
$Ergebnisse | Export-Excel -Path $ExcelDatei -AutoSize -WorksheetName "DoppelteDateien" -Show

# Zeige eine Abschlussmeldung
Write-Host "Skript abgeschlossen. Ergebnisse wurden in $ExcelDatei gespeichert."
