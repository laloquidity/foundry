---
description: [PROJECT_NAME] Development Workflow — the COMPLETE operational manual for any agent building this system
---

# [PROJECT_NAME] Development Workflow

> **⚠️ EXECUTION DISCIPLINE: Do not skip ahead. Do not summarize. Do not assume. Go in order.**

---

## 🚨 CRITICAL: FULL CONTEXT IS MANDATORY 🚨

> **ANY agent working on this codebase MUST read the required context files before writing a single line of code. No summaries. No skimming. Read every line of every file listed for your phase.**
>
> 1. **This workflow** — `PROJECT_WORKFLOW.md` (you are reading it now)
> 2. **The section index** — `sections/_INDEX.md`. Maps your current phase to the specific section files you MUST read.
> 3. **The section files listed for your phase** — Read ONLY the files mapped to your current phase. Each file covers one topical concern. Do NOT read all section files at once.
> 4. **The spec registry** — `implementation_plan.md`. Contains every atomic element extracted from the interview with unique IDs.
>
> **Canonical source of truth:** `PROJECT_INTERVIEW.md` remains the canonical source. The section files are verbatim extracts.
>
> **Do NOT proceed past Step 0 without confirming you have read the index, your phase's section files, and the spec registry.**

## 🚨 ZERO ASSUMPTIONS POLICY 🚨

> **If you don't know → ASK. If it's ambiguous → ASK. If you think you know but aren't sure → ASK.**
>
> This project uses a zero-assumptions policy. You will encounter scenarios where the spec is incomplete, ambiguous, or seems to conflict. In ALL such cases:
>
> 1. **STOP** what you are doing
> 2. **DOCUMENT** exactly what is ambiguous
> 3. **ASK** the client for clarification
> 4. **WAIT** for the answer before proceeding
>
> **Proceeding with a guess is FORBIDDEN.**

---

## Role Clarification: Who Is Who

> **Adapt this table for your project's personas.**

| Role | Identity | Authority | Persona File |
|:-----|:---------|:----------|:-------------|
| **[Client Role]** | The human. Domain expert and decision-maker. | Owns the specification. Decides all requirements. Final authority. | `PERSONA_[NAME].md` |
| **[Engineer Role]** | Implementation partner. | Translates specifications into code. Owns code quality, testing, reliability. | `PERSONA_[NAME].md` |
| **[Specialist Role]** | Validation partner. | Validates domain-specific correctness. Provides test vectors. | `PERSONA_[NAME].md` |

**Collaboration model:** All personas discuss and agree on implementation. The client has final authority on all domain decisions.

---

## Step 0: Context Loading (EVERY Session)

### 0a. Session Continuity Check

If resuming from a previous session:
```markdown
## Session Continuity
- Previous session ended at: [step/phase/component]
- Last completed deliverable: [name]
- Current phase: [N]
- Any open items from last session: [list]
```

### 0b. Read the Section Index

```bash
view_file sections/_INDEX.md
```

This tells you WHICH section files to read for your current phase.

### 0c. Read Your Phase's Section Files

Read ONLY the section files mapped to your current phase. Each covers one topical concern. Task-scoped reading keeps the agent focused on exactly what it needs for the current deliverable.

### 0d. Check Dependencies

Verify that all prerequisite phases are complete before starting this phase.

### 0e. Context Checkpoint Gate

> **Prove you loaded and understood the context before writing code.**

1. Read `RETRO_LOG.md` (if it exists) — apply learnings from prior phases
2. Read the `IMPLEMENTATION_ROADMAP.md` entry for your current phase
3. Answer the **3 context checkpoint questions** from the roadmap entry
4. If any answer is wrong or uncertain → re-read the section files and interview references
5. **Only proceed to Step 1 when all 3 answers are correct**

This prevents "fake reading" — the agent must demonstrate comprehension, not just file access.

---

## Step 1: Planning (Deliverable Checklist)

Before writing ANY code, create an explicit deliverable checklist:

```markdown
## Phase [N] Deliverable Checklist

### [Component 1]
- [ ] [Sub-deliverable 1] — [spec ID]
- [ ] [Sub-deliverable 2] — [spec ID]

### [Component 2]
- [ ] [Sub-deliverable 1] — [spec ID]
```

**EVERY sub-deliverable is tracked with `[ ]` / `[/]` / `[x]`.** Nothing is implied or assumed.

### 1b. Smart Review Routing

