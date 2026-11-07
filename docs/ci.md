# Automated checks

[Open the Checks workflow](https://github.com/Mhtnsr/ad-lifecycle-lab/actions/workflows/checks.yml) to inspect the actual result, commit, operating system, runtime, and logs. A workflow definition by itself is not evidence of a passing run.

## Configuration

- Runs for pull requests into main, pushes to main, and manual dispatch.
- Token permissions are limited to reading repository content; checkout does not retain credentials.
- Official checkout/setup actions use fixed commit IDs. No cloud or company credentials are needed.
- Python projects exercise Python 3.10 and 3.12 on Ubuntu and Windows.
- PowerShell projects exercise Windows PowerShell and PowerShell 7 on Windows.
- AD tests mock directory commands. They do not load a real AD module, connect to a domain, or change accounts.
- The support snapshot workflow also runs a read-only integration check against the disposable Windows runner. Its output is restricted to an allowlisted schema.

## Limits

Passing checks validate the represented cases and runner environment. They do not establish live AD/Entra behavior, Intune enrollment, application performance, or production suitability. GitHub-hosted Windows is not the owner's personal home lab.

The live snapshot check deliberately fails if Windows OS or disk collection is unavailable. An absent print spooler is recorded as unavailable and does not trigger a service change.

## Recorded run

[November 7 passing results](ci-results-2026-11-07.md) include source commit IDs, runtimes, and scope.
