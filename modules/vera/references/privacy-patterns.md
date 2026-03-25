<overview>
Privacy pattern detection and compliance checking for VERA. Covers PII handling, GDPR/CCPA patterns, data retention, consent flows, and data minimization.
</overview>

<pii_detection>

## PII Detection

| Data Type | Pattern | Sensitivity |
|-----------|---------|-------------|
| Email addresses | `[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}` | Medium |
| Phone numbers | `\+?[0-9]{10,15}`, formatted variants | Medium |
| Social Security / National ID | `[0-9]{3}-[0-9]{2}-[0-9]{4}` (US SSN pattern) | Critical |
| Credit card numbers | `[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}` | Critical |
| IP addresses | `[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}` | Low-Medium |
| Physical addresses | Street number + name patterns | Medium |
| Date of birth | Stored alongside name/email | Medium |
| Biometric data | Fingerprint, face data references | Critical |

### Detection

```bash
# Find PII field names in code/schema
grep -rn "email\|phone\|ssn\|socialSecurity\|creditCard\|dateOfBirth\|address\|passport" \
  --include="*.ts" --include="*.js" --include="*.py" --include="*.prisma" src/

# Find PII in logs (critical)
grep -rn "log.*email\|console.*phone\|log.*address\|log.*ssn" \
  --include="*.ts" --include="*.js" src/

# Find PII stored without encryption
grep -rn "plaintext\|unencrypted" --include="*.ts" --include="*.js" src/
```

</pii_detection>

<gdpr_patterns>

## GDPR / Privacy Regulation Patterns

| Requirement | What to Check | Implementation |
|-------------|--------------|----------------|
| Right to Access | User can export their data | Data export endpoint/function |
| Right to Erasure | User can delete their data | Delete endpoint, cascade rules, backup purge |
| Data Minimization | Collect only what's needed | Check for unnecessary PII fields |
| Purpose Limitation | Data used only for stated purpose | Check data flow across features |
| Consent | User explicitly consents to data collection | Consent flag/timestamp on user record |
| Data Portability | Data exportable in standard format | JSON/CSV export functionality |
| Breach Notification | Process for notifying users of breach | Incident response plan |
| Privacy by Design | Privacy considered from the start | Encryption, access controls, audit logs |

### Detection

```bash
# Find consent patterns
grep -rn "consent\|gdpr\|privacy\|optIn\|optOut\|dataRetention" \
  --include="*.ts" --include="*.js" --include="*.py" src/

# Find data deletion patterns
grep -rn "deleteUser\|removeUser\|purge\|anonymize\|erasure" \
  --include="*.ts" --include="*.js" src/

# Find encryption usage
grep -rn "encrypt\|decrypt\|crypto\|bcrypt\|argon" \
  --include="*.ts" --include="*.js" src/
```

</gdpr_patterns>

<data_retention>

## Data Retention & Lifecycle

| Concern | Check | Detection |
|---------|-------|-----------|
| No retention policy | Data stored indefinitely | Check for TTL, expiry, cleanup jobs |
| Stale data accumulation | Old records never purged | Check for cleanup/archive patterns |
| Backup retention | Backups kept longer than policy allows | Check backup configuration |
| Log retention | Logs contain PII and are kept indefinitely | Check log rotation and PII filtering |
| Session data | Sessions never expire | Check session TTL configuration |
| Soft delete without purge | Soft-deleted records retained forever | Check for hard-delete/purge after retention period |

</data_retention>

<privacy_health>

## Privacy Health Metrics

| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| PII fields without encryption | 0 | 1-2 | >2 |
| PII in log statements | 0 | 0 | >0 |
| Missing consent mechanism | N/A (no PII) | 1 (has PII) | 1 (public-facing + PII) |
| No data deletion capability | N/A (no PII) | 1 (has PII) | 1 (GDPR scope) |
| Hardcoded PII in tests/fixtures | 0 | 1-3 | >3 |
| No data retention policy | N/A (small) | Warning (has PII) | Critical (regulated) |
| Third-party data sharing without docs | 0 | 1 | >1 |

</privacy_health>
