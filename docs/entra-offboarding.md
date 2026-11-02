# Entra ID offboarding design

Status: design checklist, not implemented automation or a completed tenant change.

1. Confirm authorization, identity, timing, legal hold, retention, and owner approval.
2. Inventory on-premises and cloud identity sources; identify sync direction.
3. Plan sign-in blocking and session revocation with approved Microsoft Graph permissions.
4. Confirm mailbox/data delegation and retention requirements before license changes.
5. Remove memberships only after checking dynamic groups and assignment dependencies.
6. Verify the user cannot sign in, preserve required data, and log the approved outcome.
7. Document rehire/recovery steps; do not assume disabling AD revokes cloud sessions.

No Graph credentials, tenant IDs, mailbox exports, or company procedures belong here.
