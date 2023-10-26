# Copyright by PLM Baler erstellt 2023

function Get-Message ($key, $language) {
    $messages = @{
        "QuellordnerErreichbar" = @{
            "DE" = "Quellordner ist erreichbar."
            "EN" = "Source folder is reachable."
            "IT" = "La cartella di origine è raggiungibile."
            "ES" = "La carpeta de origen está accesible."
            "FR" = "Le dossier source est accessible."
        }
        "QuellordnerNichtErreichbar" = @{
            "DE" = "Quellordner ist nicht erreichbar."
            "EN" = "Source folder is not reachable."
            "IT" = "La cartella di origine non è raggiungibile."
            "ES" = "La carpeta de origen no es accesible."
            "FR" = "Le dossier source n'est pas accessible."
        }
        "ZielordnerErreichbar" = @{
            "DE" = "Zielordner ist erreichbar."
            "EN" = "Target folder is reachable."
            "IT" = "La cartella di destinazione è raggiungibile."
            "ES" = "La carpeta de destino está accesible."
            "FR" = "Le dossier cible est accessible."
        }
        "ZielordnerNichtErreichbar" = @{
            "DE" = "Zielordner ist nicht erreichbar."
            "EN" = "Target folder is not reachable."
            "IT" = "La cartella di destinazione non è raggiungibile."
            "ES" = "La carpeta de destino no es accesible."
            "FR" = "Le dossier cible n'est pas accessible."
        }
        "PressAnyKeyToExit" = @{
            "DE" = "Drücken Sie eine Taste, um das Skript zu beenden."
            "EN" = "Press any key to exit."
            "IT" = "Premere un tasto per terminare lo script."
            "ES" = "Presione una tecla para salir."
            "FR" = "Appuyez sur une touche pour quitter."
        }
        "PressAnyKeyToRetry" = @{
            "DE" = "Drücken Sie eine Taste, um es erneut zu versuchen."
            "EN" = "Press any key to retry."
            "IT" = "Premere un tasto per riprovare."
            "ES" = "Presione una tecla para intentarlo de nuevo."
            "FR" = "Appuyez sur une touche pour réessayer."
        }
    }
    
    return $messages[$key][$language]
}

$language = Read-Host "Bitte wählen Sie Ihre Sprache / Please select your language / Si prega di selezionare la lingua / Por favor, seleccione su idioma / Veuillez sélectionner votre langue (DE/EN/IT/ES/FR)"

$quelle = "\\192.168.178.50\SeagateWhite"
$ziel = "\\192.168.178.50\Black1"
$logDatei = Join-Path $PSScriptRoot "kopieren.log"

# Überprüfen, ob die Netzwerkordner erreichbar sind
if (Test-Path -Path $quelle) {
    Write-Host (Get-Message "QuellordnerErreichbar" $language)
} else {
    Write-Error (Get-Message "QuellordnerNichtErreichbar" $language)
    Read-Host (Get-Message "PressAnyKeyToExit" $language)
    return
}

if (Test-Path -Path $ziel) {
    Write-Host (Get-Message "ZielordnerErreichbar" $language)
} else {
    Write-Error (Get-Message "ZielordnerNichtErreichbar" $language)
    Read-Host (Get-Message "PressAnyKeyToExit" $language)
    return
}

# Netzlaufwerke verbinden (optional)
#New-PSDrive -Name "Q" -PSProvider FileSystem -Root $quelle -Persist
#New-PSDrive -Name "Z" -PSProvider FileSystem -Root $ziel -Persist

# Dateien kopieren
Get-ChildItem -Path $quelle -Recurse | ForEach-Object {
    $zielPfad = $_.FullName.Replace($quelle, $ziel)
    $fehlerAufgetreten = $false
    
    do {
        try {
            if (Test-Path -Path $zielPfad) {
                $zielDatei = Get-Item -Path $zielPfad
                if ($_.LastWriteTime -gt $zielDatei.LastWriteTime) {
                    Copy-Item -Path $_.FullName -Destination $zielPfad -Force
                    Write-Host "Kopiert: $($_.FullName) -> $zielPfad"
                    Add-Content -Path $logDatei -Value "Kopiert: $($_.FullName) -> $zielPfad"
                }
            } else {
                Copy-Item -Path $_.FullName -Destination $zielPfad
                Write-Host "Kopiert: $($_.FullName) -> $zielPfad"
                Add-Content -Path $logDatei -Value "Kopiert: $($_.FullName) -> $zielPfad"
            }
            
            $fehlerAufgetreten = $false
        } catch {
            Write-Host "Fehler beim Kopieren von $($_.FullName) -> $zielPfad" -ForegroundColor Red
            $fehlerAufgetreten = $true
            Read-Host (Get-Message "PressAnyKeyToRetry" $language)
        }
    } while ($fehlerAufgetreten)
}
