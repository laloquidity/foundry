# Production Review

> Run this as Step 2g in the execution workflow — after the spec traceability audit (Step 2f) confirms completeness, before the verification step (Step 3). This catches production bugs that spec conformance checks miss.

## Philosophy

Passing tests do not mean the code is safe. This review exists because there is a whole class of bugs that survive CI and still punch you in production. This is a structural audit, not a style nitpick pass.

**Every finding gets action — not just critical ones.**

---

## Two-Pass Review

Apply this checklist against the implementation diff (all code written in this phase).

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
└─ Inline styles → design system tokens    └─ Anything changing user-visible
                                              behavior
```

**Rule of thumb:** If the fix is mechanical and a senior engineer would apply it without discussion, it's AUTO-FIX. If reasonable engineers could disagree, it's ASK.

**Critical findings default toward ASK** (they're inherently riskier).
**Informational findings default toward AUTO-FIX** (they're more mechanical).

---

## Severity Classification

```
CRITICAL (highest severity):      INFORMATIONAL (lower severity):
├─ SQL & Data Safety              ├─ Conditional Side Effects
├─ Race Conditions & Concurrency  ├─ Magic Numbers & String Coupling
├─ Trust Boundary Violations      ├─ Dead Code & Consistency
└─ Enum & Value Completeness      ├─ Test Gaps
                                   └─ View/Frontend
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
