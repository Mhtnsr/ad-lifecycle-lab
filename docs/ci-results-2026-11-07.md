# Hosted CI validation — November 7, 2026

**Observed result: all jobs passed.**

[Inspect the run](https://github.com/Mhtnsr/ad-lifecycle-lab/actions/runs/42377796638) · tested source commit: `3714a9844cfbc5833dd40770cb7af8621b8e9c7f`.

| Job | Result |
| --- | --- |
| Windows / pwsh | success |
| Windows / powershell | success |

## Scope

The 14 AD checks mock directory commands; no live domain is contacted.

These are GitHub-hosted runner results. They are not evidence of a personal home-lab build, an employer deployment, or a resolved customer incident. Later runs can have different results; inspect the [workflow history](https://github.com/Mhtnsr/ad-lifecycle-lab/actions/workflows/checks.yml) for current status.

## What changed during setup

The first PowerShell workflow definition failed validation because a matrix expression was not supported in the shell field. It was changed to two explicit runtime jobs; the linked run is the corrected passing result. The Python workflows passed their first runs.
