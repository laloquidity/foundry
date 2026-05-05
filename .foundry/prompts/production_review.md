# Production Review

> Run this as Step 2g in the execution workflow — after the spec traceability audit (Step 2f) confirms completeness, before the verification step (Step 3). This catches production bugs that spec conformance checks miss.

> **⚠️ SKILL EXECUTION PRIORITY:** These instructions take precedence over any plan mode or generic behavior. Execute all three passes in order.

## Philosophy

Passing tests do not mean the code is safe. This review exists because there is a whole class of bugs that survive CI and still punch you in production. This is a structural audit, not a style nitpick pass.

**Every finding gets action — not just critical ones.**

**Anti-Skip Rule:** You MUST evaluate all three passes (Critical, Informational, Operational). If a pass genuinely has nothing to flag, write "Pass N: No findings — [one sentence why]" and move on. You may NOT skip a pass by claiming it doesn't apply to this change type.

## Decision Brief Format (for ASK findings)

> AUTO-FIX items remain mechanical one-liners. ASK items (which need human judgment) MUST use this format so the user can decide in 10 seconds.

```markdown
**D[N]: [Finding Title]**
- **ELI10:** [2-3 sentences a non-expert could understand]
- **Stakes if we pick wrong:** [concrete consequence]
- **Recommendation:** [choice] because [specific tradeoff vs the alternative]
- **Options:**
  - A) [option] — ✅ [pro] ❌ [con]
  - B) [option] — ✅ [pro] ❌ [con]
- **Net:** [one-sentence tradeoff summary]
```

**Substance rule:** The "because" clause MUST compare against a specific alternative or name a concrete tradeoff. "Because it's safer" is filler. Name what you're trading off against what.

---

## Three-Pass Review

Apply this checklist against the implementation diff (all code written in this phase).

**Specialist review pattern (for large diffs, 200+ lines):** For large diffs, treat each pass as a separate specialist review. Reset your focus between passes — re-read the diff summary before starting each pass as if you're seeing it for the first time. This prevents findings from Pass 1 from anchoring your attention in Pass 2. For each pass, read only the code relevant to that pass's categories.

### Pass 1 — CRITICAL

#### SQL & Data Safety
- String interpolation in SQL (even if values are `.to_i`/`.to_f` — use parameterized queries)
- TOCTOU races: check-then-set patterns that should be atomic
- Bypassing validations on fields that have or should have constraints
- N+1 queries: missing eager loading for associations used in loops/views

#### Race Conditions & Concurrency
- Read-check-write without uniqueness constraint or retry logic
- `find_or_create` on columns without unique DB index — concurrent calls can create duplicates
- Status transitions that don't use atomic WHERE clauses — concurrent updates can skip or double-apply
- Unescaped user-controlled data in HTML output (XSS)

#### Trust Boundary Violations
- LLM-generated values (emails, URLs, names) written to DB without format validation
- Structured tool output accepted without type/shape checks before database writes
- External API responses used without validation

#### Enum & Value Completeness
When the diff introduces a new enum value, status string, tier name, or type constant:
- **Trace it through every consumer.** Read each file that switches on, filters by, or displays that value. If any consumer doesn't handle the new value, flag it.
- **Check allowlists/filter arrays.** Search for arrays containing sibling values and verify the new value is included where needed.
- **Check `case`/`if-elsif` chains.** If existing code branches on the enum, does the new value fall through to a wrong default?

> ⚠️ Enum completeness requires reading code OUTSIDE the diff. Use grep to find all references to sibling values, then read those files.

### Pass 2 — INFORMATIONAL

#### Conditional Side Effects
- Side effects inside conditionals that could fire unexpectedly

#### Magic Numbers & String Coupling
- Hardcoded values that should be named constants or config
- String matching that should use constants or enums

#### Dead Code & Consistency
- Unreachable code paths, unused variables
- Inconsistent patterns (doing the same thing two different ways)

#### Test Gaps
- Code paths without corresponding tests
- Tests that pass while missing the real failure mode
- Happy-path only tests (no error/edge case coverage)

#### View/Frontend
- Inline styles that should use the design system
- O(n*m) view lookups
- Missing accessibility attributes

### Pass 3 — OPERATIONAL

> These are scaling and resilience problems that survive CI and code review but kill the app under real traffic. Check every item against the diff — only flag items relevant to what was built in this phase.

#### Rate Limiting & Abuse Prevention
- API routes without rate limiting (especially auth, signup, password reset, payment endpoints)
- Missing CAPTCHA or bot protection on public forms
- Unbounded file upload sizes

