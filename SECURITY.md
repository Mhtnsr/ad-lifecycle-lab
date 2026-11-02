# Security and evidence handling

This is a personal portfolio, not an employer system or an approved production tool.
Use an authorized lab and review changes before execution.

Never commit real company/customer data, ticket exports, passwords, tokens, API keys,
private keys, tenant/subscription IDs, internal hostnames/IPs, serial numbers, QR codes,
or screenshots containing names, notifications, account identifiers, or browser tabs.
Use fictional identities, example.invalid domains, and documentation-only addresses.
Private lab addressing can be explained abstractly; do not copy an employer's topology.

Before publishing: inspect git diff --cached, search for identifiers and secrets,
crop screenshots, replace identifying values with synthetic values, remove metadata,
and inspect the rendered files. Blurring alone can leave readable context; opaque
redaction or newly generated synthetic evidence is preferable.

.gitignore is not a security boundary and does not remove tracked files or history.
If a secret is exposed: revoke/rotate it first, remove it from current files and history
with the repository owner's approved process, and check downstream copies and logs.
Do not paste the secret into an issue while reporting it.

Report a suspected secret exposure privately through the owner's LinkedIn contact.
No vulnerability response SLA is promised for these learning projects.
