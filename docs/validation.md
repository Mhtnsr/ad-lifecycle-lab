# Local validation record

Date: November 1, 2026 (America/New_York).

Environment: Windows authoring workspace; PowerShell 7 for PowerShell checks and Python 3.12 for Python checks. These are local test results, not a CI result or a completed production incident.

## Scope

The directory module and directory commands are mocked. The tests exercise planned/WhatIf behavior and apply-path safeguards without contacting or changing a domain.

## Observed output

```text
PASS: create is plan-only
PASS: disable is plan-only
What if: Performing the operation "Create" on target "lab.user01 on dc01.lab.invalid in OU=Lab,DC=lab,DC=invalid".
PASS: WhatIf blocks apply
PASS: BadName rejected
PASS: BadOU rejected
PASS: mock create path completes
PASS: create invoked once
PASS: new account remains disabled
PASS: mock disable path completes
PASS: disable invoked once
PASS: out-of-scope account rejected
PASS: out-of-scope account was not disabled
PASS: non-lab domain rejected
PASS: non-lab domain received no create
14 checks passed. Directory commands were mocked; no live directory changes.
```

## Reproduce

Run the test command in this repository's README. A passing suite establishes only the cases represented in the tests; add actual lab evidence before claiming end-to-end deployment or recovery.
