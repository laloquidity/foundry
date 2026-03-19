# Foundry

**An agent-agnostic framework for building software with AI — from idea to production.**

Foundry takes a raw idea and runs it through a rigorous, multi-phase process: product discovery → deep interview → context extraction → detailed roadmap → build with continuous verification. Every phase is automatically prompted. Every decision traces back to a source of truth. Every review fires at the right time.

One command: `/start-process`. The rest handles itself.

---

## Why Foundry

Most AI coding tools start at "write code." Foundry starts at "what should we build and why?" — then carries that clarity through every line of code, every test, every review.

**The problem with vibe coding:** You get something fast, but it's fragile. No spec, no tests, no systematic review. One person's context, lost when the session ends.

**What Foundry does differently:**
- **Captures decisions, not just code.** Every architectural choice, threshold, and edge case is recorded in the interview and traced through implementation.
- **Context never gets lost.** The interview splits into scoped section files. Each build phase reads only what it needs — 95%+ detail retention vs. ~40% when agents read everything at once.
- **Reviews fire automatically.** CEO review, engineering review, design review, production review, QA, systematic debugging — all wired into the workflow at the right points. Smart routing skips reviews that don't apply.
- **The agent proves it understood before coding.** Context checkpoint gates require the agent to answer specific questions from the spec before writing any code.
- **Learning compounds.** Phase retrospectives feed into a retro log. Later phases benefit from earlier phases' execution experience.

---

## The Process

```
/start-process
    │
    ▼
Phase 0: DISCOVER ─── Product discovery (office hours)
    │                  6 Forcing Questions (startup) or design partner (builder)
    │                  Output: DESIGN_DOC.md
    ▼
Phase A: CAPTURE ──── Deep interview with multi-perspective Advisory Mode
    │                  Seed personas + CEO/eng/design review perspectives
    │                  Output: PROJECT_INTERVIEW.md
    ▼
Phase B: SCAFFOLD ─── Generate domain-expert personas
    │
    ▼
Phase C: STRUCTURE ── Extract interview into scoped section files
    │                  Build index + implementation roadmap
    ▼
Phase D: WORKFLOW ─── Generate PROJECT_WORKFLOW.md
    │                  (the execution manual for any agent)
    ▼
Phase E: ROADMAP ──── Detailed implementation plan
    │                  Context maps, checkpoint questions, interface contracts,
    │                  complexity budgets, persona assignments, review routing
    │                  Output: IMPLEMENTATION_ROADMAP.md
    ▼
Phase F: BUILD ────── Execute roadmap phase by phase
                       implement → verify → QA → ship → docs → retro
                       Repeat until complete
```

Every phase has explicit STOP gates where you approve before proceeding. The only manual work is answering questions and making decisions.

---

## What's Included

### Prompts (`prompts/`)

| Prompt | What It Does |
|:-------|:-------------|
| `office_hours.md` | Product discovery — 6 Forcing Questions, premise challenge, alternatives generation |
| `ceo_review.md` | CEO/founder review — 14 cognitive patterns, 6 deep review sections, scope management |
| `eng_review.md` | Engineering review — 15 cognitive patterns, 4 review sections, test plans, failure modes |
| `design_consultation.md` | Design system consultation — typography, color, spacing, motion |
| `design_review.md` | 80-item visual audit with AI slop detection and A-F scoring |
| `production_review.md` | Two-pass production bug audit with fix-first heuristic |
| `qa.md` | Full QA: test → fix → verify loop, health scoring, regression tests |
| `debug.md` | Systematic debugging — Iron Law, root cause investigation, 3-strike escalation |
| `ship.md` | Release workflow — sync, test, coverage audit, bisectable commits |
| `document_release.md` | Post-ship documentation update — keeps all docs current |
| `crowe_persona_generator.md` | Domain-expert persona generator |
| `simplify_loop.md` | Code simplification specialist (standard-risk projects) |

### Templates (`templates/`)

| Template | What It Does |
|:---------|:-------------|
| `workflow_template.md` | Execution workflow skeleton — Steps 0-6 with all review gates |
| `interview_guide.md` | Structured interview question template |
| `interview_update_workflow.md` | Mid-project interview update workflow |

### Workflows (`.agents/workflows/`)

| Workflow | What It Does |
|:---------|:-------------|
| `start-process.md` | Entry point — `/start-process` triggers the entire bootstrap |
| `new-idea.md` | `/new-idea` — capture new ideas mid-project with interview rigor |

### Other

| File | What It Does |
|:-----|:-------------|
| `SKILL.md` | Master orchestrator — defines every phase, step, and prompt |
| `scripts/extract_sections.py` | Header-anchored section extraction script |

---

## Quick Start

1. **Copy the `bootstrap/` folder** into your new project workspace
2. **Run `/start-process`** — the agent reads `SKILL.md` and begins Phase 0
3. **Answer questions** during discovery and interview phases
4. **Approve** at each STOP gate (design doc, interview, roadmap)
5. **Watch it build** — Phase F executes the roadmap with full review coverage

```
my-new-project/
├── bootstrap/          ← copy this folder
│   ├── SKILL.md
│   ├── .agents/workflows/
│   ├── prompts/
│   ├── templates/
│   └── scripts/
```

The `/start-process` workflow is auto-discoverable by agents that support the `.agents/workflows/` convention.

---

## Key Concepts

### Context Management
The interview document splits into scoped section files (each <2,500 tokens). Each build phase reads ONLY the sections relevant to its work — task-scoped reading enables 95%+ detail retention.

### Smart Review Routing
Not all reviews run for every phase. A routing table matches change types to appropriate reviews:

| Change Type | CEO | Eng | Design | Production | QA |
|:------------|:----|:----|:-------|:-----------|:---|
| New feature | ✅ | ✅ | ✅ | ✅ | ✅ |
| Backend only | Skip | ✅ | Skip | ✅ | ✅ |
| Bug fix | Skip | Skip | Skip | ✅ | ✅ |

### Context Checkpoints
Before coding each roadmap phase, the agent must answer 3 specific questions from the spec. If it can't answer correctly, it re-reads the source material. This prevents "fake reading."

### Interface Contracts
Each roadmap phase declares what it exposes to downstream phases and what it depends on from upstream. After building, the contract is verified. If it drifted, downstream entries get updated.

### Phase Retrospectives
After each build phase, a structured retro is appended to `RETRO_LOG.md` (what surprised us, patterns discovered, assumptions to re-validate). The next phase reads this before starting — creating a learning loop where later phases benefit from earlier execution experience.

---

## Methodology Credits

The review methodologies (CEO review, engineering review, design review, production review, QA, debug, ship, document release) are adapted from [GStack](https://github.com/garrytan/gstack) by Garry Tan. Foundry extends these with an end-to-end orchestration framework, context management system, implementation roadmapping, and learning loops.

---

## License

MIT
