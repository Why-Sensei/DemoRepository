Clear-Host

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Running this script requires administrative privileges - aborted!"

    Exit
}

$stTypes = @("boot", "system", "auto", "demand", "disabled", "delayed-auto")

Write-Host "Windows Update Medic Service Status Information:"

& sc.exe query WaaSMedicSvc
Get-Service -Name WaaSMedicSvc | Select-Object -Property StartType | ForEach-Object {
    Write-Host $("`t" + $_.PSObject.Properties.Name.ToUpper() + "`t   : " + ($_.($_.PSObject.Properties.Name)).ToString().ToUpper())
}

Write-Host

$choice = Read-Host -Prompt "Change start type (y/n)?"

if ($choice -eq "y") {
    $choice = ""

    do {
        Write-Host "`r`nPlease select a start type:"
        for ($i=0; $i -lt $stTypes.Count; $i++) {
            Write-Host $(($i + 1).ToString() + ") " + $stTypes[$i])
        }
        Write-Host $(($stTypes.Count + 1).ToString() + ") Exit")

        $choice = Read-Host
    } while ($choice -notmatch "[1-$(($stTypes.Count + 1).ToString())]")
} else {
    $choice = ($stTypes.Count + 1).ToString()
}

Write-Host

if ($choice -eq ($stTypes.Count + 1).ToString()) {
    Write-Host "Exiting, no changes made."

    Exit
}

$ret = ((& sc.exe config WaaSMedicSvc start= $stTypes[$choice - 1]) -join "`r`n").Trim()

if ($ret -like "*FEHLER*Zugriff verweigert" -or $ret -like "*ERROR*Access denied") {
    # Can't modify the start type through sc.exe, use alternative method (registry edit) instead
    $regPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc'

    if (!(Test-Path -LiteralPath $regPath)) { New-Item -Path $regPath -Force }
    Set-ItemProperty -Path $regPath -Name "Start" -Value 4 -Type DWord

    Write-Host "Please reboot for the change to take effect."
}