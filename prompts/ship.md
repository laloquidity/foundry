# Ship — Release Workflow

> Run this as Step 4 in the execution workflow — after all verification passes (Step 3). This is the final mile: sync, test, coverage audit, plan check, commit, push.

## Philosophy

Once you've decided what to build, nailed the technical plan, and run a serious review, stop talking. Execute.

This workflow is for a **ready branch**, not for deciding what to build. Behave like a disciplined release engineer: sync with main, run the tests, make sure the branch state is sane, commit in bisectable chunks, and push.

**Only stop for:**
- On the base branch (abort)
- Merge conflicts that can't be auto-resolved (stop, show conflicts)
- In-branch test failures (pre-existing failures are triaged, not auto-blocking)
- AI-assessed coverage below minimum threshold (hard gate with user override)
- Plan items NOT DONE with no user override
- Issues found during reviews that need client judgment

**Never stop for:**
- Uncommitted changes (always include them)
- Commit message wording (auto-generate)
- Coverage gaps in pre-existing code (note in report, don't block)
- Auto-fixable findings (dead code, missing imports — fix silently)

---

## Step 1: Pre-flight

1. **Check the current branch.** If on main/master, abort: "Ship from a feature branch."
2. **Check working tree.** Uncommitted changes are always included.
3. **Review what's being shipped:**
   ```bash
   git diff main --stat
   git log main..HEAD --oneline
   ```

---

## Step 2: Sync with Base Branch

```bash
git fetch origin main
git merge origin/main
```

If merge conflicts arise:
- Attempt auto-resolution for trivial conflicts (whitespace, import order)
- For substantive conflicts, STOP and present the conflicts to the client

---

## Step 3: Run Tests

Run the full test suite — adapt command for the project's test framework:

```bash
# Python: pytest tests/ -v
# JavaScript: npm test
# Ruby: bundle exec rspec
# Go: go test ./...
```

**If any test fails:** Do NOT immediately stop. Apply the Test Failure Ownership Triage:

### Test Failure Ownership Triage

When tests fail, determine ownership before blocking:

**Step T1: Classify each failure**
- Run `git stash && <test command>` to check if the failure exists WITHOUT your changes
- If it fails on stash too → **pre-existing failure** (not your fault)
- If it passes on stash → **in-branch failure** (your code broke it)
- `git stash pop` after classification

**Step T2: Handle in-branch failures**
- These are YOUR regressions. Fix them before shipping. No override.

**Step T3: Handle pre-existing failures**
- Present to the client: "N tests were already failing before this branch. They are not caused by your changes."
- Options:
  A) Fix them now (recommended if related to the feature area)
  B) Skip — ship with pre-existing failures noted in the report
  C) Skip and file a TODO for the pre-existing failures

**Step T4: Execute the chosen action**
- Re-run the full test suite after fixes. Only in-branch failures block shipping.

---

## Step 4: Test Coverage Audit

100% coverage is the goal — every untested path is a path where bugs hide.

### 4.1 Test Framework Detection

1. Check project config files for test setup (jest.config, vitest.config, .rspec, pytest.ini, etc.)
2. Auto-detect:
   ```bash
   [ -f package.json ] && echo "RUNTIME:node"
   [ -f requirements.txt ] || [ -f pyproject.toml ] && echo "RUNTIME:python"
   [ -f Gemfile ] && echo "RUNTIME:ruby"
   [ -f go.mod ] && echo "RUNTIME:go"
   [ -f Cargo.toml ] && echo "RUNTIME:rust"
   ls jest.config.* vitest.config.* playwright.config.* .rspec pytest.ini 2>/dev/null
   ls -d test/ tests/ spec/ __tests__/ e2e/ 2>/dev/null
   ```
3. If no framework detected: note "No test framework configured — diagram only, no test generation."

### 4.2 Before/After Test Count

```bash
find . -name '*.test.*' -o -name '*.spec.*' -o -name '*_test.*' -o -name '*_spec.*' | grep -v node_modules | wc -l
```

Store this number for the ship report.

### 4.3 Trace Every Codepath Changed

Using `git diff origin/main...HEAD`, read every changed file. For each one:

1. **Read the diff.** For each changed file, read the full file to understand context.
2. **Trace data flow.** Starting from each entry point, follow data through every branch:
   - Where does input come from?
   - What transforms it?
   - Where does it go?
   - What can go wrong at each step?
3. **Map user flows.** For each changed feature:
   - What sequence of actions touches this code?
   - What happens on double-click/rapid resubmit?
   - What happens with no network? With a 500 from the API?
   - What does the UI show with zero results? With 10,000?

### 4.4 Check Each Branch Against Tests

