<#
.SYNOPSIS
    Publica e instala/actualiza la extension ZUMMO en un servidor BC14 on-premise.

.DESCRIPTION
    - Toma la version de app.json y el .app compilado correspondiente (salvo que se pase -AppPath).
    - Desinstala las apps instaladas que dependen de ZUMMO (p. ej. "Zummo Ext WARRANTY"), conservando sus datos.
    - Publish + Sync + DataUpgrade (o Install si ZUMMO no estaba instalada).
    - Reinstala las dependientes, tambien si algo falla por el camino.
    Requiere PowerShell como administrador. Si el servidor rechaza la compilacion por objetos sin simbolos,
    generarlos antes con: finsql.exe Command=generatesymbolreference, ServerName=..., Database=...

.EXAMPLE
    .\scripts\Deploy-Zummo.ps1
    .\scripts\Deploy-Zummo.ps1 -ServerInstance BC140 -UnpublishOld
#>
param(
    [string]$ServerInstance = 'BC140',
    [string]$AppPath,
    [string]$Tenant = 'default',
    [string]$NavAdminTool = 'C:\Program Files\Microsoft Dynamics 365 Business Central\140\Service\NavAdminTool.ps1',
    [switch]$UnpublishOld
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent

$manifest = Get-Content (Join-Path $root 'app.json') -Raw | ConvertFrom-Json
$appName = $manifest.name
$newVersion = [version]$manifest.version
if (-not $AppPath) {
    $AppPath = Join-Path $root ('{0}_{1}_{2}.app' -f $manifest.publisher, $manifest.name, $manifest.version)
}
if (-not (Test-Path $AppPath)) { throw "No existe el paquete '$AppPath'. Compila primero (Ctrl+Shift+B)." }

if (-not (Get-Command Publish-NAVApp -ErrorAction SilentlyContinue)) { & $NavAdminTool | Out-Null }

function Get-InstalledApps {
    Get-NAVAppInfo -ServerInstance $ServerInstance -Tenant $Tenant -TenantSpecificProperties |
        Where-Object { $_.IsInstalled }
}

# Apps instaladas que dependen (directa o indirectamente) de $Id, ordenadas para desinstalar
function Get-Dependents([guid]$Id, $Installed) {
    $result = @()
    foreach ($app in $Installed) {
        $info = Get-NAVAppInfo -ServerInstance $ServerInstance -Name $app.Name -Publisher $app.Publisher -Version $app.Version
        if ($info.Dependencies | Where-Object { [guid]$_.AppId -eq $Id }) {
            $result += Get-Dependents $app.AppId $Installed
            $result += $app
        }
    }
    $result
}

Write-Host "Servidor: $ServerInstance | $appName $newVersion | $AppPath" -ForegroundColor Cyan

$installed = @(Get-InstalledApps)
$current = $installed | Where-Object { $_.AppId -eq [guid]$manifest.id }
if ($current -and [version]$current.Version -ge $newVersion) {
    Write-Host "Ya esta instalada la version $($current.Version). Nada que hacer." -ForegroundColor Yellow
    return
}

$dependents = @()
if ($current) {
    # Sin duplicados, conservando el orden de desinstalacion
    $seen = @{}
    $dependents = @(Get-Dependents $current.AppId $installed | Where-Object { -not $seen[$_.AppId]; $seen[$_.AppId] = $true })
}

try {
    foreach ($dep in $dependents) {
        Write-Host "Desinstalando dependiente $($dep.Name) $($dep.Version)..."
        Uninstall-NAVApp -ServerInstance $ServerInstance -Tenant $Tenant -Name $dep.Name -Publisher $dep.Publisher -Version $dep.Version
    }

    $published = Get-NAVAppInfo -ServerInstance $ServerInstance -Name $appName -Publisher $manifest.publisher -Version $newVersion
    if (-not $published) {
        Write-Host "Publicando $appName $newVersion..."
        Publish-NAVApp -ServerInstance $ServerInstance -Path $AppPath -SkipVerification
    }

    Write-Host "Sincronizando..."
    Sync-NAVApp -ServerInstance $ServerInstance -Tenant $Tenant -Name $appName -Publisher $manifest.publisher -Version $newVersion

    if ($current) {
        Write-Host "Actualizando datos desde $($current.Version)..."
        Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Tenant $Tenant -Name $appName -Publisher $manifest.publisher -Version $newVersion
    } else {
        Write-Host "Instalando..."
        Install-NAVApp -ServerInstance $ServerInstance -Tenant $Tenant -Name $appName -Publisher $manifest.publisher -Version $newVersion
    }
}
finally {
    # Reinstalar en orden inverso al de desinstalacion (primero las mas basicas)
    [array]::Reverse($dependents)
    $nowInstalled = @(Get-InstalledApps)
    foreach ($dep in $dependents) {
        if (-not ($nowInstalled | Where-Object { $_.AppId -eq $dep.AppId })) {
            Write-Host "Reinstalando dependiente $($dep.Name) $($dep.Version)..."
            Install-NAVApp -ServerInstance $ServerInstance -Tenant $Tenant -Name $dep.Name -Publisher $dep.Publisher -Version $dep.Version
        }
    }
}

if ($UnpublishOld) {
    Get-NAVAppInfo -ServerInstance $ServerInstance -Name $appName -Publisher $manifest.publisher |
        Where-Object { [version]$_.Version -lt $newVersion } |
        ForEach-Object {
            Write-Host "Despublicando $appName $($_.Version)..."
            Unpublish-NAVApp -ServerInstance $ServerInstance -Name $appName -Publisher $manifest.publisher -Version $_.Version
        }
}

Write-Host "`nEstado final:" -ForegroundColor Green
Get-NAVAppInfo -ServerInstance $ServerInstance -Tenant $Tenant -TenantSpecificProperties |
    Where-Object { $_.Name -eq $appName -or $dependents.AppId -contains $_.AppId } |
    Format-Table Name, Version, IsInstalled -AutoSize
