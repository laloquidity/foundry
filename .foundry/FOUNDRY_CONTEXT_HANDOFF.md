# Foundry Context Handoff

> **For:** The next agent continuing work on Foundry and related projects.
> **From:** Previous agent session (March 2026).
> **Read this entire document before doing anything.**

---

## What Is Foundry

Foundry is a **universal project bootstrapping skill** — a structured workflow that an AI agent follows to build any software project from scratch with production-grade rigor. It lives at:

```
https://github.com/laloquidity/foundry
```

**Current HEAD:** `6576900` — clean, no pending changes.

It is NOT a code framework. It is a **process framework** — a set of markdown files that define how the agent should interview the client, plan architecture, implement code, verify quality, run security audits, and ship releases. Think of it as a "how to build things right" operating manual for AI agents.

### Core Files

| File | Purpose |
|:-----|:--------|
| `.foundry/SKILL.md` | **Master orchestrator.** Defines the full Phase A → Phase G lifecycle. The agent reads this first and it governs everything. |
| `.foundry/templates/workflow_template.md` | Per-phase build loop (Steps 0-6). Copied into project as `PROJECT_WORKFLOW.md`. Every phase of implementation follows these steps. |
| `.foundry/templates/interview_guide.md` | Deep interview framework for Phase A. |
| `.foundry/templates/interview_update_workflow.md` | Mid-project scope change handler. |
| `.foundry/prompts/ship.md` | **v2 "Ship With Teeth"** — release workflow with coverage gate (60%/80%), test failure triage, plan completion audit, verification gate, bisectable commits. |
| `.foundry/prompts/cso.md` | **v2 CSO security audit** — 15-phase security scan. |
| `.foundry/prompts/production_review.md` | **3-pass production bug audit** — Critical, Informational, Operational. |
| `.foundry/prompts/crowe_persona_generator.md` | Generates specialist reviewer personas. |
| `.foundry/prompts/qa.md` | QA loop. |
| `.foundry/prompts/design_review.md` | Design audit. |
| `.foundry/prompts/eng_review.md` | Engineering review. |
| `.foundry/prompts/debug.md` | Iron Law debug methodology. |
| `.foundry/prompts/ceo_review.md` | CEO strategic review. |
| `.foundry/prompts/office_hours.md` | Client check-in prompts. |
| `.foundry/prompts/simplify_loop.md` | Complexity reduction. |
| `.foundry/prompts/document_release.md` | Documentation update. |
| `.foundry/prompts/design_consultation.md` | Design consultation. |

### Lifecycle (Phases)

```
Phase A:   Deep Interview (understand the project)
Phase A½:  Skills & Workflows Discovery (wire external skills)
Phase B:   Architecture Planning
Phase C:   Section File Generation (detailed specs per component)
Phase D:   Project Scaffolding (create files, folders, configs)
Phase E:   Implementation Roadmap (phased build plan)
Phase F:   Per-Phase Build Loop (Steps 0-6, repeated per phase)
Phase G:   Maintenance & Evolution
```

Each implementation phase in Phase F runs the workflow template Steps 0-6:
```
Step 0:   Re-orientation (load context)
Step 1:   Planning (deliverable checklist, review routing, eng review)
Step 2:   Implementation (coding, forbidden/required actions, verification loop, debug, spec traceability, production review)
Step 3:   Verification (tests, integration, sign-off, design audit, QA)
Step 3.5: CSO security audit (when routed)
Step 3.6: Adversarial review (attacker-mindset + chaos engineering)
Step 4:   Ship (test triage, coverage gate, plan completion, scope drift detection, verification gate, push)
Step 5:   Document release
Step 6:   Phase transition (interface contract, complexity budget, retro)
```

---

## What Was Done In This Session

### 1. Foundry Repo Cleanup
- Removed `bootstrap/` path prefixing so cloning works from any directory.
- Added "Quick Start" to README recommending `git clone <url> .` to avoid nested directories.

