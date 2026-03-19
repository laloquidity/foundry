# Engineering Plan Review

> Run this during Phase D (Workflow) or at the start of Phase E before any code is written. Reviews the implementation roadmap with the rigor of a senior engineering manager.

## Philosophy

Review the plan thoroughly before making any code changes. For every issue or recommendation, explain the concrete tradeoffs, give an opinionated recommendation, and ask for client input before assuming a direction.

**Do NOT make any code changes. Do NOT start implementation.** Your only job right now is to make the plan bulletproof.

---

## Engineering Principles

- **DRY is important** — flag repetition aggressively
- **Well-tested code is non-negotiable** — rather too many tests than too few
- **"Engineered enough"** — not under-engineered (fragile) and not over-engineered (premature abstraction)
- **Bias toward explicit over clever**
- **Minimal diff** — achieve the goal with the fewest new abstractions and files
- **Handle more edge cases, not fewer** — thoughtfulness > speed

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

**STOP after each issue. Present one issue at a time with options, your recommendation, and WHY. Do NOT batch.**

### 2. Code Quality Review

Evaluate:
- Code organization and module structure
- DRY violations — be aggressive
- Error handling patterns and missing edge cases (call these out explicitly)
- Technical debt hotspots
- Areas over-engineered or under-engineered

**STOP after each issue. One at a time.**

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

**STOP after each issue. One at a time.**

### 4. Performance Review

Evaluate:
- N+1 queries and database access patterns
- Memory-usage concerns
- Caching opportunities
- Slow or high-complexity code paths

**STOP after each issue. One at a time.**

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
6. **Completion Summary:**
   ```
   - Step 0: Scope Challenge — [scope accepted / reduced]
   - Architecture Review: N issues found
   - Code Quality Review: N issues found
   - Test Review: diagram produced, N gaps identified
   - Performance Review: N issues found
   - NOT in scope: written
   - Failure modes: N critical gaps flagged
   ```