> **Not all reviews are needed for every phase.** Route reviews based on what changed. This prevents CEO review fatigue on infra work and design review noise on backend changes.

| Change Type | CEO Review | Eng Review | Design Review | Design Consultation | Production Review | QA |
|:------------|:-----------|:-----------|:--------------|:--------------------|:------------------|:---|
| **New feature (full-stack)** | ✅ | ✅ | ✅ | ✅ (if new UI) | ✅ | ✅ |
| **Backend/API only** | ⬚ Skip | ✅ | ⬚ Skip | ⬚ Skip | ✅ | ✅ (diff-aware) |
| **Frontend/UI only** | ⬚ Skip | ✅ | ✅ | ⬚ Skip (unless new patterns) | ✅ | ✅ |
| **Infrastructure/DevOps** | ⬚ Skip | ✅ | ⬚ Skip | ⬚ Skip | ✅ | ⬚ Skip |
| **Bug fix** | ⬚ Skip | ⬚ Skip | ⬚ Skip | ⬚ Skip | ✅ | ✅ (regression) |
| **Architecture change** | ✅ | ✅ | ⬚ Skip | ⬚ Skip | ✅ | ✅ |
| **Scope change / new requirement** | ✅ | ✅ | ✅ (if UI) | ✅ (if UI) | ⬚ Skip | ⬚ Skip |

**Persona routing:** If a persona's domain overlaps with the change, that persona participates in sign-off (Step 3c) even if their review type is skipped for the phase.

**Override:** If unsure, run the review. It's better to over-review than to miss something. The client can always say "skip this review for this phase."

### 1c. Engineering Plan Review (BEFORE Writing Code)

> **Run `prompts/eng_review.md` against the deliverable checklist before any implementation begins.**

This is your engineering manager reviewing the plan for:
- Architecture issues and unnecessary complexity
- Scope creep (>8 files or >2 new classes = smell)
- Missing test coverage plans
- Failure modes that aren't accounted for
- DRY violations and over/under-engineering

**Required outputs:** "NOT in scope" section, "What already exists" section, ASCII diagrams, test plan, failure modes analysis, completion summary.

**STOP after each issue. Present one issue at a time. Do NOT batch.**

---

## Step 2: Implementation (Deliverable-by-Deliverable)

### 2a. Work Through Deliverables Sequentially

For EACH deliverable:
1. **Read the spec registry entry** for the relevant ID(s)
2. **Cross-reference the section file** that governs this component
3. **Write the implementation** with spec ID comments on every significant block
4. **Mark `[x]` in your deliverable list**
5. **Move to the next sub-deliverable**

### 2b. FORBIDDEN Actions During Implementation

❌ Skipping a deliverable without implementing it
❌ Building a "scaffold" or "placeholder" and calling it done
❌ Marking `[x]` before the implementation is complete and tested
❌ Hardcoding any value that should come from config
❌ Omitting the spec ID comment on any significant code block
❌ Proceeding with a guess when the spec is ambiguous
❌ Proceeding to the next deliverable before the current one is `[x]`

### 2c. REQUIRED Actions During Implementation

✅ Every `[ ]` becomes `[x]` with implementation complete
✅ Every code block has a spec ID comment referencing its **section file**
✅ Every parameter comes from config, not hardcoded
✅ Every value matches the interview document exactly
✅ Tests are written for each deliverable
✅ If a spec gap is found, STOP and ask

### 2d. 🐛 Systematic Debugging (On-Demand)

> **When a bug is encountered during implementation — test failure, runtime error, unexpected behavior — run `prompts/debug.md` BEFORE attempting a fix.**

The debug methodology enforces:
- **Iron Law:** No fixes without root cause investigation first
- **Phase 1:** Collect symptoms, read code, check recent changes, reproduce
- **Phase 2:** Pattern analysis (race condition? nil propagation? state corruption?)
- **Phase 3:** Hypothesis testing with temporary instrumentation. 3-strike rule: if 3 hypotheses fail → STOP and escalate
- **Phase 4:** Minimal fix + regression test (must fail without fix, pass with fix)
- **Phase 5:** Fresh verification + structured debug report

**Do NOT skip this for "simple" bugs.** The Iron Law applies equally to one-line fixes and multi-file issues.

### 2e. 🚨 Continuous Verification Loop (DURING Coding, Not After) 🚨

> **After EVERY major deliverable:**

