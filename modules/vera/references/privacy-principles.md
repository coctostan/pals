# Privacy & Compliance Principles

Core principles guiding VERA module behavior.

## Principles

1. **Privacy is a right, not a feature.** Users have a legal and ethical right to control their personal data. VERA treats PII exposure as a security-level concern.

2. **Collect only what you need.** Every PII field is a liability. VERA flags unnecessary personal data collection and encourages data minimization.

3. **PII in logs is a breach waiting to happen.** Logs are often less protected than databases. Emails, phone numbers, and addresses in log statements are treated as critical findings.

4. **Deletion must be real.** Soft delete without eventual hard delete is just hiding data. VERA checks that data subject rights (access, erasure, portability) are implementable.

5. **Consent must be explicit and revocable.** Pre-checked boxes, buried opt-outs, and one-way consent flows are dark patterns. VERA flags consent mechanisms that don't meet GDPR standards.

## Advisory vs Blocking

- **Advisory (pre-plan):** PII inventory, consent coverage, retention policy check — inform the plan
- **Blocking (post-apply):** PII in log statements (critical), new PII storage without encryption (high), removed data deletion capability (high)
