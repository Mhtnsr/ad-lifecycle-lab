function Invoke-LabUserLifecycle {
    <# Lab AD only. Dry-run returns a plan without loading AD or connecting.
       -Apply requests a change; -WhatIf and -Confirm are supported.
       Create makes a disabled account with no password. Disable only disables.
       Entra sessions, licenses, mailboxes, and retention are separate workflows. #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory)][ValidateSet('Create','Disable')][string]$Action,
        [Parameter(Mandatory)][ValidatePattern('^[a-zA-Z][a-zA-Z0-9._-]{0,19}$')][string]$SamAccountName,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Server,
        [Parameter(Mandatory)][ValidatePattern('(?i)^OU=(Lab|Sandbox),')][string]$LabOU,
        [switch]$Apply
    )
    $plan = [pscustomobject]@{ Action=$Action; Account=$SamAccountName; Server=$Server; OU=$LabOU; Status='Planned' }
    if (-not $Apply) { return $plan }
    if (-not $PSCmdlet.ShouldProcess("$SamAccountName on $Server in $LabOU", $Action)) {
        $plan.Status='NotApplied'; return $plan
    }
    Import-Module ActiveDirectory -ErrorAction Stop
    $domain = Get-ADDomain -Server $Server -ErrorAction Stop
    if ($domain.DNSRoot -notlike '*.invalid') { throw 'Only .invalid lab domains are permitted.' }
    $ou = Get-ADOrganizationalUnit -Identity $LabOU -Server $Server -ErrorAction Stop
    if ($Action -eq 'Create') {
        New-ADUser -Name $SamAccountName -SamAccountName $SamAccountName `
            -Path $ou.DistinguishedName -Server $Server -Enabled $false -ErrorAction Stop
    } else {
        $user = Get-ADUser -Identity $SamAccountName -Server $Server -ErrorAction Stop
        if (-not $user.DistinguishedName.EndsWith(',' + $ou.DistinguishedName, [StringComparison]::OrdinalIgnoreCase)) {
            throw 'Account is outside the approved lab OU.'
        }
        Disable-ADAccount -Identity $user.DistinguishedName -Server $Server -ErrorAction Stop
    }
    $plan.Status='Applied'
    return $plan
}