1. **Re-read the SPECIFIC SECTION FILE** that governs what you just wrote. It's now the last thing in your context — maximum attention.
2. **Follow cross-references:** Check the `Cross-references` header in the section file. If your component depends on another section, re-read that too.
3. **Line-by-line comparison:** Does every value in your code match the section file?
4. **Check for competing logic:** Does your implementation conflict with any other rule?
5. **Log verification result:**
   ```markdown
   ✅ VERIFIED: [SPEC-ID] [Component Name]
   - Section file: [filename]
   - [Key verification point]: matches ✓
   - Competing logic check: no conflicts
   ```

### 2e. Conflict Resolution

| Conflict ID | Description | Status |
|:------------|:------------|:-------|
| CONFLICT-001 | [Description] | ❓ Open |

**If you encounter a conflict → STOP coding that component. Document it and ask the client.**

### 2f. Spec Traceability Audit (Before Leaving Step 2)

For every spec ID assigned to this phase:
1. **Is there code implementing it?**
2. **Does the code match the spec exactly?**
3. **Is there a test covering it?**
4. **Was verification logged for it?**

**If ANY spec ID is missing from code, tests, OR verification log → you are NOT done.**

### 2g. 🔍 Production Bug Audit (Post-Implementation Gate)

> **Run `prompts/production_review.md` against all code written in this phase.** This runs AFTER the spec traceability audit confirms completeness.

This catches a different class of bugs than the verification loop:
- **Pass 1 (CRITICAL):** SQL & data safety, race conditions, trust boundary violations, enum completeness
- **Pass 2 (INFORMATIONAL):** Conditional side effects, magic numbers, dead code, test gaps

The **Fix-First heuristic** applies:
- **AUTO-FIX:** Dead code, missing eager loading, stale comments, magic numbers → fix without asking
- **ASK:** Security issues, race conditions, design decisions, anything changing user-visible behavior → ask the client

**Log result:**
```markdown
🔍 PRODUCTION REVIEW: [Component Name]
- Critical findings: [count] (auto-fixed: [count], needs decision: [count])
- Informational findings: [count] (auto-fixed: [count])
- All ASK items resolved: ✓/✗
```

---

## Step 3: Verification (MANDATORY)

### 3a. Automated Tests
```bash
# Run full test suite
pytest tests/ -v

# Run coverage check
pytest tests/ --cov=src/ --cov-report=term-missing
```

### 3b. Integration Verification

Verify that this phase's deliverables integrate correctly with previous phases.

### 3c. Phase Sign-Off

Before marking a phase complete, all personas must sign off:
- [ ] Engineer: code quality, test coverage, no tech debt
- [ ] Specialist: domain correctness, validation passed
- [ ] Client: matches intent, no strategy gaps

### 3d. Design Audit (UI Projects Only)

> **Run `prompts/design_review.md` against the implemented UI.** Skip if the project has no user-facing interface.

This is an 80-item visual audit across 10 categories:
1. Visual Hierarchy & Composition
2. Typography (15 items)
3. Color & Contrast (10 items)
4. Spacing & Layout (12 items)
5. Interaction States (10 items)
6. Responsive Design (8 items)
7. Motion & Animation (6 items)
8. Content & Microcopy (8 items)
9. AI Slop Detection (10 anti-patterns)
10. Performance as Design (6 items)

**Outputs:** Dual headline scores (Design Score: A-F, AI Slop Score: A-F), per-category grades, and findings by severity. If a `DESIGN.md` exists, every delta between spec and rendered implementation is a finding.

### 3e. Full QA: Test → Fix → Verify

> **Run `prompts/qa.md` against the running application.** This replaces simple visual verification with a full QA engineering loop.

The QA skill runs in the mode appropriate to the phase:
- **Diff-aware mode** (default on feature branch): Automatically identifies affected pages from the git diff, tests only what changed
- **Full mode** (on staging URL): Systematic exploration of every reachable page
- **Quick mode** (smoke test): 30-second check — page loads, console, broken links

**The QA loop:**
1. **Explore:** Navigate pages, take screenshots, check console, test interactions
2. **Document:** Every issue with screenshot evidence, immediately when found
3. **Triage:** Sort by severity, decide what to fix based on tier (quick/standard/exhaustive)
4. **Fix Loop:** For each fixable issue: locate source → minimal fix → atomic commit → re-test → write regression test
5. **Self-regulate:** WTF-likelihood heuristic. If fixes are going sideways, STOP and ask.
6. **Final QA:** Re-run after all fixes. Compute health score delta.
7. **Report:** Structured report with health score, before/after screenshots, PR summary.

