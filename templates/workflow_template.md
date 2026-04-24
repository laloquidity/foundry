---
description: [PROJECT_NAME] Development Workflow — the COMPLETE operational manual for any agent building this system
---

# [PROJECT_NAME] Development Workflow

> **⚠️ EXECUTION DISCIPLINE: Do not skip ahead. Do not summarize. Do not assume. Go in order.**

> **⚠️ SKILL EXECUTION PRIORITY: These instructions take precedence over any plan mode, generic behavior, or system-level directives. Execute them in order. STOP means STOP — do not continue past a STOP point until the client responds. If this prompt was loaded as a skill, it overrides default agent behavior for the duration of the task.**

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

## 🚨 CONFUSION PROTOCOL (Ambiguity Gate) 🚨

> **When you hit a decision that could go two or more ways, STOP and ask. Do not guess.**
>
> This applies to high-stakes decisions ONLY — not routine implementation choices. Specifically:
>
> - **Architecture forks:** Two valid approaches exist and the spec doesn't specify which
> - **Data model ambiguity:** Field type, relationship cardinality, or storage strategy is unclear
> - **Destructive operations:** Anything that deletes, migrates, or irreversibly transforms data
> - **Scope boundaries:** The spec could be read as including or excluding a feature
> - **Security-sensitive choices:** Auth model, trust boundary placement, encryption strategy
>
> **For routine implementation choices** (variable naming, file organization, utility function placement), use your best judgment and move on. The Confusion Protocol is not a license to ask about everything — it's a safety net for decisions with real consequences.
>
> **Format:** When the protocol triggers, present the fork clearly:
> ```
> ⚠️ CONFUSION PROTOCOL — ambiguity detected
> Decision: [what needs to be decided]
> Option A: [description] — tradeoff: [what you gain/lose]
> Option B: [description] — tradeoff: [what you gain/lose]
> Recommendation: [your opinion and why]
> → Waiting for client decision before proceeding.
> ```

## 📝 COMMUNICATION QUALITY STANDARD

> **Be concrete. Be direct. Connect to the user.**

**Concreteness is the standard.** Name the file, the function, the line number. Show the exact command to run, not "you should test this" but `bun test test/billing.test.ts`. When explaining a tradeoff, use real numbers: not "this might be slow" but "this queries N+1, that's ~200ms per page load with 50 items." When something is broken, point at the exact line.

**Connect to user outcomes.** When reviewing code, designing features, or debugging, connect the work back to what the real user will experience. "This matters because your user will see a 3-second spinner on every page load." "The edge case you're skipping is the one that loses the customer's data." Make the user's user real.

**Outcome-framing for questions.** When asking the client a question, frame it in terms of what happens for the user — not abstract technical terms. Instead of "Is this endpoint idempotent?", ask "What should happen if the user submits this form twice quickly? Should they get two charges, or should the second submission be silently ignored?" Technical terms are fine when the client is technical, but always lead with the user outcome.

**Explain on first use.** When using a technical term for the first time in a conversation or document, add a one-sentence gloss: "N+1 queries — where the database makes one query per item in a list instead of loading them all at once." This costs nothing and helps everyone, including technical readers who may not share your specific vocabulary.

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

### 0f. EthSkills Context (Ethereum Projects — MANDATORY)

> **Skip this step if the project has no Ethereum/onchain component.**

Before any implementation phase, read the ethskills files listed for this phase in `IMPLEMENTATION_ROADMAP.md`. Each phase entry has an `## EthSkills` section listing the exact local paths to read.

Read every listed skill file in full. They are required context files alongside section files. Do NOT proceed to Step 1 until ethskills are loaded.

If the phase has no EthSkills listed, skip this step.

**Every onchain phase loads (minimum):**
- `ethskills/security.md` — 9 vulnerability categories, defensive patterns
- `ethskills/addresses.md` — canonical verified addresses for target chain

