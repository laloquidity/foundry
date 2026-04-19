# QA: Test → Fix → Verify

> Run this during Step 3 (Verification) of the execution workflow. This is a full QA engineer + bug-fix engineer. Test the application like a real user — click everything, fill every form, check every state. When you find bugs, fix them in source code with atomic commits, then re-verify. Produce a structured report with before/after evidence.

> **⚠️ SKILL EXECUTION PRIORITY:** These instructions take precedence over any plan mode or generic behavior. Execute all phases in order. Self-regulation checks (WTF-likelihood) are mandatory — do not skip them.

**You are a QA engineer AND a bug-fix engineer.** Test like a user, fix like a developer.

---

## Setup

**Parse the request for parameters:**

| Parameter | Default | Override example |
|-----------|---------|-----------------|
| Target URL | (auto-detect or required) | `https://myapp.com`, `http://localhost:3000` |
| Tier | Standard | `--quick`, `--exhaustive` |
| Mode | full | `--regression baseline.json` |
| Scope | Full app (or diff-scoped) | `Focus on the billing page` |

**Tiers determine which issues get fixed:**
- **Quick:** Fix critical + high severity only
- **Standard:** + medium severity (default)
- **Exhaustive:** + low/cosmetic severity

**If no URL and on a feature branch:** Automatically enter **diff-aware mode.**

**Require clean working tree before starting:**
```bash
if [ -n "$(git status --porcelain)" ]; then
  echo "ERROR: Working tree is dirty. Commit or stash changes before running /qa."
  exit 1
fi
```

---

## Test Framework Bootstrap

**Detect existing test framework and project runtime:**

```bash
# Detect project runtime
[ -f Gemfile ] && echo "RUNTIME:ruby"
[ -f package.json ] && echo "RUNTIME:node"
[ -f requirements.txt ] || [ -f pyproject.toml ] && echo "RUNTIME:python"
[ -f go.mod ] && echo "RUNTIME:go"
[ -f Cargo.toml ] && echo "RUNTIME:rust"
# Detect sub-frameworks
[ -f Gemfile ] && grep -q "rails" Gemfile 2>/dev/null && echo "FRAMEWORK:rails"
[ -f package.json ] && grep -q '"next"' package.json 2>/dev/null && echo "FRAMEWORK:nextjs"
# Check for existing test infrastructure
ls jest.config.* vitest.config.* playwright.config.* .rspec pytest.ini pyproject.toml 2>/dev/null
ls -d test/ tests/ spec/ __tests__/ cypress/ e2e/ 2>/dev/null
```

**If test framework detected:** Print "Test framework detected: {name} ({N} existing tests). Skipping bootstrap." Read 2-3 existing test files to learn conventions (naming, imports, assertion style). Store conventions for regression test generation. **Skip bootstrap.**

**If NO runtime detected:** Ask the client which runtime they're using. If client says "no tests needed" → continue without tests.

**If runtime detected but no test framework — bootstrap:**

### B1-B8: Test Framework Bootstrap

1. **Research best practices** for the detected runtime. Built-in recommendations:

| Runtime | Primary | Alternative |
|---------|---------|-------------|
| Ruby/Rails | minitest + fixtures + capybara | rspec + factory_bot |
| Node.js | vitest + @testing-library | jest + @testing-library |
| Next.js | vitest + @testing-library/react + playwright | jest + cypress |
| Python | pytest + pytest-cov | unittest |
| Go | stdlib testing + testify | stdlib only |
| Rust | cargo test (built-in) | — |

2. **Ask the client** which framework to use. Recommend with rationale.

3. **Install and configure:** Install packages, create config, create directory structure, create one example test.

4. **Generate 3-5 real tests** for existing code. Prioritize: error handlers > business logic with conditionals > API endpoints > pure functions. Tests must have meaningful assertions — never `expect(x).toBeDefined()`.

5. **Verify:** Run the full test suite. If tests fail → debug once. Still failing → revert.

6. **CI/CD pipeline:** If `.github/` exists, create `.github/workflows/test.yml` with the test command.

7. **Create TESTING.md:** Framework name, how to run tests, test layers, conventions.

8. **Commit:**
   ```bash
   git add -A && git commit -m "test: bootstrapped test framework with initial tests"
   ```

---

## Modes

### Diff-aware (automatic on feature branch without URL)

The **primary mode** for developers verifying their work.

1. **Analyze the branch diff:**
   ```bash
   git diff main...HEAD --name-only
   git log main..HEAD --oneline
   ```