For each conditional path — both code paths AND user flows:
- Is there a test covering the true path?
- Is there a test covering the false path?
- Is there a test covering the error path?

Quality scoring:
- ★★★ Tests behavior with edge cases AND error paths
- ★★  Tests correct behavior, happy path only
- ★   Smoke test / trivial assertion
- ☐   No test

### 4.5 E2E Test Decision Matrix

For each uncovered path, determine the right test type:

**RECOMMEND E2E [→E2E]:**
- Common user flow spanning 3+ components/services
- Integration point where mocking hides real failures
- Auth/payment/data-destruction flows — too important to trust unit tests alone

**STICK WITH UNIT TESTS:**
- Pure function with clear inputs/outputs
- Internal helper with no side effects
- Edge case of a single function

### 4.6 Output Coverage Diagram

```
CODE PATH COVERAGE
===========================
[+] src/services/billing.ts
    │
    ├── processPayment()
    │   ├── [★★★ TESTED] Happy path + card declined — billing.test.ts:42
    │   ├── [GAP]         Network timeout — NO TEST
    │   └── [GAP]         Invalid currency — NO TEST
    │
    └── refundPayment()
        ├── [★★  TESTED] Full refund — billing.test.ts:89
        └── [★   TESTED] Partial refund (trivial assertion) — billing.test.ts:101

USER FLOW COVERAGE
===========================
[+] Payment checkout flow
    │
    ├── [★★★ TESTED] Complete purchase — checkout.e2e.ts:15
    ├── [GAP] [→E2E] Double-click submit — needs E2E
    └── [GAP]         Empty cart submission — NO TEST

─────────────────────────────────
COVERAGE: 5/10 paths tested (50%)
  Code paths: 3/5 (60%)
  User flows: 2/5 (40%)
QUALITY: ★★★: 2  ★★: 1  ★: 1
GAPS: 5 paths need tests (1 needs E2E)
─────────────────────────────────
```

### 4.7 REGRESSION RULE (mandatory)

**IRON RULE:** When the coverage audit identifies a REGRESSION — code that previously worked but the diff broke — a regression test is written immediately. No asking. No skipping. Regressions are the highest-priority test.

A regression is when:
- The diff modifies existing behavior (not new code)
- The existing test suite doesn't cover the changed path
- The change introduces a new failure mode for existing callers

Format: commit as `test: regression test for {what broke}`

### 4.8 Generate Tests for Gaps

If test framework is configured:
- Prioritize error handlers and edge cases first
- Read 2-3 existing test files to match conventions
- Generate unit tests. Mock all external dependencies.
- For [→E2E] paths: generate integration tests using the project's E2E framework
- Run each test. Passes → commit as `test: coverage for {feature}`
- Fails → fix once. Still fails → revert, note gap in diagram.

Caps: 30 code paths max, 20 tests generated max, 2-min per-test exploration cap.

If no test framework → diagram only, no generation.

**Diff is test-only changes:** Skip Step 4 entirely.

### 4.9 Coverage Gate

Default thresholds: **Minimum = 60%, Target = 80%.** If the project defines custom thresholds, use those.

Using the coverage percentage from the diagram:

- **≥ target:** Pass. "Coverage gate: PASS ({X}%)." Continue.
- **≥ minimum, < target:** Ask the client:
  - "AI-assessed coverage is {X}%. {N} code paths are untested. Target is {target}%."
  - Options:
    A) Generate more tests for remaining gaps (recommended)
    B) Ship anyway — I accept the coverage risk
    C) These paths don't need tests — mark as intentionally uncovered
  - If A: Loop back to 4.8. Maximum 2 generation passes.
- **< minimum:** Ask the client:
  - "AI-assessed coverage is critically low ({X}%). {N} of {M} code paths have no tests."
  - Options:
    A) Generate tests for remaining gaps (recommended)
    B) Override — ship with low coverage (I understand the risk)

**Coverage percentage undetermined:** Skip the gate: "Coverage gate: could not determine percentage — skipping."

---

## Step 5: Plan Completion Audit

Cross-reference the implementation plan (roadmap phase spec or section files) against the actual diff.

### 5.1 Discover the Plan

1. Check for `IMPLEMENTATION_ROADMAP.md` in the project root — extract the current phase's deliverables
2. Check for the current phase's section file in `.foundry/sections/`
3. If neither found: skip with "No plan file detected — skipping plan completion audit."

### 5.2 Extract Actionable Items

Read the plan/roadmap phase. Extract every actionable item:
- Checkbox items: `- [ ] ...` or `- [x] ...`
- Numbered steps under implementation headings
- File-level specifications: "New file: path/to/file.ts"
- Test requirements: "Test that X", "Add test for Y"
- Data model changes: "Add column X to table Y"

