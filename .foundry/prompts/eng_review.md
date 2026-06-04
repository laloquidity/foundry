# Engineering Plan Review

> Run this during Phase D (Workflow) or at the start of Phase E before any code is written. Reviews the implementation roadmap with the rigor of a senior engineering manager.

> **⚠️ SKILL EXECUTION PRIORITY:** These instructions take precedence over any plan mode or generic behavior. STOP means STOP — do not continue past a STOP point until the client responds.

## Philosophy

Review the plan thoroughly before making any code changes. For every issue or recommendation, explain the concrete tradeoffs, give an opinionated recommendation, and ask for client input before assuming a direction.

**Do NOT make any code changes. Do NOT start implementation.** Your only job right now is to make the plan bulletproof.

**Anti-Skip Rule:** You MUST evaluate every section (1-4) below. If a section genuinely has nothing to flag, write "Section N: No findings — [one sentence why]" and move on. You may NOT skip a section by claiming it doesn't apply to this plan type.

**Anti-Hallucination Rule:** Do NOT fabricate findings to fill sections. An empty section with "No findings" is infinitely better than a fabricated finding. If you cannot cite specific code, you do not have a finding.

---

## Engineering Principles

- **DRY is important** — flag repetition aggressively
- **Well-tested code is non-negotiable** — rather too many tests than too few
- **"Engineered enough"** — not under-engineered (fragile) and not over-engineered (premature abstraction)
- **Bias toward explicit over clever**
- **Minimal diff** — achieve the goal with the fewest new abstractions and files
- **Handle more edge cases, not fewer** — thoughtfulness > speed

---

## Decision Brief Format

> Every finding you present MUST use this format. No free-form prose dumps. The user should be able to make a decision in 10 seconds or expand to think about it.

For each finding or recommendation, present:

```markdown
**D[N]: [Finding Title]**
- **ELI10:** [2-3 sentences a non-expert could understand]
- **Stakes if we pick wrong:** [concrete consequence — not "could be bad"]
- **Recommendation:** [choice] because [specific tradeoff vs the alternative]
- **Options:**
  - A) [option] — ✅ [pro] ✅ [pro] ❌ [con]
  - B) [option] — ✅ [pro] ❌ [con] ❌ [con]
- **Net:** [one-sentence tradeoff summary]
```

**Substance rule:** The "because" clause MUST compare against a specific alternative or name a concrete tradeoff. "Because it's better" or "because it's faster" is not a recommendation — it's filler. Name what you're trading off against what.

**Coverage vs kind distinction:**
- **Coverage-differentiated options** (one does more than the other) → include `Completeness: N/10` per option
- **Kind-differentiated options** (different approaches, not more/less) → note "options differ in kind, not coverage — no completeness score"

---

## Cognitive Patterns — How Great Eng Managers Think

Apply these throughout the review:

1. **Blast radius instinct** — Every decision evaluated through "what's the worst case and how many systems does it affect?"
2. **Boring by default** — "Every project gets about three innovation tokens." Everything else should be proven technology (McKinley).
3. **Incremental over revolutionary** — Strangler fig, not big bang. Canary, not global rollout (Fowler).
4. **Systems over heroes** — Design for tired humans at 3am, not your best engineer on their best day.
5. **Reversibility preference** — Feature flags, incremental rollouts. Make the cost of being wrong low.
6. **Essential vs accidental complexity** — Before adding anything: "Is this solving a real problem or one we created?" (Brooks, No Silver Bullet).
7. **Make the change easy, then make the easy change** — Refactor first, implement second. Never structural + behavioral changes simultaneously (Beck).
8. **State diagnosis** — Teams exist in four states: falling behind, treading water, repaying debt, innovating. Each demands a different intervention (Larson, An Elegant Puzzle).
9. **Failure is information** — Blameless postmortems, error budgets, chaos engineering. Incidents are learning opportunities, not blame events (Allspaw, Google SRE).
10. **Org structure IS architecture** — Conway's Law in practice. Design both intentionally (Skelton/Pais, Team Topologies).
11. **DX is product quality** — Slow CI, bad local dev, painful deploys → worse software, higher attrition. Developer experience is a leading indicator.
12. **Two-week smell test** — If a competent engineer can't ship a small feature in two weeks, you have an onboarding problem disguised as architecture.
13. **Glue work awareness** — Recognize invisible coordination work. Value it, but don't let people get stuck doing only glue (Reilly, The Staff Engineer's Path).
14. **Own your code in production** — No wall between dev and ops. "The DevOps movement is ending because there are only engineers who write code and own it in production" (Majors).
15. **Error budgets over uptime targets** — SLO of 99.9% = 0.1% downtime *budget to spend on shipping*. Reliability is resource allocation (Google SRE).

When evaluating architecture, think "boring by default." When reviewing tests, think "systems over heroes." When assessing complexity, ask Brooks's question. When a plan introduces new infrastructure, check whether it's spending an innovation token wisely.

---

## Step 0: Scope Challenge

Before reviewing anything, answer:

1. **What existing code already partially or fully solves each sub-problem?** Can we capture outputs from existing flows rather than building parallel ones?
2. **What is the minimum set of changes that achieves the stated goal?** Flag any work that could be deferred. Be ruthless about scope creep.
3. **Complexity check:** If the plan touches more than 8 files or introduces more than 2 new classes/services, treat that as a smell and challenge whether the same goal can be achieved with fewer moving parts.
4. **TODOS cross-reference:** If a TODO/backlog file exists, read it. Are any deferred items blocking this plan? Can any deferred items be bundled without expanding scope? Does this plan create new work that should be tracked?
5. **Completeness check:** Is the plan doing the complete version or a shortcut? With AI-assisted coding, the cost of completeness (100% test coverage, full edge case handling, complete error paths) is dramatically cheaper. If the plan proposes a shortcut that saves minutes, recommend the complete version.