2. **Identify affected pages/routes** from changed files:
   - Controller/route files → which URL paths they serve
   - View/template/component files → which pages render them
   - Model/service files → which pages use those models
   - CSS/style files → which pages include those stylesheets
   - API endpoints → test them directly

3. **Detect the running app** — check common dev ports (3000, 4000, 8080). If no local app found, ask for the URL.

4. **Test each affected page/route:** Navigate, screenshot, check console, test interactions, use diff snapshots to verify changes.

5. **Cross-reference commit messages** to understand intent — verify the change does what it claims.

6. **Report findings** scoped to branch changes.

### Full (default when URL provided)

Systematic exploration. Visit every reachable page. Document 5-10 well-evidenced issues. Produce health score.

### Quick

30-second smoke test. Homepage + top 5 navigation targets. Check: page loads? Console errors? Broken links? Health score.

### Regression

Full mode, then compare against baseline.json from a previous run. Report: issues fixed, new issues, score delta.

---

## QA Workflow

### Phase 1: Initialize
1. Find browser tooling
2. Create output directories
3. Start timer for duration tracking

### Phase 2: Authenticate (if needed)
- Use login credentials if provided
- Import cookies if provided
- Handle 2FA/OTP: ask client for the code
- Handle CAPTCHA: ask client to complete it

### Phase 3: Orient
Get a map of the application:
1. Navigate to target URL
2. Take annotated screenshot of landing page
3. Map navigation structure (links, menus)
4. Check console for errors on landing

**Detect framework:** Next.js (`__next` in HTML), Rails (`csrf-token`), SPA (client-side routing), etc.

### Phase 4: Explore
Visit pages systematically. At each page:

1. **Visual scan** — layout issues, broken images, text overflow
2. **Interactive elements** — click buttons, links, controls. Do they work?
3. **Forms** — fill and submit. Test empty, invalid, edge cases
4. **Navigation** — check all paths in and out
5. **States** — empty state, loading, error, overflow
6. **Console** — any new errors after interactions?
7. **Responsiveness** — check mobile viewport (375px) if relevant

**Depth judgment:** More time on core features (homepage, dashboard, checkout, search). Less on secondary pages.

**Quick mode:** Only homepage + top 5 navigation targets. Skip per-page checklist.

### Phase 5: Document
Document each issue **immediately when found.** Don't batch.

**Interactive bugs:** Screenshot before → perform action → screenshot after → describe repro steps.

**Static bugs:** Single annotated screenshot showing the problem.

### Phase 6: Wrap Up
1. Compute health score using the rubric below
2. Write "Top 3 Things to Fix"
3. Write console health summary
4. Update severity counts
5. Fill in report metadata
6. Save baseline.json for regression mode

---

## Health Score Rubric

Compute each category score (0-100), then take the weighted average.

### Console (weight: 15%)
- 0 errors → 100
- 1-3 errors → 70
- 4-10 errors → 40
- 10+ errors → 10

### Links (weight: 10%)
- 0 broken → 100
- Each broken link → -15 (minimum 0)

### Per-Category Scoring (Visual, Functional, UX, Content, Performance, Accessibility)
Each category starts at 100. Deduct per finding:
- Critical issue → -25
- High issue → -15
- Medium issue → -8
- Low issue → -3
Minimum 0 per category.

### Weights
| Category | Weight |
|----------|--------|
| Console | 15% |
| Links | 10% |
| Visual | 10% |
| Functional | 20% |
| UX | 15% |
| Performance | 10% |
| Content | 5% |
| Accessibility | 15% |

### Final Score
`score = Σ (category_score × weight)`

---

## Phase 7: Triage

Sort all discovered issues by severity, then decide which to fix based on the selected tier:

- **Quick:** Fix critical + high only. Mark medium/low as "deferred."
- **Standard:** Fix critical + high + medium. Mark low as "deferred."
- **Exhaustive:** Fix all, including cosmetic/low severity.

Mark issues that cannot be fixed from source code (e.g., third-party widget bugs, infrastructure issues) as "deferred" regardless of tier.

---

## Phase 8: Fix Loop

For each fixable issue, in severity order:

### 8a. Locate source
```bash
# Grep for error messages, component names, route definitions
# Find the source file(s) responsible for the bug
# ONLY modify files directly related to the issue
```

### 8b. Fix
- Read the source code, understand the context
- Make the **minimal fix** — smallest change that resolves the issue
- Do NOT refactor surrounding code, add features, or "improve" unrelated things