If a phase has no onchain work (e.g., pure documentation, CI/CD setup, or frontend styling with no wallet/contract interaction), these minimums may be skipped — but the phase must state why explicitly in its EthSkills section.

**Phase 1 (Foundation) additionally loads:**
- `ethskills/tools.md` — confirms framework, MCP servers, Scaffold-ETH 2 setup
- `ethskills/protocol.md` — confirms architectural assumptions against actual chain behavior
- `ethskills/indexing.md` — design contracts event-first (events are your API)

**If the project uses Scaffold-ETH 2** (decided during interview, confirmed by `ethskills/tools.md`):
- SE2 Phase 1 (Scaffold) = Foundry Step 2 (Implementation)
- SE2 Phase 2 (Live + Local) = Foundry Step 3 (Verification)
- SE2 Phase 3 (Production) = Foundry Step 4 (Ship)

If the project does NOT use SE2, ignore this alignment.

**Re-orientation after ethskills load:**
```
✅ ETHSKILLS CONTEXT LOADED — [N] skills read for Phase [N].
Proceeding to Step 1: Planning (Deliverable Checklist).
```

---

## Step 1: Planning (Deliverable Checklist)

Before writing ANY code, open `IMPLEMENTATION_ROADMAP.md` and locate the deliverable list for your current phase. **This IS your checklist.** Do not create a separate deliverable list.

1. Read every `- [ ]` item in the roadmap's `### Deliverables` section for this phase
2. If the roadmap is missing deliverables you need to add (discovered during eng review), add them to the roadmap file directly — then commit
3. As you complete each deliverable during Step 2, update `IMPLEMENTATION_ROADMAP.md` in-place: `[ ]` → `[/]` (in progress) → `[x]` (complete)
4. **The roadmap file is the single source of truth for progress.** If it's not checked off in the roadmap, it's not done.

**Ethereum/onchain projects — ERC standard deliverables:** When reviewing the roadmap's deliverable list for contract phases, add ERC sub-deliverables directly to `IMPLEMENTATION_ROADMAP.md` if missing. Each deliverable involving an ERC standard should include the standard's required function signatures and events as sub-deliverables:

```markdown
### ERC-20 Token Contract
- [ ] `transfer(address,uint256)` — per standards/ — [SPEC-ID]
- [ ] `approve(address,uint256)` — per standards/ — [SPEC-ID]
- [ ] `Transfer` event — per standards/ — [SPEC-ID]
- [ ] `Approval` event — per standards/ — [SPEC-ID]
```

This ensures the spec traceability audit (Step 2f) can verify every standard-required function.

### 1b. Smart Review Routing

> **Not all reviews are needed for every phase.** Route reviews based on what changed. This prevents CEO review fatigue on infra work and design review noise on backend changes.

| Change Type | CEO Review | Eng Review | Design Review | Design Consultation | Security (CSO) | Production Review | QA | EthSkills (Step 0f) |
|:------------|:-----------|:-----------|:--------------|:--------------------|:---------------|:------------------|:---|:--------------------|
| **New feature (full-stack)** | ✅ | ✅ | ✅ | ✅ (if new UI) | ✅ (`--diff`) | ✅ | ✅ | `standards/`, `building-blocks/` |
| **Backend/API only** | ⬚ Skip | ✅ | ⬚ Skip | ⬚ Skip | ✅ (`--diff`) | ✅ | ✅ (diff-aware) | `building-blocks/` |
| **Frontend/UI only** | ⬚ Skip | ✅ | ✅ | ⬚ Skip (unless new patterns) | ⬚ Skip | ✅ | ✅ | `orchestration/`, `frontend-ux/`, `wallets/` |
| **Infrastructure/DevOps** | ⬚ Skip | ✅ | ⬚ Skip | ⬚ Skip | ✅ (`--diff`) | ✅ | ⬚ Skip | `gas/`, `frontend-playbook/`, `wallets/` |
| **Bug fix** | ⬚ Skip | ⬚ Skip | ⬚ Skip | ⬚ Skip | ⬚ Skip | ✅ | ✅ (regression) | — |
| **Architecture change** | ✅ | ✅ | ⬚ Skip | ⬚ Skip | ✅ (`--diff`) | ✅ | ✅ | `standards/` |
| **Scope change / new requirement** | ✅ | ✅ | ✅ (if UI) | ✅ (if UI) | ⬚ Skip | ⬚ Skip | ⬚ Skip | `building-blocks/` |
| **Dependency introduction** | ⬚ Skip | ✅ | ⬚ Skip | ⬚ Skip | ✅ (`--supply-chain`) | ⬚ Skip | ⬚ Skip | `building-blocks/` |
| **Final phase (last roadmap phase)** | ✅ | ✅ | ✅ (if UI) | ⬚ Skip | ✅ (full audit) | ✅ | ✅ | `qa/`, `audit/` |

