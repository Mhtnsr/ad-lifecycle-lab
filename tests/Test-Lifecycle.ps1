$ErrorActionPreference='Stop'
. "$PSScriptRoot/../scripts/Invoke-LabUserLifecycle.ps1"
$script:checks=0
function Check($actual,$expected,$label) {
    if ($actual -cne $expected) { throw "FAIL: $label" }
    $script:checks++; Write-Output "PASS: $label"
}
$argsLab=@{SamAccountName='lab.user01';Server='dc01.lab.invalid';LabOU='OU=Lab,DC=lab,DC=invalid'}
Check (Invoke-LabUserLifecycle -Action Create @argsLab).Status 'Planned' 'create is plan-only'
Check (Invoke-LabUserLifecycle -Action Disable @argsLab).Status 'Planned' 'disable is plan-only'
Check (Invoke-LabUserLifecycle -Action Create @argsLab -Apply -WhatIf).Status 'NotApplied' 'WhatIf blocks apply'
foreach ($case in @('BadName','BadOU')) {
    $bad=$argsLab.Clone()
    if ($case -eq 'BadName') {$bad.SamAccountName='bad;name'} else {$bad.LabOU='OU=Production,DC=example,DC=com'}
    $rejected=$false
    try { Invoke-LabUserLifecycle -Action Create @bad | Out-Null } catch {$rejected=$true}
    Check $rejected $true "$case rejected"
}
Write-Output "$script:checks checks passed. Directory mutation was not exercised."
