---
description: Run a full QA pass — test like a user, fix bugs, verify fixes, produce a health report with evidence
---

# /qa — Test → Fix → Verify

Run the QA engineer skill (`prompts/qa.md`) against a running application. Tests like a real user — clicks everything, fills every form, checks every state. When bugs are found, fixes them in source code with atomic commits, then re-verifies. Produces a structured report with before/after evidence and a health score.

## Usage

```
/qa                                     # diff-aware mode (auto on feature branch)
/qa https://myapp.com                   # full mode against URL
/qa http://localhost:3000               # full mode against local dev server
/qa --quick                             # 30-second smoke test
/qa --exhaustive                        # fix everything including cosmetic issues
/qa --regression .foundry/qa/baseline.json  # compare against previous run
/qa Focus on the billing page           # scoped QA
```

## Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| Target URL | auto-detect | URL to test. If omitted on a feature branch, enters diff-aware mode |
| Tier | Standard | `--quick` (critical+high only), `--exhaustive` (all including cosmetic) |
| Mode | diff-aware or full | Automatic based on branch/URL |
| Scope | Full app | Natural language scope restriction |

## Steps

1. **Pre-flight checks:**
   - Verify clean working tree (`git status --porcelain`). If dirty, ask the client: commit, stash, or abort.
   - Create output directory: `.foundry/qa/screenshots/`

2. **Determine mode:**
   - On a feature branch with no URL → **diff-aware mode**: analyze `git diff main...HEAD`, identify affected pages/routes, test only those
   - URL provided → **full mode**: systematic exploration of all reachable pages
   - `--quick` → homepage + top 5 navigation targets only
   - `--regression` → full mode, then compare against baseline

3. **Run the QA skill:**
   - Read and execute `prompts/qa.md` in full — follow every phase in order
   - Use the browser tool to navigate, interact, and screenshot
   - Document each issue immediately with screenshot evidence
   - For interactive bugs: screenshot before → action → screenshot after

4. **Fix loop (per issue, in severity order):**
   - Locate the source file responsible for the bug
   - Make the **minimal fix** — smallest change that resolves the issue
   - Commit atomically: `git commit -m "fix(qa): ISSUE-NNN — short description"`
   - Re-test in browser with before/after screenshot pair
   - Classify: verified / best-effort / reverted

5. **Regression tests (for verified fixes):**
   - Study existing test patterns (naming, imports, assertion style)
   - Write a regression test that reproduces the bug's precondition
   - Run only the new test. Passes → commit. Fails → fix once. Still failing → delete and defer.

6. **Self-regulation:**
   - Every 5 fixes, compute WTF-likelihood score
   - If WTF > 20% → STOP and ask the client whether to continue
   - Hard cap: 50 fixes per run

7. **Final QA pass:**
   - Re-run QA on all affected pages after fixes
   - Compute final health score
   - If score is WORSE than baseline → WARN prominently

8. **Report:**
   - Write report to `.foundry/qa/qa-report-{domain}-{YYYY-MM-DD}.md`
   - Use template from `templates/qa-report-template.md`
   - Save `baseline.json` for future regression runs
   - Output PR summary: "QA found N issues, fixed M, health score X → Y."

9. **Tracking update:**
   - If project has a TODO/backlog file, add deferred bugs and annotate fixed ones

10. **Commit report:**
    ```bash
    git add .foundry/qa/ && git commit -m "qa: health report — score X, found N issues, fixed M"
    ```

## Browser Testing in Antigravity

This workflow uses Antigravity's browser subagent for all browser interactions. The QA skill in `prompts/qa.md` references browser commands — map them as follows:

| QA Skill Reference | Antigravity Equivalent |
|--------------------|-----------------------|
| Navigate to URL | `browser_subagent` → navigate to URL |
| Take screenshot | `browser_subagent` → capture screenshot |
| Click element | `browser_subagent` → click on element |
| Fill form field | `browser_subagent` → type into field |
| Check console errors | `browser_subagent` → check browser console |
| Check mobile viewport | `browser_subagent` → resize to 375x812 |

## When to Use This

- **Step 3e in the execution workflow** — after implementation and verification, before shipping
- After completing a feature branch and wanting to verify it works end-to-end
- Before creating a PR — catch bugs before reviewers see them
- After deployment — smoke test the live site
- Anytime someone says "does this work?" or "test this"

## Important

- **Test as a user, not a developer.** Do not read source code during exploration (Phase 4). Source code is only for the fix loop (Phase 8).
- **One commit per fix.** Never bundle multiple fixes into one commit.
- **Revert on regression.** If a fix makes things worse, `git revert HEAD` immediately.
- **Clean working tree required.** Refuse to start if working tree is dirty.
- **Depth over breadth.** 5-10 well-documented issues with evidence > 20 vague descriptions.
