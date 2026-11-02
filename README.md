# Ad Lifecycle Lab

Plan-first Active Directory lifecycle automation scoped to an explicit lab OU.

**Owner:** [Mahamat Nassour Ahmat](https://github.com/Mhtnsr) · IT Support Specialist → Systems Administrator

## Problem

Unreviewed account changes can affect the wrong directory or user.

## Solution

A dry-run-first PowerShell function with explicit server/OU, input validation, confirmation, and .invalid-domain scope. Create produces a disabled account; Disable checks OU membership before disabling. Entra ID offboarding is a separate design checklist, not implemented cloud automation.

## Usage

Run from the repository root. Use an isolated, authorized environment and inspect source before execution.

```powershell
. ./scripts/Invoke-LabUserLifecycle.ps1
Invoke-LabUserLifecycle -Action Create -SamAccountName lab.user01 -Server dc01.lab.invalid -LabOU 'OU=Lab,DC=lab,DC=invalid'
# Preview explicit apply (no change):
Invoke-LabUserLifecycle -Action Disable -SamAccountName lab.user01 -Server dc01.lab.invalid -LabOU 'OU=Lab,DC=lab,DC=invalid' -Apply -WhatIf
# Only in your isolated .invalid lab, after reviewing the plan:
# Invoke-LabUserLifecycle ... -Apply  # prompts for confirmation
./tests/Test-Lifecycle.ps1
```

## Validation and limits

Five local plan/validation checks passed; real Active Directory mutation is not lab-validated. Requires Windows RSAT/ActiveDirectory module and delegated lab permissions for Apply. No passwords, group grants, deletions, mailbox actions, or Entra session revocation are implemented.

## Screenshots and evidence

[Evidence checklist](evidence/README.md). Placeholder: add a sanitized capture of the actual execution or lab result here after validation. No screenshots or outcomes are fabricated.

<!-- Example after creating the file: ![Sanitized lab result](evidence/lab-result.png) -->

## Repository map

Source belongs in `scripts/`, reproducible checks in `tests/`, synthetic inputs in `examples/`, design notes in `docs/`, reusable records in `templates/`, and sanitized proof in `evidence/`. Only directories relevant to this project are created.

## Next steps

- Capture a reproducible lab run with expected versus observed behavior.
- Document failure cases and recovery or escalation.
- Update validation status only after recording actual results.

## Security

See [SECURITY.md](SECURITY.md). No company data, credentials, internal topology, or live ticket details belong here.

## License

[MIT](LICENSE). A personal learning project; not affiliated with or endorsed by USEReady, Microsoft, CompTIA, or other vendors.
