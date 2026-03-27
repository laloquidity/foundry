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
> 3. **The section files listed for your phase** — Read ONLY the files mapped to your current phase. Each file targets ~2,500 tokens and covers one topical concern. Do NOT read all section files at once.
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

## 📝 COMMUNICATION QUALITY STANDARD

> **Be concrete. Be direct. Connect to the user.**

**Concreteness is the standard.** Name the file, the function, the line number. Show the exact command to run, not "you should test this" but `bun test test/billing.test.ts`. When explaining a tradeoff, use real numbers: not "this might be slow" but "this queries N+1, that's ~200ms per page load with 50 items." When something is broken, point at the exact line.

**Connect to user outcomes.** When reviewing code, designing features, or debugging, connect the work back to what the real user will experience. "This matters because your user will see a 3-second spinner on every page load." "The edge case you're skipping is the one that loses the customer's data." Make the user's user real.

**Banned AI vocabulary — do not use these words in any generated documentation, code comments, commit messages, or communication:**

> delve, crucial, robust, comprehensive, nuanced, multifaceted, furthermore, moreover, additionally, pivotal, landscape, tapestry, underscore, foster, showcase, intricate, vibrant, fundamental, significant, interplay

**Banned phrases:**

> "here's the kicker", "here's the thing", "plot twist", "let me break this down", "the bottom line", "make no mistake", "can't stress this enough"

**Writing rules:**
- Short paragraphs. Direct sentences.
- Name specifics: real file names, real function names, real numbers.
- Be direct about quality. "Well-designed" or "this is a mess." Don't dance around judgments.

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

Read ONLY the section files mapped to your current phase. Each targets ~2,500 tokens and covers one topical concern. Task-scoped reading keeps the agent focused on exactly what it needs for the current deliverable.

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

| Change Type | CEO Review | Eng Review | Design Review | Design Consultation | Security (CSO) | Production Review | QA |
|:------------|:-----------|:-----------|:--------------|:--------------------|:---------------|:------------------|:---|
| **New feature (full-stack)** | ✅ | ✅ | ✅ | ✅ (if new UI) | ✅ (`--diff`) | ✅ | ✅ |
| **Backend/API only** | ⬚ Skip | ✅ | ⬚ Skip | ⬚ Skip | ✅ (`--diff`) | ✅ | ✅ (diff-aware) |
| **Frontend/UI only** | ⬚ Skip | ✅ | ✅ | ⬚ Skip (unless new patterns) | ⬚ Skip | ✅ | ✅ |
| **Infrastructure/DevOps** | ⬚ Skip | ✅ | ⬚ Skip | ⬚ Skip | ✅ (`--diff`) | ✅ | ⬚ Skip |
| **Bug fix** | ⬚ Skip | ⬚ Skip | ⬚ Skip | ⬚ Skip | ⬚ Skip | ✅ | ✅ (regression) |
| **Architecture change** | ✅ | ✅ | ⬚ Skip | ⬚ Skip | ✅ (`--diff`) | ✅ | ✅ |
| **Scope change / new requirement** | ✅ | ✅ | ✅ (if UI) | ✅ (if UI) | ⬚ Skip | ⬚ Skip | ⬚ Skip |
| **Dependency introduction** | ⬚ Skip | ✅ | ⬚ Skip | ⬚ Skip | ✅ (`--supply-chain`) | ⬚ Skip | ⬚ Skip |
| **Final phase (last roadmap phase)** | ✅ | ✅ | ✅ (if UI) | ⬚ Skip | ✅ (full audit) | ✅ | ✅ |

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

**Re-orientation after debugging:** When the debug cycle completes, explicitly state which deliverable you are returning to:
```
🐛 DEBUG COMPLETE — returning to deliverable [name] (spec ID: [ID])
Phase [N] | Step 2a, deliverable [M of total]
```
Then resume the deliverable exactly where you left off.

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
   - Source: [interview | prior-context-doc: document-name]
   - [Key verification point]: matches ✓
   - Competing logic check: no conflicts
   - User outcome: [what the real user experiences because of this spec]
   ```

6. **User outcome check:** For each verified spec, answer: "What does the real user see, feel, or experience because of this?" If you can't connect a spec to a user outcome, flag it — it may be over-engineered or missing context.

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
- **Pass 3 (OPERATIONAL):** Rate limiting, DB indexing/pagination/pooling, error boundaries, env var validation, async patterns, health checks, logging, backup strategy

The **Fix-First heuristic** applies:
- **AUTO-FIX:** Dead code, missing eager loading, stale comments, magic numbers → fix without asking
- **ASK:** Security issues, race conditions, design decisions, anything changing user-visible behavior → ask the client

**Log result and re-orient:**
```markdown
🔍 PRODUCTION REVIEW: [Component Name]
- Critical findings: [count] (auto-fixed: [count], needs decision: [count])
- Informational findings: [count] (auto-fixed: [count])
- All ASK items resolved: ✓/✗
✅ PRODUCTION REVIEW COMPLETE — proceeding to Step 3: Verification
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