**Health Score** (0-100, weighted across: Console 15%, Links 10%, Visual 10%, Functional 20%, UX 15%, Performance 10%, Content 5%, Accessibility 15%)

```markdown
🧪 QA REPORT: [Phase/Component]
- Mode: diff-aware / full / quick
- Issues found: [N] (critical: X, high: Y, medium: Z, low: W)
- Fixes applied: [N] (verified: X, best-effort: Y, reverted: Z)
- Regression tests generated: [N]
- Health score: [baseline] → [final]
```

---

## Step 4: Ship (Release)

> **Run `prompts/ship.md` after all verification passes.** This is the final mile.

### 4a. Pre-flight
- Verify you're on a feature branch (not main/master)
- Sync with base branch: `git fetch origin main && git merge origin/main`
- Resolve any merge conflicts

### 4b. Run Tests
- Run the full test suite
- **If tests fail → STOP. Do not ship broken code.**

### 4c. Coverage Audit
- Trace every codepath changed in this phase
- Map each branch to a test
- Generate tests for uncovered paths
- Output ASCII coverage diagram with quality stars (★★★ / ★★ / ★ / ☐)

### 4d. Commit & Push
- Split changes into logical, bisectable commits
- Push to remote
- Output ship report: branch, commits, files changed, test results, coverage

---

## Step 5: Document Release (Post-Ship)

> **Run `prompts/document_release.md` after shipping.** Ensures all documentation is accurate before marking the phase complete.

### 5a. Diff Analysis
- Review what changed in this phase
- Discover all `.md` files in the project

### 5b. Per-File Audit
- Cross-reference every doc file against the diff
- Classify updates as auto-update (factual) or ask-client (narrative)
- Check: README, ARCHITECTURE, DESIGN.md, PROJECT_INTERVIEW.md, PROJECT_WORKFLOW.md

### 5c. Apply & Commit
- Make factual updates directly
- Ask about risky/subjective changes
- Run cross-doc consistency check
- Commit: `git add -A && git commit -m "docs: updated documentation for [phase]"`

---

## Step 6: Post-Phase Gates

### 6a. Interface Contract Verification

> **Verify that this phase delivered what downstream phases depend on.**

1. Read the "Interface Contract" section from `IMPLEMENTATION_ROADMAP.md` for this phase
2. For each item in "Exposes to downstream phases":
   - Does the API/function/module exist?
   - Does it match the contract specification?
   - Is it tested?
3. If the interface drifted from the roadmap → update downstream roadmap entries before proceeding

```markdown
📝 INTERFACE CONTRACT: Phase [N]
- Contract items: [N]
- Fulfilled: [N] | Drifted: [N]
- Downstream updates needed: [yes/no — describe]
```

### 6b. Complexity Budget Check

Compare actuals against the roadmap budget:

```markdown
📊 COMPLEXITY BUDGET: Phase [N]
- Files:        planned [N] | actual [N] | [within/exceeded]
- Abstractions: planned [N] | actual [N] | [within/exceeded]
- Dependencies: planned [N] | actual [N] | [within/exceeded]
```

If exceeded → document why. Update the roadmap for downstream phases if the overshoot affects their estimates.

### 6c. Phase Retrospective

> **Append to `RETRO_LOG.md`.** This creates a learning loop — later phases benefit from earlier phases' execution experience.

```markdown
## Phase [N]: [Name] — Retrospective ([date])

### What Surprised Us
- [What was harder, easier, or different than expected]

### Patterns Discovered
- [Reusable patterns, conventions, or approaches that emerged]
- [These should be applied to downstream phases]

### Assumptions to Re-Validate
- [Any interview assumptions that proved wrong or incomplete]
- [If any → run `/interview-update` before next phase]

### Metrics
- Deliverables planned: [N] | completed: [N]
- Complexity budget: [planned] | actual: [actual]
- QA health score: [score]
- Interface contract: [fulfilled / drifted — describe]
```

**If "Assumptions to Re-Validate" has entries → run `/interview-update` workflow before starting the next phase.**

Commit: `git add RETRO_LOG.md && git commit -m "retro: Phase [N] complete"`

---

## Git Protocol

```bash
# Commit after each component
git add -A && git commit -m "[phase]: [component] — [what was done]"

# Never commit broken code
# Always run tests before committing
```

---

*[PROJECT_NAME] Development Workflow v1.0 — Generated by project-bootstrap skill.*