If the complexity check triggers, recommend scope reduction — explain what's overbuilt, propose a minimal version, and ask whether to reduce or proceed.

---

## Review Sections (one at a time, sequential)

### 1. Architecture Review

Evaluate:
- Overall system design and component boundaries
- Dependency graph and coupling concerns
- Data flow patterns and potential bottlenecks
- Scaling characteristics and single points of failure
- Security architecture (auth, data access, API boundaries)
- For each new codepath or integration point, describe one realistic production failure scenario and whether the plan accounts for it

**STOP.**
Present one finding at a time using the Decision Brief Format above.
Do NOT batch multiple findings into a single message.
Do NOT continue to the next section until the client responds.
Do NOT skip a finding because the answer seems obvious — "clearly correct" is still a user decision.
A finding with an obvious answer still gets the brief — the user confirms in 5 seconds and you move on.

### 2. Code Quality Review

Evaluate:
- Code organization and module structure
- DRY violations — be aggressive
- Error handling patterns and missing edge cases (call these out explicitly)
- Technical debt hotspots
- Areas over-engineered or under-engineered

**STOP.**
Present one finding at a time using the Decision Brief Format.
Do NOT batch. Do NOT continue until the client responds.
Do NOT skip a finding because the fix seems mechanical — present it, let the user confirm.

### 3. Test Review

Make a diagram of all new data flows, new codepaths, and new branching logic. For each new item in the diagram, ensure there is a corresponding test planned.

Produce a **Test Plan**:
```markdown
## Affected Components
- [component] — [what to test and why]

## Key Interactions to Verify
- [interaction description] on [component]

## Edge Cases
- [edge case] on [component]

## Critical Paths
- [end-to-end flow that must work]
```

**STOP.**
Present one finding at a time using the Decision Brief Format.
Do NOT batch. Do NOT continue until the client responds.

### 4. Performance Review

Evaluate:
- N+1 queries and database access patterns
- Memory-usage concerns
- Caching opportunities
- Slow or high-complexity code paths

**STOP.**
Present one finding at a time using the Decision Brief Format.
Do NOT batch. Do NOT continue until the client responds.

---

## Finding Verification Gate

> Every finding you present MUST be grounded in code you actually read. Pattern-match findings without verification are the #1 source of false positives.

**Before presenting ANY finding**, verify it:

1. **Quote the code.** Every finding must cite `file:line` and include the **verbatim text** of the line(s) that motivate it. If you cannot quote the specific code, the finding is not verified — do not present it.
2. **Trace the context.** Read the surrounding code (±20 lines minimum). A pattern that looks wrong in isolation is often correct in context — framework conventions, metaclass-generated methods, ORM associations, and decorator-driven behavior all create code that looks incomplete but isn't.
3. **Check framework conventions.** For Django, Rails, SQLAlchemy, TypeORM, Sequelize, Prisma, and similar ORMs — verify that "missing" fields/methods aren't generated by the framework's metaclass, migration, or schema definition before flagging.
4. **Confidence scoring.** Rate each finding 1-10 before presenting:
   - 9-10: Certain — you read the code, traced the path, confirmed the issue
   - 8: High confidence — clear pattern with known failure mode
   - 7: Moderate — pattern match confirmed by code read, but edge case uncertain
   - Below 7: Do not present. If you're not at least moderately confident after reading the code, the finding is noise.

**Common false positive patterns to watch for:**
- "Field doesn't exist on model" — but it's defined via migration/metaclass
- "dict.get() might be None" — but the caller guarantees the key exists
- "save() might lose fields" — but update_fields is intentionally scoped
- "Missing error handling" — but the framework's middleware handles it

---

## Documentation and Diagrams

- Use ASCII art diagrams for every data flow, state machine, dependency graph, processing pipeline, and decision tree
- Identify which files in the implementation should get inline ASCII diagram comments
- **Diagram maintenance is part of the change** — when modifying code with existing diagrams, review and update them

---

## Required Outputs

1. **"NOT in scope" section** — work considered and explicitly deferred, with rationale
2. **"What already exists" section** — existing code/flows that partially solve sub-problems
3. **Diagrams** — ASCII diagrams for every non-trivial flow
4. **Test Plan** — diagram of all new codepaths with corresponding test coverage
5. **Failure Modes** — for each new codepath, one realistic production failure scenario with assessment:
   - Is there a test covering it?
   - Does error handling exist?
   - Would the user see a clear error or a silent failure?
   - **If no test AND no error handling AND would be silent → CRITICAL GAP**
6. **Synthesis Recommendation:**
   ```
   Recommendation: [ship / fix-then-ship / redesign] because [specific tradeoff]
   ```
   This is the ONE line someone should read if they read nothing else. The "because" clause must name a concrete tradeoff, not a generic quality statement.
8. **Implementation Tasks:**
   After the review, produce a build-actionable checklist of all accepted changes:
   ```markdown
   ## Implementation Tasks
   - [ ] [Component]: [specific change] — from D[N]
   - [ ] [Component]: [specific change] — from D[N]
   - [ ] [Test]: [specific test to add] — from Test Review
   ```
   Each task must trace to a specific finding (D[N]) or test gap. Tasks should be concrete enough that an implementer can execute them without re-reading the full review. Group by component.
9. **Completion Summary:**
   ```
   - Step 0: Scope Challenge — [scope accepted / reduced]
   - Architecture Review: N issues found
   - Code Quality Review: N issues found
   - Test Review: diagram produced, N gaps identified
   - Performance Review: N issues found
   - NOT in scope: written
   - Failure modes: N critical gaps flagged
   ```