> **Note:** `ethskills/security.md` and `ethskills/addresses.md` are always loaded at Step 0f for any onchain phase (see minimum rule in Step 0f). The EthSkills column lists skills *in addition to* those minimums.

**Persona routing:** If a persona's domain overlaps with the change, that persona participates in sign-off (Step 3c) even if their review type is skipped for the phase.

**Override:** If unsure, run the review. It's better to over-review than to miss something. The client can always say "skip this review for this phase."

**Finding Dedup Rule:** When multiple reviews run in the same phase (e.g., production review → QA → CSO → adversarial), do NOT re-surface findings that were already addressed or explicitly skipped in an earlier review step. Before presenting a finding, check if the same file:line:category combination was already surfaced. If it was addressed → skip. If it was explicitly skipped by the client → suppress unless the relevant code changed after the skip decision.

### 1c. Engineering Plan Review (BEFORE Writing Code)

> **Run `prompts/eng_review.md` against the deliverable checklist before any implementation begins.**

This is your engineering manager reviewing the plan for:
- Architecture issues and unnecessary complexity
- Scope creep (>8 files or >2 new classes = smell)
- Missing test coverage plans
- Failure modes that aren't accounted for
- DRY violations and over/under-engineering

**Required outputs:** "NOT in scope" section, "What already exists" section, ASCII diagrams, test plan, failure modes analysis, completion summary.

**Ethereum/onchain projects — additional eng review checks:** Before the eng review, ensure the reviewer has context from `ethskills/tools.md` (validates framework selection) and `ethskills/protocol.md` (validates architecture assumptions about finality, block timing, and mempool). The eng review should specifically check:
- Framework selection justified (why Hardhat vs Foundry vs Ape for this project?)
- Finality assumptions match the chosen chain's actual finality time
- Gas estimation strategy documented (hardcoded? live estimate? EIP-1559 priority fee?)
- Upgrade pattern chosen and justified (no proxy assumed without explicit decision)

**STOP after each issue. Present one issue at a time. Do NOT batch.**

---

## Step 2: Implementation (Deliverable-by-Deliverable)

### 2a. Work Through Deliverables Sequentially

For EACH deliverable:
1. **Read the spec registry entry** for the relevant ID(s)
2. **Cross-reference the section file** that governs this component
3. **Write the implementation** with spec ID comments on every significant block
4. **Mark `[x]` in `IMPLEMENTATION_ROADMAP.md`** for this deliverable (edit the file, not just your notes)
5. **Move to the next sub-deliverable**

### 2b. FORBIDDEN Actions During Implementation

❌ Skipping a deliverable without implementing it
❌ Building a "scaffold" or "placeholder" and calling it done
❌ Marking `[x]` before the implementation is complete and tested
❌ Hardcoding any value that should come from config
❌ Omitting the spec ID comment on any significant code block
❌ Proceeding with a guess when the spec is ambiguous
❌ Proceeding to the next deliverable before the current one is `[x]`