### 2. GStack v2 Upgrades (committed, in repo)
- **CSO v2:** Replaced with 15-phase security audit covering stack detection, secrets archaeology, CI/CD, supply chain analysis.
- **Ship v2 ("Ship With Teeth"):** Complete rewrite with:
  - Test failure triage (regression vs pre-existing vs acceptable)
  - Coverage gate (60% hard minimum, 80% target, user override)
  - Plan completion audit (diff vs roadmap spec IDs)
  - Verification gate (no claims without fresh evidence)
  - Bisectable commits
- **Production Review Pass 3 (OPERATIONAL):** Added 10 scaling/resilience checks (rate limiting, DB indexing, pagination, pooling, error boundaries, env validation, async patterns, health checks, logging, backups).
- **Workflow Template + .foundry/SKILL.md:** Updated to reflect all v2 features.

### 3. ETH-SKILL-GUIDE (standalone, NOT in repo)
- Created a comprehensive guide for wiring [ethskills.com](https://ethskills.com) into Foundry projects.
- **Location:** `/Users/lalo/Downloads/ETH-SKILL-GUIDE.md` (32,941 bytes, 608 lines)
- **Deliberately kept OUT of the Foundry repo** to avoid bloating the evergreen framework with Ethereum-specific knowledge. It is a standalone file the user copies into ETH project workspaces.
- **All 18 ethskills were READ in full** and mapped to specific workflow steps with:
  - Re-orientation anchors (agent doesn't get lost after context-heavy ethskills reads)
  - Loop closure (audit findings trigger fix-verify cycle, not just "block ship")
  - Minimum ethskills per roadmap phase rule (no empty `## EthSkills` sections)
  - Quick reference table mapping every ethskill to every workflow step

### 4. Gstack Sync v0.6.0 (April 2026)
- Synced with upstream [gstack v1.1.3.0](https://github.com/garrytan/gstack) — ~60+ changelog entries analyzed for accretive methodology improvements.
- **10 prompt-level improvements** integrated (see `CHANGELOG.md` v0.6.0 for full details):
  - Confusion Protocol (ambiguity gate)
  - Skill Execution Priority preamble (all 8 prompts)
  - Anti-Skip Rule (all 4 review prompts)
  - Scope Drift Detection (ship.md Step 5.5)
  - Adversarial Review (workflow Step 3.6)
  - UX Behavioral Tests (design_review.md Phase 4.5)
  - Finding Dedup Rule (workflow template)
  - Outcome-framing + explain-on-first-use (communication standard)
  - Specialist review pattern (production_review.md)
- **17+ gstack features classified as N/A** (binary infrastructure, multi-host generation, telemetry, browser security) — these don't apply to Foundry's prompt-only architecture.

---

## The User's Situation

- **Name:** Lalo
- **IDE:** Antigravity IDE (Google)
- **Subscription:** Google AI Ultra
- **Workspace:** `/Users/lalo/Desktop/Homebase` (Foundry repo cloned here)
- **Foundry repo:** `https://github.com/laloquidity/foundry` (username: laloquidity)
- **Immediate goal:** Start a new project (likely Ethereum/onchain) using Foundry to bootstrap it.
- **Has an existing "Migration Bundle"** from a previous project (Clarity/ClarityScribe) that may feed into the new project.

---

## Where to Take Foundry Next

### Tier 1: Immediate (do when starting the new project)

**A. First Real Project Usage — Validate the Workflow**
- User will clone Foundry into a new project workspace and run `/foundry-start`.
- This is the FIRST real usage of the hardened v2 workflow.
- **Priority:** Observe where the agent gets stuck, where context is lost, where gates are too strict or too loose. This is a validation run.
- If the project is Ethereum, copy `ETH-SKILL-GUIDE.md` into the workspace and wire it during Phase A½.

**B. EthSkills Integration (if ETH project)**
- Copy `/Users/lalo/Downloads/ETH-SKILL-GUIDE.md` to the project workspace root.
- At Phase A½, tell the agent: "Read ETH-SKILL-GUIDE.md and wire ethskills into this project's workflow and roadmap exactly as described."
- The guide contains all instructions — no Foundry repo changes needed.

### Tier 2: After the first project ships

**C. Foundry Conductor (Multi-Agent Parallelism)**
- **Concept:** Wrap Foundry in a "conductor" that manages multiple parallel agents, each working on a different phase or component in their own git worktree.
- **Tech stack:** `antigravity-sdk` (headless cascade creation, background sessions, step control) + git worktrees for isolation.
- **Key design decisions still needed:**
  - How do parallel agents share context without conflicts?
  - How do you merge worktrees back into main?
  - How do you coordinate sign-offs across parallel phases?
- **The `antigravity-sdk` was analyzed and confirmed viable** for this — it can create cascades, control session steps, and run headlessly.

**D. Paperclip Integration (Company-Level Orchestration)**
- **What:** [paperclip.ing](https://paperclip.ing/) — open source orchestration for multi-agent companies. Org charts, budgets, governance, heartbeats.
- **When:** After Foundry Conductor works. Paperclip is the layer ABOVE the conductor.
- **Stack vision:**
  ```
  Paperclip (org layer)     → who works on what, budget, governance
      ↓ heartbeat
  Foundry Conductor         → how to build it, workflow steps, quality gates
      ↓ cascade
  Antigravity SDK           → execute in IDE, file access, terminal, browser
  ```
- **Status:** Evaluated, bookmarked. Not started. Requirements: an adapter between Paperclip heartbeats and Antigravity SDK cascades.

### Tier 3: Ongoing improvements

**E. Workflow Refinements (after validation)**
- Expect to find friction points during the first real project run.
- Track them in a retro and batch-fix afterward.
- Common candidates: gate thresholds too strict, re-orientation points missing, prompt files too long for context window.

**F. CHANGELOG Maintenance**
- Current version: v0.4.0 (ship v2 + Pass 3 + audit fixes).
- Future changes should increment appropriately.

---

## Critical Things NOT to Do

1. **Don't modify Foundry repo for project-specific needs.** Foundry is evergreen. Project-specific wiring happens in the project's `PROJECT_WORKFLOW.md` and `IMPLEMENTATION_ROADMAP.md` at runtime.
2. **Don't weaken the gates.** Ship v2's coverage gate, plan completion audit, and verification gate exist for a reason. If the agent asks to skip them, always require explicit user approval.
3. **Don't add ETH-SKILL-GUIDE.md back to the Foundry repo.** It was deliberately removed. It lives standalone in Downloads and gets copied into individual project workspaces.
4. **Don't attempt Foundry Conductor before completing one full project with the single-agent workflow.** The sequential workflow needs validation first.

---

## Key File Locations

| File | Location |
|:-----|:---------|
| Foundry repo (local) | `/Users/lalo/Desktop/Homebase/bootstrap/` |
| Foundry repo (remote) | `https://github.com/laloquidity/foundry` |
| ETH-SKILL-GUIDE | `/Users/lalo/Downloads/ETH-SKILL-GUIDE.md` |
| Migration Bundle (Clarity) | Check `/Users/lalo/Desktop/` or `/Users/lalo/Downloads/` for ClarityScribe/Migration Bundle folders |

---

## How to Start a New Project with Foundry

```bash
# In a new, empty workspace:
git clone https://github.com/laloquidity/foundry .

# Then tell the agent:
/foundry-start
```

The agent reads `.foundry/SKILL.md` and begins Phase A (Interview). Everything flows from there.

If it's an Ethereum project, also copy ETH-SKILL-GUIDE.md into the workspace root before Phase A½.

---

*End of handoff. The next agent should read .foundry/SKILL.md and .foundry/templates/workflow_template.md in full before making any changes to Foundry itself.*