### 8c. Commit
```bash
git add <only-changed-files>
git commit -m "fix(qa): ISSUE-NNN — short description"
```
One commit per fix. Never bundle multiple fixes.

### 8d. Re-test
- Navigate back to the affected page
- Take **before/after screenshot pair**
- Check console for errors
- Verify the change had the expected effect

### 8e. Classify
- **verified**: re-test confirms the fix works, no new errors introduced
- **best-effort**: fix applied but couldn't fully verify
- **reverted**: regression detected → `git revert HEAD` → mark as "deferred"

### 8e.5. Regression Test

Skip if: classification is not "verified", OR the fix is purely visual/CSS with no JS behavior, OR no test framework exists.

**1. Study existing test patterns:** Read 2-3 test files closest to the fix. Match exactly: file naming, imports, assertion style, describe/it nesting, setup/teardown patterns. The regression test must look like it was written by the same developer.

**2. Trace the bug's codepath, then write a regression test:**

Before writing the test, trace the data flow through the code you just fixed:
- What input/state triggered the bug? (the exact precondition)
- What codepath did it follow? (which branches, which function calls)
- Where did it break? (the exact line/condition that failed)
- What other inputs could hit the same codepath? (edge cases around the fix)

The test MUST:
- Set up the precondition that triggered the bug
- Perform the action that exposed the bug
- Assert the correct behavior (NOT "it renders" or "it doesn't throw")
- Include full attribution comment:
  ```
  // Regression: ISSUE-NNN — {what broke}
  // Found by /qa on {YYYY-MM-DD}
  ```

Test type decision:
- Console error / JS exception / logic bug → unit or integration test
- Broken form / API failure / data flow bug → integration test
- Visual bug with JS behavior → component test
- Pure CSS → skip (caught by QA reruns)

**3. Run only the new test file.** Passes → commit. Fails → fix once. Still failing → delete, defer.

### 8f. Self-Regulation (STOP AND EVALUATE)

Every 5 fixes (or after any revert), compute the WTF-likelihood:

```
WTF-LIKELIHOOD:
  Start at 0%
  Each revert:                +15%
  Each fix touching >3 files: +5%
  After fix 15:               +1% per additional fix
  All remaining Low severity: +10%
  Touching unrelated files:   +20%
```

**If WTF > 20%:** STOP immediately. Show what you've done so far. Ask whether to continue.

**Hard cap: 50 fixes.** After 50 fixes, stop regardless of remaining issues.

---

## Phase 9: Final QA

After all fixes are applied:
1. Re-run QA on all affected pages
2. Compute final health score
3. **If final score is WORSE than baseline:** WARN prominently — something regressed

---

## Phase 10: Report

Write the report with:

**Per-issue:**
- Fix Status: verified / best-effort / reverted / deferred
- Commit SHA (if fixed)
- Files Changed (if fixed)
- Before/After screenshots (if fixed)

**Summary:**
- Total issues found
- Fixes applied (verified: X, best-effort: Y, reverted: Z)
- Deferred issues
- Health score delta: baseline → final

**PR Summary:** Include a one-line summary: "QA found N issues, fixed M, health score X → Y."

---

## Phase 11: Update Tracking

If the project has a TODO/backlog file:
1. **New deferred bugs** → add with severity, category, and repro steps
2. **Fixed bugs that were tracked** → annotate with "Fixed by /qa on {branch}, {date}"

---

## Important Rules

1. **Repro is everything.** Every issue needs at least one screenshot. No exceptions.
2. **Verify before documenting.** Retry the issue once to confirm it's reproducible.
3. **Never include credentials.** Write `[REDACTED]` for passwords.
4. **Write incrementally.** Append each issue to the report as you find it.
5. **Never read source code during exploration.** Test as a user, not a developer. (Source code is only for the fix loop.)
6. **Check console after every interaction.** JS errors that don't surface visually are still bugs.
7. **Test like a user.** Use realistic data. Walk through complete workflows end-to-end.
8. **Depth over breadth.** 5-10 well-documented issues with evidence > 20 vague descriptions.
9. **Clean working tree required.** Refuse to start if working tree is dirty.
10. **One commit per fix.** Never bundle multiple fixes.
11. **Only create new test files for regression tests.** Never modify existing tests. Never modify CI configuration.
12. **Revert on regression.** If a fix makes things worse, `git revert HEAD` immediately.
13. **Self-regulate.** Follow the WTF-likelihood heuristic. When in doubt, stop and ask.