**Ethereum/onchain projects — Solidity FORBIDDEN actions:**
❌ Using `tx.origin` for authorization (use `msg.sender`)
❌ Ignoring Checks-Effects-Interactions (CEI) pattern for external calls
❌ Hardcoding contract addresses without cross-checking against `ethskills/addresses.md`
❌ Using `transfer()` or `send()` for ETH transfers (use `call{}` with reentrancy guard)
❌ Deploying without a testnet deployment and verification first
❌ Implementing custom math when OpenZeppelin or Solady equivalents exist

### 2c. REQUIRED Actions During Implementation

✅ Every `[ ]` becomes `[x]` in `IMPLEMENTATION_ROADMAP.md` with implementation complete
✅ Every code block has a spec ID comment referencing its **section file**
✅ Every parameter comes from config, not hardcoded
✅ Every value matches the interview document exactly
✅ Tests are written for each deliverable
✅ If a spec gap is found, STOP and ask

**Ethereum/onchain projects — Solidity REQUIRED actions:**
✅ Before implementing ANY Solidity: `ethskills/standards.md` and `ethskills/building-blocks.md` already loaded at Step 0f
✅ Every contract address used is verified against `ethskills/addresses.md` — no hardcoding unverified addresses
✅ Every ERC standard implemented is validated against `ethskills/standards.md` — no deviations without explicit client approval
✅ Every external call pattern cross-checked against `ethskills/security.md` reentrancy and oracle manipulation sections

### 2d. 🐛 Systematic Debugging (On-Demand)

> **When a bug is encountered during implementation — test failure, runtime error, unexpected behavior — run `prompts/debug.md` BEFORE attempting a fix.**

The debug methodology enforces:
- **Iron Law:** No fixes without root cause investigation first
- **Phase 1:** Collect symptoms, read code, check recent changes, reproduce
- **Phase 2:** Pattern analysis (race condition? nil propagation? state corruption?)
- **Phase 3:** Hypothesis testing with temporary instrumentation. 3-strike rule: if 3 hypotheses fail → STOP and escalate
- **Phase 4:** Minimal fix + regression test (must fail without fix, pass with fix)
- **Phase 5:** Fresh verification + structured debug report

**Ethereum/onchain projects — Solidity debug supplement:** When debugging smart contracts, re-read before forming hypotheses:
- `ethskills/security.md` — 9 specific vulnerability patterns with defensive code: token decimals, no floating point, reentrancy (CEI pattern), SafeERC20, DEX spot price oracles, vault inflation attack, infinite approvals, access control, input validation. Also: MEV/sandwich attacks, proxy pattern issues, EIP-712 signature bugs, delegatecall.
- `ethskills/building-blocks.md` — expected DeFi patterns. NOTE: has chain-specific sections (Building on Base → Aerodrome, Building on Arbitrum → GMX/Pendle). Check the section for your target chain specifically.

These are read-only reference — do not apply fixes without root cause confirmed per Iron Law.

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

**Ethereum/onchain projects — EthSkills verification (Solidity deliverables):**
- Re-read `ethskills/security.md` sections for the specific vulnerability categories relevant to this contract (reentrancy, oracle manipulation, access control, etc.) — re-reading ensures it's the last thing in context, not buried under implementation tokens
- Re-read `ethskills/standards.md` entry for the ERC standard this contract implements
- Verify: function signatures, event names, return types, error conditions match the standard exactly
- Verify: addresses used match `ethskills/addresses.md` for the target chain
- Verify: no known security anti-patterns from `ethskills/security.md` are present (check all 9 vulnerability categories)
- Verify: events designed per `ethskills/indexing.md` event-first principle (events are your API — frontend reads these)
- Verify: if target chain is Base → check `ethskills/building-blocks.md` "Building on Base" section
- Verify: if target chain is Arbitrum → check `ethskills/building-blocks.md` "Building on Arbitrum" section
- Verify: if project has frontend → Three-Button Flow from `ethskills/orchestration.md` implemented
- Log: `✅ ETHSKILLS VERIFIED: [contract name] — standards: ✓, addresses: ✓, security: ✓, events: ✓`

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

