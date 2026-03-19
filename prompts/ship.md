# Ship — Release Workflow

> Run this as Step 4 in the execution workflow — after all verification passes (Step 3). This is the final mile: sync, test, coverage audit, commit, push.

## Philosophy

Once you've decided what to build, nailed the technical plan, and run a serious review, stop talking. Execute.

This workflow is for a **ready branch**, not for deciding what to build. Behave like a disciplined release engineer: sync with main, run the tests, make sure the branch state is sane, commit in bisectable chunks, and push.

---

## When to Stop

**Only stop for:**
- On the base branch (abort)
- Merge conflicts that can't be auto-resolved (stop, show conflicts)
- Test failures (stop, show failures)
- Issues found during coverage audit that need client judgment

**Never stop for:**
- Uncommitted changes (always include them)
- Commit message wording (auto-generate)
- Coverage gaps in pre-existing code (note in report, don't block)

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

```bash
# Run the full test suite (adapt command for your project's test framework)
# Python: pytest tests/ -v
# JavaScript: npm test
# Ruby: bundle exec rspec
# Go: go test ./...
```

**If tests fail → STOP.** Show failures. Do not ship broken code.

---

## Step 4: Test Coverage Audit

Trace every codepath changed in this phase and verify test coverage:

1. **Read the diff.** For each changed file, read the full file to understand context.
2. **Trace data flow.** Starting from each entry point, follow data through every branch:
   - Where does input come from?
   - What transforms it?
   - Where does it go?
   - What can go wrong at each step?
3. **Map each branch to a test.** For each conditional path:
   - Is there a test covering the true path?
   - Is there a test covering the false path?
   - Is there a test covering the error path?
4. **Output coverage diagram:**
   ```
   Component: [name]
   ├─ function_a()
   │  ├─ happy path     ★★★ [test file:line]
   │  ├─ invalid input   ★★  [test file:line]
   │  └─ network error   ☐   NO TEST ← generate
   ```

   Quality scoring:
   - ★★★ Tests behavior with edge cases AND error paths
   - ★★  Tests correct behavior, happy path only
   - ★   Smoke test / trivial assertion
   - ☐   No test

5. **Generate tests for gaps.** For any uncovered branch, write a test. Commit separately.

---

## Step 5: Commit in Bisectable Chunks

Split changes into logical, bisectable commits:

```bash
# Each commit should be independently valid (tests pass)
git add -A && git commit -m "[phase]: [component] — [what was done]"
```

**Never commit broken code. Always run tests before committing.**

---

## Step 6: Push and Report

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

### Ready for Review
[link to branch or PR if applicable]
```

---

## Important Rules

- **Never ship from the base branch.**
- **Never ship with failing tests.**
- **Always sync with base before shipping** — test on merged code, not stale code.
- **Coverage audit is not optional.** Every new codepath needs a test.
- **Commit messages are descriptive.** Not "fix stuff" — "[phase]: [component] — [what was done]".
