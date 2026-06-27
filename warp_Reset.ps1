<#
.SYNOPSIS
    Resets the Cloudflare WARP service with logging and IP tracking.
#>

param (
    [string]$ServiceName = "CloudflareWARP",
    [string]$BaseDir = "C:\WARP-Reset",
    [string]$LogDir = "C:\WARP-Reset\Logs"
)

# 1. Setup Environment
if (!(Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

$logFile     = Join-Path $LogDir "warp_reset.log"
$ipLogFile   = Join-Path $LogDir "IPLog.txt"
$lastRunFile = Join-Path $LogDir "LastRun.txt"

# Display last triggered time if it exists
if (Test-Path $lastRunFile) {
    $lastTime = Get-Content $lastRunFile
    Write-Host "Last successful reset was at: $lastTime" -ForegroundColor Gray
}

function Write-Log {
    param([string]$message)
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$stamp] $message" | Out-File -FilePath $logFile -Append
}

function Get-PublicIP {
    try {
        return (Invoke-RestMethod -Uri "https://ifconfig.me" -TimeoutSec 5).Trim()
    } catch {
        return "Offline/Unknown"
    }
}

# 2. Execution
Write-Host "Starting WARP reset sequence..." -ForegroundColor Cyan

if (-not (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue)) {
    Write-Error "Service $ServiceName not found."
    exit 1
}

$oldIP = Get-PublicIP
Write-Log "Initiating reset. Previous IP: $oldIP"

try {
    Stop-Service -Name $ServiceName -Force -ErrorAction Stop
    
    $timeout = 10
    $elapsed = 0
    while ((Get-Service -Name $ServiceName).Status -ne 'Stopped' -and $elapsed -lt $timeout) {
        Start-Sleep -Seconds 1
        $elapsed++
    }

    if ((Get-Service -Name $ServiceName).Status -eq 'Stopped') {
        Write-Log "Service stopped."
        Start-Service -Name $ServiceName -ErrorAction Stop
        Start-Sleep -Seconds 5
        
        $newIP = Get-PublicIP
        $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        
        # Log to main files
        Write-Log "Service restarted. New IP: $newIP"
        "$now - $newIP" | Out-File -FilePath $ipLogFile -Append
        
        # Update LastRun file
        $now | Out-File -FilePath $lastRunFile
        
        Write-Host "Success! New IP: $newIP" -ForegroundColor Green
    } else {
        throw "Service failed to stop within $timeout seconds."
    }
} catch {
    Write-Log "ERROR: $($_.Exception.Message)"
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}