**If design findings require code changes:** Fix the issues, then re-run the design review on the affected components only. Log:
```
🎨 DESIGN REVIEW COMPLETE — Score: [grade] | Slop: [grade]
Phase [N] | Step 3d done → proceeding to Step 3e: QA
```

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
✅ QA COMPLETE — proceeding to Step 3.5: CSO Security Audit (if routed) or Step 4: Ship
```

---

## Step 3.5: CSO Security Audit (When Routed)

> **Run `prompts/cso.md` after QA passes, before shipping.** Check the review routing table above. Skip this step if CSO is not routed for this phase's change type.

### 3.5a. Determine CSO Mode

Check the `IMPLEMENTATION_ROADMAP.md` Security Classification for this phase:
- If **touches auth/sessions/tokens, data/PII, or external integrations** → run `--diff`
- If **introduces new dependencies** → run `--supply-chain`
- If **this is the final roadmap phase** → run full audit (cumulative, not diff)
- If **none of the above** → skip CSO for this phase

### 3.5b. Run the Audit

1. Load the phase's section files so the CSO has spec-aware context (trust boundaries, auth model, data classification from the interview)
2. Run `prompts/cso.md` with the determined mode
3. Log the result:

```markdown
🔒 CSO SECURITY AUDIT: Phase [N]
- Mode: --diff / full / --supply-chain / skipped
- Findings: [N] (critical: X, high: Y, medium: Z)
- False positives filtered: [N]
- Verification: independently verified / self-verified
```

### 3.5c. Fix-Verify-CSO Remediation Cycle

If findings are **CRITICAL or HIGH**:
1. Agent fixes the finding (code change + unit test for the fix)
2. Agent verifies the fix doesn't break existing tests
3. CSO re-audits the specific finding only (not full re-audit)
4. Repeat until the finding is resolved or user explicitly accepts risk

**Do NOT proceed to Step 4 (Ship) with unresolved CRITICAL or HIGH security findings.**

### 3.5d. Re-orientation (MANDATORY after CSO cycle)

After all findings are resolved or accepted, explicitly state before continuing:

```
✅ CSO CYCLE COMPLETE — returning to build loop.
Phase [N] | Step 3.5 done → proceeding to Step 4: Ship
```

This re-anchors the agent in the workflow after a potentially long remediation loop. Then immediately proceed to Step 4.

---

## Step 4: Ship (Release)

> **Run `prompts/ship.md` after all verification passes.** This is the final mile. The ship prompt is the authoritative source — these substeps are a summary.

### 4a. Pre-flight
- Verify you're on a feature branch (not main/master)
- Sync with base branch: `git fetch origin main && git merge origin/main`
- Resolve any merge conflicts (trivial = auto-resolve, substantive = STOP)

### 4b. Run Tests + Failure Triage
- Run the full test suite on merged code
- **If tests fail → triage ownership:**
  - Use `git stash` to check if failures are in-branch (your code) or pre-existing (not your fault)
  - In-branch failures → fix before shipping (no override)
  - Pre-existing failures → present to client for triage (fix now / skip / file TODO)

### 4c. Coverage Audit + Gate
- Detect test framework (Node/Python/Ruby/Go/Rust)
- Trace every codepath AND user flow changed in this phase
- Map each branch to a test (E2E recommended for multi-component flows)
- Output ASCII coverage diagram with quality stars (★★★ / ★★ / ★ / ☐)
- **REGRESSION RULE:** Regressions get tests immediately — no asking, no skipping
- Generate tests for uncovered paths (max 20 tests, 2-min per-test cap)
- **Coverage gate:** <60% = hard stop. 60-79% = prompt. ≥80% = auto-pass.

### 4d. Plan Completion Audit
- Read `IMPLEMENTATION_ROADMAP.md` for the current phase's deliverables
- Extract every actionable item and cross-reference against the diff
- Classify each: DONE / PARTIAL / NOT DONE / CHANGED
- **Gate:** NOT DONE items must be acknowledged (implement / defer / drop)

### 4e. Commit & Push
- Split changes into bisectable commits (infra → models → controllers → docs)
- **Verification gate:** If ANY code changed after Step 4b tests, re-run tests first
- Push to remote
- Output ship report: branch, commits, files changed, test results, coverage %, plan completion

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
- CSO findings: [N critical, N high, N medium | or "skipped" if not routed]
- Interface contract: [fulfilled / drifted — describe]
```

**If "Assumptions to Re-Validate" has entries → run `/interview-update` workflow before starting the next phase.**

Commit: `git add RETRO_LOG.md && git commit -m "retro: Phase [N] complete"`

### 6d. Phase Transition (MANDATORY)

After the retro is committed, explicitly state the transition:

```
✅ PHASE [N] COMPLETE — all gates passed.
→ Starting Phase [N+1] at Step 0: Context Loading
```

If `/interview-update` was triggered, run it first, then state:
```
✅ INTERVIEW UPDATED — re-extraction complete.
→ Starting Phase [N+1] at Step 0: Context Loading
```

Then immediately begin Step 0 for the next phase. Do NOT skip context loading for subsequent phases — each phase reads different section files.

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