**Ignore:** Context/Background sections, questions, deferred items ("Future:", "Out of scope:", "P2+").

**Cap:** 50 items max.

### 5.3 Cross-Reference Against Diff

Run `git diff origin/main...HEAD` and classify each plan item:

- **DONE** — Clear evidence in the diff. Cite the specific file(s) changed.
- **PARTIAL** — Some work exists but incomplete.
- **NOT DONE** — No evidence in the diff.
- **CHANGED** — Implemented differently than planned, but same goal achieved. Note the difference.

**Be conservative with DONE** — require clear evidence. A file being touched is not enough.
**Be generous with CHANGED** — if the goal is met by different means, that counts.

### 5.4 Output

```
PLAN COMPLETION AUDIT
═══════════════════════════════
Plan: IMPLEMENTATION_ROADMAP.md (Phase 3)

## Implementation Items
  [DONE]      Create UserService — src/services/user_service.ts (+142 lines)
  [PARTIAL]   Add validation — model validates but missing controller checks
  [NOT DONE]  Add caching layer — no cache-related changes in diff
  [CHANGED]   "Redis queue" → implemented with BullMQ instead

─────────────────────────────────
COMPLETION: 3/5 DONE, 1 PARTIAL, 1 NOT DONE, 1 CHANGED
─────────────────────────────────
```

### 5.5 Gate Logic

- **All DONE or CHANGED:** Pass. Continue.
- **Only PARTIAL items (no NOT DONE):** Continue with a note. Not blocking.
- **Any NOT DONE items:** Ask the client:
  - Show the completion checklist
  - Options:
    A) Stop — implement the missing items before shipping
    B) Ship anyway — defer to a follow-up
    C) These items were intentionally dropped — remove from scope

---

## Step 6: Commit in Bisectable Chunks

Split changes into logical, bisectable commits:

### Commit ordering (earlier commits first):
1. **Infrastructure:** migrations, config changes, route additions
2. **Models & services:** new models, services, concerns (with their tests)
3. **Controllers & views:** controllers, views, components (with their tests)
4. **Docs & metadata:** CHANGELOG, README updates, always in the final commit

### Rules for splitting:
- A model/service and its test file go in the same commit
- A controller, its views, and its test go in the same commit
- Migrations are their own commit (or grouped with the model they support)
- If the total diff is small (<50 lines across <4 files), a single commit is fine
- **Each commit must be independently valid** — no broken imports, no references to code that doesn't exist yet

### Commit message format:
```bash
git add -A && git commit -m "<type>: <component> — <what was done>"
# type = feat/fix/chore/refactor/docs/test
```

---

## Step 6.5: Verification Gate

**IRON LAW: NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE.**

Before pushing, re-verify if code changed during Steps 4-6:

1. **Test verification:** If ANY code changed after Step 3's test run (coverage tests, review fixes), re-run the test suite. Paste fresh output.
2. **Build verification:** If the project has a build step, run it. Paste output.

3. **Rationalization prevention:**
   - "Should work now" → RUN IT.
   - "I'm confident" → Confidence is not evidence.
   - "I already tested earlier" → Code changed since then. Test again.
   - "It's a trivial change" → Trivial changes break production.

**If tests fail here:** STOP. Do not push. Fix and return to Step 3.

---

## Step 7: Push and Report

```bash
git push origin HEAD
```

Output the ship report:

```markdown
## Ship Report

**Branch:** [branch name]
**Commits:** [count]
**Files changed:** [count]

### Test Results
- Tests: [before] → [after] (+[new] new)
- All passing: ✓/✗

### Coverage Audit
- Code paths traced: [count]
- Covered: [count] | Gaps filled: [count] | Remaining gaps: [count]
- Coverage gate: PASS (X%) / OVERRIDDEN at X%

### Plan Completion
- Items: [done]/[total] DONE, [partial] PARTIAL, [not done] NOT DONE
- Gate: PASS / OVERRIDDEN

### Ready for Review
[link to branch or PR if applicable]
```

---

## Important Rules

- **Never ship from the base branch.**
- **Never ship with in-branch test failures.** Pre-existing failures can be triaged.
- **Always sync with base before shipping** — test on merged code, not stale code.
- **Coverage audit is not optional.** Coverage gate is a hard stop below 60%.
- **Regression tests are never skipped.** Iron rule — no overrides.
- **Plan completion is checked.** Missing items must be acknowledged before shipping.
- **Never push without fresh verification evidence.** If code changed after Step 3, re-run tests.
- **Commit messages are descriptive.** Not "fix stuff" — "[type]: [component] — [what was done]".
- **Split commits for bisectability** — each commit = one logical change.
