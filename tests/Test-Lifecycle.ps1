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
# Mock the directory commands. These tests must never load RSAT or reach a DC.
$script:domainRoot='lab.invalid'
$script:userDn='CN=lab.user01,OU=Lab,DC=lab,DC=invalid'
$script:createCalls=0
$script:disableCalls=0
$script:createEnabled=$true
function Import-Module { [CmdletBinding()]param([string]$Name) }
function Get-ADDomain {
    [CmdletBinding()]param($Server)
    [pscustomobject]@{DNSRoot=$script:domainRoot}
}
function Get-ADOrganizationalUnit {
    [CmdletBinding()]param($Identity,$Server)
    [pscustomobject]@{DistinguishedName=$Identity}
}
function Get-ADUser {
    [CmdletBinding()]param($Identity,$Server)
    [pscustomobject]@{DistinguishedName=$script:userDn}
}
function New-ADUser {
    [CmdletBinding()]param($Name,$SamAccountName,$Path,$Server,[bool]$Enabled)
    $script:createCalls++
    $script:createEnabled=$Enabled
}
function Disable-ADAccount {
    [CmdletBinding()]param($Identity,$Server)
    $script:disableCalls++
}
Check (Invoke-LabUserLifecycle -Action Create @argsLab -Apply -Confirm:$false).Status 'Applied' 'mock create path completes'
Check $script:createCalls 1 'create invoked once'
Check $script:createEnabled $false 'new account remains disabled'
Check (Invoke-LabUserLifecycle -Action Disable @argsLab -Apply -Confirm:$false).Status 'Applied' 'mock disable path completes'
Check $script:disableCalls 1 'disable invoked once'
$script:userDn='CN=other,OU=Production,DC=lab,DC=invalid'
$rejected=$false
try { Invoke-LabUserLifecycle -Action Disable @argsLab -Apply -Confirm:$false | Out-Null } catch {$rejected=$true}
Check $rejected $true 'out-of-scope account rejected'
Check $script:disableCalls 1 'out-of-scope account was not disabled'
$script:domainRoot='example.com'
$rejected=$false
try { Invoke-LabUserLifecycle -Action Create @argsLab -Apply -Confirm:$false | Out-Null } catch {$rejected=$true}
Check $rejected $true 'non-lab domain rejected'
Check $script:createCalls 1 'non-lab domain received no create'
Write-Output "$script:checks checks passed. Directory commands were mocked; no live directory changes."
