# Active Directory account lifecycle — lab prototype

A small PowerShell function for two operations: creating a disabled lab account and disabling an existing lab account. This is a personal prototype, not a complete joiner/leaver workflow.

## Why this project

Account changes need an explicit target, a review step, and a clear limit on scope. This project explores those controls before adding more automation.

## Behavior

| Invocation | Result |
| --- | --- |
| Without `-Apply` | Returns a plan; no AD module or network connection is needed |
| `-Apply -WhatIf` | Reports the intended change without running directory commands |
| `-Apply` | Requests confirmation, checks the lab domain, and performs the selected operation |

The domain must end in `.invalid`. The target OU must start with `OU=Lab,` or `OU=Sandbox,`. Disable also checks that the account is inside that OU. Create leaves the account disabled and assigns no password or group access.

## Try the plan

Run from this repository in PowerShell:

```powershell
. ./scripts/Invoke-LabUserLifecycle.ps1
$lab = @{
    SamAccountName = 'lab.user01'
    Server = 'dc01.lab.invalid'
    LabOU = 'OU=Lab,DC=lab,DC=invalid'
}
Invoke-LabUserLifecycle -Action Create @lab
Invoke-LabUserLifecycle -Action Disable @lab -Apply -WhatIf
./tests/Test-Lifecycle.ps1
```

Real Apply requires Windows, RSAT's ActiveDirectory module, an isolated `.invalid` lab domain, and delegated permissions. `Status=Applied` means the command completed; independently read back account state and test the intended access before treating a change as verified.

## Validation

[Local validation record](docs/validation.md). The tests cover plan-only behavior, WhatIf, rejected input, disabled account creation, scope rejection, and non-lab domain rejection. Directory commands are mocked. No live account has been created or disabled as part of this portfolio.

## Deliberately outside the scope

Password delivery, licensing, group grants, mailboxes, retention, deletion, and Entra ID session revocation are not implemented. [Entra offboarding notes](docs/entra-offboarding.md) are a design checklist only.

Next: build the isolated domain, run one ordinary test account through both operations, and record actual state, errors, and recovery. [Evidence index](evidence/README.md).

[MIT license](LICENSE) · [Security and data handling](SECURITY.md)

## Automated checks

[CI configuration and limits](docs/ci.md) · [Latest workflow runs](https://github.com/Mhtnsr/ad-lifecycle-lab/actions/workflows/checks.yml)

[Recorded passing run — November 7, 2026](docs/ci-results-2026-11-07.md).
