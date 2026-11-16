<#
.SYNOPSIS
    Crea la cartella della mod pronta all'uso e, opzionalmente, la installa nel gioco.

.DESCRIPTION
    Copia ModInfo.json, Preview.png e la cartella Data in dist\<NomeCartella>.
    Prima di copiare verifica che tutti i file JSON siano validi.

.PARAMETER Install
    Copia la mod anche nella cartella Mods del gioco:
    Documenti\Foxy Voxel\Going Medieval\Mods

.PARAMETER Zip
    Crea anche dist\<NomeCartella>.zip.

.PARAMETER FolderName
    Nome della cartella della mod. Predefinito: StoneCutterOutput.

.PARAMETER ModsPath
    Percorso alternativo della cartella Mods del gioco.

.EXAMPLE
    .\build.ps1
    .\build.ps1 -Install
    .\build.ps1 -Install -Zip
#>
[CmdletBinding()]
param(
    [switch]$Install,
    [switch]$Zip,
    [string]$FolderName = 'StoneCutterOutput',
    [string]$ModsPath = (Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Foxy Voxel\Going Medieval\Mods')
)

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$items = @('ModInfo.json', 'Preview.png', 'Data')

# Controllo file richiesti
foreach ($item in $items) {
    if (-not (Test-Path (Join-Path $root $item))) {
        throw "File o cartella mancante: $item"
    }
}

# Validazione JSON
$jsonFiles = @(Get-Item (Join-Path $root 'ModInfo.json')) +
             @(Get-ChildItem (Join-Path $root 'Data') -Recurse -Filter '*.json')
foreach ($file in $jsonFiles) {
    try {
        Get-Content $file.FullName -Raw -Encoding UTF8 | ConvertFrom-Json | Out-Null
    } catch {
        throw "JSON non valido in $($file.FullName): $($_.Exception.Message)"
    }
}
$modInfo = Get-Content (Join-Path $root 'ModInfo.json') -Raw -Encoding UTF8 | ConvertFrom-Json
Write-Host "Mod: $($modInfo.name) v$($modInfo.modVersion) ($($jsonFiles.Count) file JSON validi)"

function Copy-Mod([string]$destination) {
    if (Test-Path $destination) {
        Remove-Item $destination -Recurse -Force
    }
    New-Item -ItemType Directory -Path $destination -Force | Out-Null
    foreach ($item in $items) {
        Copy-Item (Join-Path $root $item) -Destination $destination -Recurse -Force
    }
}

# Build in dist\
$distDir = Join-Path $root 'dist'
$buildDir = Join-Path $distDir $FolderName
Copy-Mod $buildDir
Write-Host "Cartella creata: $buildDir"

if ($Zip) {
    $zipPath = Join-Path $distDir "$FolderName.zip"
    if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
    Compress-Archive -Path $buildDir -DestinationPath $zipPath
    Write-Host "Archivio creato: $zipPath"
}

if ($Install) {
    if (-not (Test-Path $ModsPath)) {
        throw "Cartella Mods del gioco non trovata: $ModsPath (avvia il gioco almeno una volta o usa -ModsPath)"
    }
    $target = Join-Path $ModsPath $FolderName
    Copy-Mod $target
    Write-Host "Mod installata in: $target"
}