**Ethereum/onchain projects — additional spec traceability checks:**
5. **Does the ABI match the standard?** Every function signature, return type, and event topic matches `ethskills/standards.md`
6. **Are addresses verified?** Every external address used is confirmed against `ethskills/addresses.md` for the target chain
7. **Is the constructor/initializer documented?** All deploy parameters documented with expected values

**If ANY spec ID is missing from code, tests, OR verification log → you are NOT done.**

### 2g. 🔍 Production Bug Audit (Post-Implementation Gate)

> **Run `prompts/production_review.md` against all code written in this phase.** This runs AFTER the spec traceability audit confirms completeness.

This catches a different class of bugs than the verification loop:
- **Pass 1 (CRITICAL):** SQL & data safety, race conditions, trust boundary violations, enum completeness
- **Pass 2 (INFORMATIONAL):** Conditional side effects, magic numbers, dead code, test gaps
- **Pass 3 (OPERATIONAL):** Rate limiting, DB indexing/pagination/pooling, error boundaries, env var validation, async patterns, health checks, logging, backup strategy

**Ethereum/onchain projects — Pass 3 (OPERATIONAL) onchain mapping:**

| Pass 3 Category | Onchain Equivalent |
|:----------------|:-------------------|
| Rate limiting | Gas price caps, per-block transaction limits |
| DB indexing | Event indexing strategy — read `ethskills/indexing.md` for The Graph / subgraph patterns |
| Connection pooling | RPC provider rotation, WebSocket reconnection |
| Health checks | RPC endpoint health, chain reorg detection |
| Error boundaries | Revert handling, custom error decoding in UI |
| Backup strategy | Multi-RPC fallback, archive node access for historical queries |

Read `ethskills/indexing.md` during production review if the dApp reads on-chain data.

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

**Ethereum/onchain projects — testing setup:** Before writing any contract tests, read `ethskills/testing.md`. Apply:
- Test type matrix: unit vs fork vs fuzz vs invariant — select appropriate types per function
- Fork tests mandatory for any function that calls external protocols or reads canonical addresses
- Fuzz tests mandatory for any arithmetic, balance calculations, or fee computations
- Invariants defined before testing begins (not after), per `testing/` methodology

### 3b. Integration Verification

Verify that this phase's deliverables integrate correctly with previous phases.

**Ethereum/onchain projects — frontend ↔ contract integration:** Read `ethskills/orchestration.md` before running integration verification. Apply its checklist for:
- ABI encoding correctness (function selectors, event topics)
- Transaction simulation before signing (no silent failures)
- Error decoding (custom errors, revert strings surface correctly in UI)
- RPC provider fallback handling (what happens when the node is down?)
- Chain ID validation (no accidental mainnet tx on testnet setup)

### 3c. Phase Sign-Off

Before marking a phase complete, all personas must sign off:
- [ ] Engineer: code quality, test coverage, no tech debt
- [ ] Specialist: domain correctness, validation passed
- [ ] Client: matches intent, no strategy gaps
- [ ] **Solidity/Onchain Specialist** (Ethereum projects — BLOCKING): Contract correctness, ERC compliance, no known security anti-patterns, gas within budget, upgrade risk acceptable. This must be the **full persona** generated at Phase B (SCAFFOLD), not the seed persona from Phase A. If findings are raised, enter the standard debug → fix → verify cycle before re-presenting for sign-off.

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

