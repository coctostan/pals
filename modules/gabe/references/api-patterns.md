<overview>
API design pattern detection and contract validation for GABE. Covers REST conventions, GraphQL patterns, breaking change detection, versioning, and API boundary health.
</overview>

<rest_conventions>

## REST API Conventions

| Convention | Good | Smell |
|-----------|------|-------|
| Resource naming | Plural nouns: `/users`, `/orders` | Verbs: `/getUsers`, `/createOrder` |
| HTTP methods | GET=read, POST=create, PUT/PATCH=update, DELETE=remove | POST for everything |
| Status codes | 200 OK, 201 Created, 400 Bad Request, 404 Not Found, 500 Internal | 200 for errors, custom codes |
| Pagination | `?page=2&limit=20` or cursor-based | No pagination on list endpoints |
| Filtering | `?status=active&sort=created_at` | Filter in response body |
| Error format | `{ "error": { "code": "...", "message": "..." } }` | Plain strings, stack traces in prod |
| Versioning | `/v1/users` or `Accept: application/vnd.api.v1+json` | No versioning at all |
| Idempotency | PUT/DELETE are idempotent, POST with idempotency keys | Non-idempotent PUT |

### Detection

```bash
# Find route definitions
grep -rn "app\.\(get\|post\|put\|patch\|delete\)\|router\.\|@Get\|@Post\|@Put\|@Delete" --include="*.ts" --include="*.js" src/

# Find verb-based URLs (smell)
grep -rn "'/get\|'/create\|'/update\|'/delete\|'/fetch" --include="*.ts" --include="*.js" src/
```

</rest_conventions>

<breaking_changes>

## Breaking Change Detection

| Change Type | Breaking? | Detection |
|------------|-----------|-----------|
| Remove endpoint | ✗ Critical | Route definition removed from diff |
| Remove response field | ✗ Breaking | Field removed from response type/interface |
| Change field type | ✗ Breaking | Type changed in response interface |
| Add required request field | ✗ Breaking | New required field in request body/params |
| Rename endpoint | ✗ Breaking | Route path changed in diff |
| Add optional request field | ✓ Safe | New optional field — backward compatible |
| Add response field | ✓ Safe | New field — existing clients ignore it |
| Add new endpoint | ✓ Safe | New route — doesn't affect existing |
| Deprecate (with notice) | ✓ Safe | Mark deprecated, keep working |

### Detection Heuristic

For changed route/controller files:
1. Parse `git diff` for removed/renamed routes
2. Check response types for removed/renamed fields
3. Check request types for new required fields
4. Flag breaking changes with specific endpoint and field

</breaking_changes>

<graphql_patterns>

## GraphQL Conventions

| Convention | Good | Smell |
|-----------|------|-------|
| Schema-first | `.graphql` schema files, codegen | Inline type definitions scattered in resolvers |
| Naming | `camelCase` fields, `PascalCase` types | Inconsistent casing |
| Nullability | Non-null by default, explicit nullable | Everything nullable |
| Pagination | Relay-style connections (edges/nodes/pageInfo) | Arrays without cursor info |
| Error handling | Union types for errors (`Result = Success \| Error`) | Throwing in resolvers |
| N+1 prevention | DataLoader pattern | Direct DB calls in resolvers |
| Depth limiting | Query depth/complexity limits | Unlimited query depth |

</graphql_patterns>

<contract_health>

## API Contract Health

| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| Undocumented endpoints | 0 | 1-3 | >3 |
| Missing error responses | 0 | 1-2 | >2 |
| Verb-based routes | 0 | 1-2 | >2 |
| Unpaginated list endpoints | 0 | 1 | >1 |
| Missing versioning | N/A (small) | Warning (>5 endpoints) | Critical (>10 endpoints, public API) |
| Breaking changes in PR | 0 | 1 (with deprecation) | >0 (without notice) |
| Missing input validation | 0 | 1-2 | >2 |

</contract_health>

<versioning_strategies>

## API Versioning

| Strategy | Pros | Cons | When to Use |
|----------|------|------|-------------|
| URL path (`/v1/`) | Simple, visible, cacheable | URL pollution | Public APIs, clear major versions |
| Header (`Accept: ...v1`) | Clean URLs | Less visible, harder to test | Internal APIs, fine-grained control |
| Query param (`?version=1`) | Easy to add | Caching issues | Quick iteration, development |
| No versioning | Simple | Breaking changes break clients | Internal-only, single consumer |

</versioning_strategies>