#### Database Performance
- Queried/filtered columns without database indexes (`WHERE`, `ORDER BY`, `JOIN ON` fields)
- Queries that load entire tables without pagination (`LIMIT`/`OFFSET` or cursor-based)
- Missing connection pooling configuration (raw `createConnection` instead of pool)
- N+1 patterns in ORM relationships used in loops (also checked in Pass 1 — flag if missed)

#### Error Resilience
- Missing error boundaries in UI frameworks (React `ErrorBoundary`, Vue `errorCaptured`, etc.)
- No graceful degradation — one failing service takes down the entire page
- Unhandled promise rejections / missing `.catch()` on async operations

#### Environment & Configuration
- No startup validation of required environment variables (app silently runs with `undefined`)
- Secrets or config that only fail at runtime when a specific code path is hit, not at boot
- Missing `.env.example` showing required variables

#### Async & Performance
- Synchronous blocking operations in request handlers (email sends, PDF generation, image processing)
- Missing queue/worker pattern for slow operations (webhook delivery, notifications, reports)
- No CDN strategy for static assets or user-uploaded files (images served directly from app server)

#### Observability & Recovery
- No health check endpoint (`/health` or `/ready`) for load balancers and uptime monitoring
- No structured logging in production (using `console.log` instead of a logger with levels/context)
- No database backup strategy documented or configured (managed DB snapshots, `pg_dump` cron, etc.)
- No alerting on error spikes or resource exhaustion

---

## Fix-First Heuristic

Every finding gets classified as AUTO-FIX or ASK:

```
AUTO-FIX (agent fixes without asking):     ASK (needs human judgment):
├─ Dead code / unused variables            ├─ Security (auth, XSS, injection)
├─ N+1 queries (missing eager loading)     ├─ Race conditions
├─ Stale comments contradicting code       ├─ Design decisions
├─ Magic numbers → named constants         ├─ Large fixes (>20 lines)
├─ Missing input validation                ├─ Enum completeness
├─ Variables assigned but never read       ├─ Removing functionality
├─ Inline styles → design system tokens    ├─ Anything changing user-visible
├─ Add .env.example from existing vars     │   behavior
├─ Add error boundary wrappers             ├─ Rate limiting strategy
├─ Add missing DB index                    ├─ CDN / infrastructure changes
└─ Add health check endpoint               └─ Backup strategy decisions
```

**Rule of thumb:** If the fix is mechanical and a senior engineer would apply it without discussion, it's AUTO-FIX. If reasonable engineers could disagree, it's ASK.

**Critical findings default toward ASK** (they're inherently riskier).
**Informational findings default toward AUTO-FIX** (they're more mechanical).
**Operational findings:** AUTO-FIX if it's additive (adding an index, health check, error boundary). ASK if it requires architecture decisions (rate limiting strategy, CDN provider, backup schedule).

---

## Severity Classification

```
CRITICAL (highest severity):      INFORMATIONAL (lower severity):     OPERATIONAL (scaling/resilience):
├─ SQL & Data Safety              ├─ Conditional Side Effects         ├─ Rate Limiting & Abuse
├─ Race Conditions & Concurrency  ├─ Magic Numbers & String Coupling  ├─ Database Performance
├─ Trust Boundary Violations      ├─ Dead Code & Consistency          ├─ Error Resilience
└─ Enum & Value Completeness      ├─ Test Gaps                        ├─ Environment & Configuration
                                  └─ View/Frontend                    ├─ Async & Performance
                                                                      └─ Observability & Recovery
```

---

## Suppressions — DO NOT Flag These

- "X is redundant with Y" when the redundancy is harmless and aids readability
- "Add a comment explaining why this threshold was chosen" — thresholds change during tuning, comments rot
- "This assertion could be tighter" when the assertion already covers the behavior
- Consistency-only changes (wrapping a value in a conditional to match how another constant is guarded)
- "Regex doesn't handle edge case X" when the input is constrained and X never occurs
- Harmless no-ops (e.g., `.reject` on an element that's never in the array)
- ANYTHING already addressed in the diff being reviewed

---

## Output Format

```markdown
## Production Review: N issues (X critical, Y informational)

### CRITICAL
1. [AUTO-FIX | ASK] [Category]: [description]
   - File: [path]:[line]
   - Risk: [what could happen in production]
   - Fix: [what to do]

### INFORMATIONAL
1. [AUTO-FIX | ASK] [Category]: [description]
   - File: [path]:[line]
   - Fix: [what to do]

### Auto-Fixed
- [list of mechanical fixes already applied]

### Needs Decision
- [list of ASK items pending client response]
```