**Ethereum/onchain projects — dApp UX supplement:** For projects with a frontend, also read `ethskills/frontend-ux.md` alongside the design review. Apply as an additional design review lens:
- Wallet connect button placement and state management (connected/disconnected/wrong chain)
- Transaction status patterns (pending spinner, confirmation count, success/failure states)
- Gas cost display (estimated cost in USD, gas price context)
- Error message clarity (revert reason decoded and shown in plain language, not hex)
- Network badge/indicator (user always knows which chain they're on)

Design review findings from `frontend-ux/` are graded on the same A-F scale as the standard design audit.

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

**Ethereum/onchain projects — dApp-specific QA:** Read `ethskills/qa.md` alongside `prompts/qa.md`. If `ethskills/qa.md` pulled as a live dApp page instead of markdown, use `ethskills/frontend-playbook.md` Build Verification Process as the fallback.

Apply `ethskills/frontend-ux.md` 9 mandatory rules as a QA checklist in addition to the standard QA loop:
1. Every onchain button has its own pending state (spinner, disabled, etc.)
2. Four-state action flow implemented (idle → pending → success → error)
3. Address display follows standards (truncation, ENS resolution, checksum)
4. USD context shown alongside token values
5. RPC reliability handled (polling intervals, fallback providers)
6. Theme uses semantic tokens, not hardcoded dark wrappers
7. Contract errors translated to human-readable messages (not raw hex)
8. Pre-publish metadata set (OG image, title, description)
9. Human-readable amounts with correct decimal handling

Additionally test:
- Wallet connect/disconnect flows
- Network switch handling (user is on wrong chain)
- Empty/zero state for all on-chain data reads

**Re-orientation after dApp QA:**
```
✅ ETHSKILLS QA COMPLETE — 9 frontend-ux rules checked, [N] additional items tested.
Proceeding to Step 3.5: CSO Security Audit (if routed) or Step 4: Ship.
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

This re-anchors the agent in the workflow after a potentially long remediation loop. Then immediately proceed to Step 3.6.

---

## Step 3.6: Adversarial Review (Recommended)

> **Review the diff as an attacker.** This step catches issues that production review, design review, and QA miss because they think like builders. This step thinks like a breaker.

**Always run this step.** Diff size is not a good proxy for risk — a 5-line auth change deserves the same scrutiny as a 500-line feature.

### 3.6a. Attacker Mindset Pass

Review the full diff (`git diff origin/main...HEAD`) and answer:

1. **How would I exploit this?** For each new endpoint, data flow, or state change — what's the attack vector?
2. **What assumptions does this code make about its inputs?** Are any of those assumptions enforced only by convention, not by validation?
3. **What happens under adversarial conditions?** Rapid retries, malformed payloads, concurrent access, stale tokens, replay attacks.
4. **What does this code trust that it shouldn't?** Client-side state, LLM output, third-party webhook payloads, URL parameters.

### 3.6b. Chaos Engineering Pass

1. **What happens when the dependency fails?** For each external call (API, database, queue, cache) — does the code degrade gracefully or crash?
2. **What happens at 100x the expected load?** Which component breaks first?
3. **What happens when the clock is wrong?** Timezone issues, DST transitions, leap seconds, clock skew between services.

### 3.6c. Output

Classify each finding as:
- **FIXABLE:** Concrete code change needed — describe the fix
- **INVESTIGATE:** Needs more context to determine if it's a real issue
- **ACCEPTED RISK:** Known tradeoff, document it

```markdown
⚔️ ADVERSARIAL REVIEW: Phase [N]
- Attack vectors identified: [count]
- Findings: [N] (FIXABLE: X, INVESTIGATE: Y, ACCEPTED RISK: Z)
- Highest-risk finding: [one sentence]
✅ ADVERSARIAL REVIEW COMPLETE — proceeding to Step 4: Ship
```

### 3.5e. EthSkills Audit Supplement (Ethereum Projects)

> **After completing the CSO audit above, run the EthSkills audit supplement.** This adds onchain-specific security coverage.

Read and apply:
- `ethskills/security.md` — maps to CSO Phases 2, 5, 6, 9:
  - CSO Phase 2 (Secrets Archaeology) → `ethskills/wallets.md` "NEVER COMMIT SECRETS" section + `ethskills/security.md` access control
  - CSO Phase 5 (Infrastructure Shadow) → `ethskills/security.md` proxy patterns, oracle trust + `ethskills/wallets.md` AI agent key safety rules
  - CSO Phase 6 (Webhook/Integration Audit) → `ethskills/security.md` delegatecall, EIP-712 signatures
  - CSO Phase 9 (OWASP) → `ethskills/security.md` 9 vulnerability categories with defensive code samples
- `ethskills/audit.md` — process guide for the parallel sub-agent audit system (separate from ethskills — see `ETH-SKILL-GUIDE.md` "Audit System" section for the full checklist table and URL patterns)

**Audit process:**
1. Read `ethskills/audit.md` for the process and routing table
2. Fetch the master skill: `https://raw.githubusercontent.com/austintgriffith/evm-audit-skills/main/evm-audit-master/SKILL.md`
3. Use the routing table to select 5-8 of the 20 domain-specific checklists based on contract type
4. Fetch each selected checklist: `https://raw.githubusercontent.com/austintgriffith/evm-audit-skills/main/[skill-name]/SKILL.md`
5. If possible, run one sub-agent per selected skill in parallel
6. Each agent walks its checklist and produces findings
7. Synthesize all findings into the CSO findings table (same severity scale)
8. Medium+ findings → file as GitHub issues

**Rule:** Audit findings are treated identically to CSO findings — CRITICAL/HIGH block ship, MEDIUM/LOW are tracked. The audit findings merge INTO the CSO report, not a separate document.

**Loop closure:** If audit findings are CRITICAL or HIGH, enter the same fix-verify-CSO remediation cycle (Step 3.5c).

**Re-orientation after audit + CSO complete:**
```
✅ CSO + ETHSKILLS AUDIT COMPLETE — [N] findings total (CSO: [N], audit/: [N]).
CRITICAL/HIGH resolved: [N] | Accepted risk: [N] | MEDIUM/LOW tracked: [N]
Proceeding to Step 4: Ship.
```

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

**Ethereum/onchain projects — Solidity coverage note:** "Coverage" includes all test types, not just unit test line counts:
```markdown
Solidity coverage breakdown:
- Unit tests: [count] — pure logic, isolated functions
- Fork tests: [count] — functions calling external protocols (MANDATORY for any external call)
- Fuzz tests: [count] — arithmetic, balance math, fee calculations (MANDATORY for math)
- Invariant tests: [count] — state properties that must always hold

Coverage gate applies to the total: (tested paths / total paths) across ALL test types.
A contract with 100% unit coverage but 0 fork tests for external calls = FAIL.
```

### 4d. Plan Completion Audit
- Read `IMPLEMENTATION_ROADMAP.md` for the current phase's deliverables
- Extract every actionable item and cross-reference against the diff
- Classify each: DONE / PARTIAL / NOT DONE / CHANGED
- **Update the roadmap file:** Mark each DONE item `[x]`, each PARTIAL item `[/]` with a note
- **Gate:** NOT DONE items must be acknowledged (implement / defer / drop)

### 4e. Commit & Push
- Split changes into bisectable commits (infra → models → controllers → docs)
- **Verification gate:** If ANY code changed after Step 4b tests, re-run tests first
- Push to remote
- Output ship report: branch, commits, files changed, test results, coverage %, plan completion

### 4f. EthSkills Production Check (Ethereum Projects — MANDATORY before mainnet)

> **Skip this step if the project has no Ethereum/onchain component.**

Read and apply in full:
- `ethskills/wallets.md` — **AI agent key safety rules**: storage hierarchy (worst→best), Safe transaction patterns, key rotation. Also: EIP-7702 smart EOAs, Safe multisig addresses.
- `ethskills/gas.md` — real-world costs (early 2026), mainnet vs L2 comparison. Verify gas assumptions haven't changed since interview. Use `cast base-fee` to check live.
- `ethskills/frontend-playbook.md` — **Go to Production checklist** (8 steps):
  1. Final Code Review 🤖
  2. Choose Domain 👤
  3. Generate OG Image + Fix Metadata 🤖
  4. Clean Build + IPFS Deploy 🤖
  5. Share for Approval 👤
  6. Set ENS 🤖
  7. Verify 🤖
  8. Report 👤

**Overlap resolution:** `frontend-playbook/` Build Verification overlaps with Step 3. Run Step 3 (Foundry QA) first. Then at Step 4f, run `frontend-playbook/` Build Verification as the **production-specific** check. Foundry QA catches code/logic issues; `frontend-playbook/` catches deployment/infra issues (IPFS routing, ENS config, build artifacts).

**Gate:** All items from `frontend-playbook/` Go to Production checklist must be checked before pushing. If any item is NOT DONE, treat identically to a plan completion audit NOT DONE item.

**Testnet deployment is REQUIRED before mainnet** if any of the following changed:
- Any smart contract bytecode
- Any contract address configuration
- Any ABI
- Any wallet interaction flow

Log: `✅ ETHSKILLS PRODUCTION CHECK COMPLETE — wallets: ✓ (key safety: ✓), gas: ✓, playbook: ✓ (8/8 steps), build verification: ✓`

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

**Ethereum/onchain projects — onchain documentation (auto-update):**
- Contract deployment addresses per chain (if deployed this phase)
- ABI files committed and up-to-date in /abis/ or equivalent
- Verified contract links (Etherscan, Basescan, etc.) documented in README
- Subgraph endpoint URL (if indexing/ is used) documented
- Frontend environment config (.env.example) updated with RPC URLs and contract addresses

If new contracts were deployed, the agent must verify the contract is verified on the block explorer before marking Step 5 complete.

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

### Ethereum-Specific Metrics (Onchain Projects Only)
- Gas optimization: planned budget [X Gwei avg] | actual [Y Gwei avg]
- Contract test coverage: unit [X%] | fork [X functions] | fuzz [X properties] | invariants [X]
- ERC compliance: standards implemented [list] | deviations [list with justification]
- Onchain findings: [N critical, N high, N medium from CSO + ethskills/audit/ combined]
- Addresses verified on-chain: [N] / [N total used]
- Testnet deployment: [chain, tx hash] | Issues found: [list]
```

**If "Assumptions to Re-Validate" has entries → run `/interview-update` workflow before starting the next phase.**

**Ethereum/onchain projects — `/interview-update` onchain triggers:** If ANY of the following change mid-project, the interview-update workflow MUST be triggered AND the following ethskills must be re-read:

| Change | Re-read |
|:-------|:--------|
| Chain selection change | `ethskills/l2s.md`, `ethskills/gas.md`, `ethskills/addresses.md` |
| New L2 deployment target added | `ethskills/l2s.md`, `ethskills/gas.md`, `ethskills/addresses.md`, `ethskills/building-blocks.md` (chain-specific section) |
| Token standard change | `ethskills/standards.md`, `ethskills/building-blocks.md` |
| New external protocol integration | `ethskills/building-blocks.md`, `ethskills/security.md`, `ethskills/addresses.md` |
| Frontend wallet library change | `ethskills/wallets.md`, `ethskills/orchestration.md` |
| Upgrade pattern change | `ethskills/standards.md`, `ethskills/security.md` |

After re-reading, apply the same per-deliverable verification check as Step 2e.

Commit: `git add RETRO_LOG.md && git commit -m "retro: Phase [N] complete"`

### 6c½. Content Curation (Optional, Post-Retro)

> If the retrospective surfaced surprises, invalidated assumptions, or non-obvious patterns, run `prompts/content_curator.md`.

1. Ask the client: "The retro surfaced [N] signals. Run content curation? (y/n)"
2. If yes → Curator reads `RETRO_LOG.md` latest entry + relevant section files
3. If `content/drafts/` already has files → curator reads them first to skip covered signals
4. Drafts saved to `content/drafts/`
5. Commit: `git add content/drafts/ && git commit -m "content: curator pass after Phase [N] retro"`

> **Skip condition:** Client says no, or the retro was clean with no surprises or invalidated assumptions.

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
