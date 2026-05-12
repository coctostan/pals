<overview>
Advisory privacy pattern reference for in-scope PII-like data, consent/privacy, deletion/retention, encryption, sensitive-data exposure, and privacy-regulation signals. Findings are evidence, not proof of compliance or absence.
</overview>

<pii_detection>

## PII Detection

| Data Type | Marker |
|-----------|--------|
| Email-like value | `[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}` |
| Phone-like value | `\+?[0-9]{10,15}` or formatted variants |
| National-ID-like value | `[0-9]{3}-[0-9]{2}-[0-9]{4}` or named national ID field |
| Payment-card-like value | `[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}` |
| Address-like field | street/address/postal field marker |
| Date-of-birth-like field | dateOfBirth/dob/birthDate marker |
| Biometric-like field | fingerprint/face/voice/biometric marker |
| User/device IP-like value | IP address only when context ties it to a user/device record |

### Evidence Checklist

Use markers only for in-scope source/text paths; omit checks without changed-code evidence.

| Check | Evidence |
|-------|----------|
| PII-like field | changed schema/model/form/API path contains marker |
| PII-like log exposure | changed log statement includes marker |
| Unprotected storage | changed PII-like storage path lacks visible encryption/hash/tokenization evidence |
| Hardcoded PII-like test data | changed test/example path includes realistic marker |

Report `WARN` only with cited code evidence and recovery owner; do not infer privacy impact from unrelated files.

</pii_detection>

<gdpr_patterns>

## GDPR / Privacy Regulation Patterns

| Label | Evidence | Marker |
|-------|----------|--------|
| Access/export | changed data-export path or provided docs | export endpoint/function |
| Erasure/deletion | changed delete/anonymize/purge path or provided docs | deleteUser, anonymize, erasure |
| Data minimization | changed collection path adds PII-like field | field purpose or minimization note |
| Purpose limitation | changed data-use path cites purpose or provided docs | purpose tag/comment/doc reference |
| Consent | changed collection path includes consent marker | consent flag/timestamp, optIn/optOut |
| Portability | changed export format/path or provided docs | JSON/CSV export |
| Breach notification | provided docs or changed incident-response path | breach/incident notification reference |
| Privacy by design | changed privacy control or provided docs | encryption, access control, audit-log marker |

### Evidence Checklist

Use privacy-regulation labels only for in-scope changed paths or provided docs; omit labels without evidence.

| Check | Evidence |
|-------|----------|
| Consent/privacy marker | changed path contains consent/privacy/opt-in marker |
| Deletion/erasure marker | changed path contains delete/anonymize/purge/erasure marker |
| Privacy control | changed path contains encryption/hash/access-control marker |
| Documentation support | provided doc states relevant privacy behavior |

Report labels as advisory context only; do not claim GDPR/CCPA compliance from code markers or provided docs.

</gdpr_patterns>

<data_retention>

## Data Retention & Lifecycle

| Concern | Evidence |
|---------|----------|
| Retention policy gap | changed data path lacks visible TTL/expiry/cleanup marker |
| Stale data risk | changed lifecycle path lacks visible cleanup/archive marker |
| Backup retention | changed backup/config path conflicts with provided retention policy |
| Log retention | changed log path stores PII-like data without visible rotation/filtering evidence |
| Session retention | changed session path lacks visible TTL/expiry evidence |
| Soft delete without purge | changed soft-delete path lacks visible purge/anonymization evidence |

Report `WARN` only with in-scope changed-code/config or provided-doc evidence and recovery owner; do not infer retention policy from unrelated files.

</data_retention>

<privacy_health>

## Privacy Signals

Use these as advisory WARN triggers only with in-scope evidence; do not score privacy health or infer regulatory scope. Each WARN cites `{file}:{line}` or the triggering row.

| Signal | WARN trigger |
|--------|--------------|
| Unprotected PII-like storage | changed PII-like storage path lacks visible encryption/hash/tokenization evidence |
| PII-like log exposure | changed log statement includes PII-like marker |
| Consent gap | changed user data-collection path lacks visible consent/privacy marker |
| Deletion gap | changed PII-like lifecycle path lacks visible delete/anonymize/erasure handling |
| Hardcoded PII-like test data | changed test/fixture path includes realistic PII-like marker |
| Retention gap | changed data/log/session path lacks visible retention marker |
| Third-party sharing gap | changed external-sharing path lacks visible notice/control evidence |

</privacy_health>
