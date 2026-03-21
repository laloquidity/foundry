# Foundry

> **Status: v0.1** The framework is complete and ready to use. Feedback and contributions welcome.

**An agent-agnostic framework for building software with AI — from idea to production.**

Foundry takes a raw idea and runs it through a rigorous, multi-phase process: product discovery → deep interview → context extraction → detailed roadmap → build with continuous verification. Every phase is automatically prompted. Every decision traces back to a source of truth. Every review fires at the right time.

One command: `/foundry-start`. The rest handles itself.

---

## Why Foundry

Most AI coding tools start at "write code." Foundry starts at "what should I build and why?" and carries that clarity through every line of code, every test, every review.

**The problem with vibe coding:** You get something fast, but it's fragile. No spec, no tests, no systematic review. One person's context, lost when the session ends.

**What Foundry does differently:**
- **Captures decisions, not just code.** Every architectural choice, threshold, and edge case is recorded in the interview and traced through implementation.
- **Context never gets lost.** The interview splits into scoped section files (~2,500 tokens each, one topic per section). Each build phase reads only what it needs. Even the best long-context models [retain only ~76% of buried details at 1M tokens](https://www.anthropic.com/news/claude-opus-4-6). Focused, task-scoped sections close that gap.
- **Reviews fire automatically.** CEO review, engineering review, design review, production review, QA, systematic debugging — all wired into the workflow at the right points. Smart routing skips reviews that don't apply.
- **The agent proves it understood before coding.** Context checkpoint gates require the agent to answer specific questions from the spec before writing any code.
- **Learning compounds.** Phase retrospectives feed into a retro log. Later phases benefit from earlier phases' execution experience.

---

## The Process

```
/foundry-start
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
| `foundry-start.md` | Entry point — `/foundry-start` triggers the entire bootstrap |
| `new-idea.md` | `/new-idea` — capture new ideas mid-project with interview rigor |

### Other

| File | What It Does |
|:-----|:-------------|
| `SKILL.md` | Master orchestrator — defines every phase, step, and prompt |
| `scripts/extract_sections.py` | Header-anchored section extraction script |

---

## How To Use

### Prerequisites
- An AI coding IDE that supports slash commands or workflow files (Cursor, Windsurf, Claude Code, Copilot Workspace, or any agent that reads `.md` prompts)
- Git installed
- A project idea

### Setup

```bash
# 1. Clone this repo into your new project
git clone https://github.com/YOUR_USERNAME/foundry.git my-project
cd my-project

# 2. Open in your IDE
# Cursor, Windsurf, VS Code, etc.
```

### Run It

1. **Open your AI agent** in the project directory
2. **Type `/foundry-start`** — the agent reads `SKILL.md` and begins Phase 0 (product discovery)
3. **Answer questions** during discovery and interview phases — this is the only manual work
4. **Approve** at each STOP gate (design doc, interview, roadmap)
5. **Watch it build** — Phase F executes the roadmap with full review coverage

The framework generates these files as it runs:

```
my-project/
├── DESIGN_DOC.md              ← Phase 0 output (product discovery)
├── PROJECT_INTERVIEW.md       ← Phase A output (deep specification)
├── sections/                  ← Phase C output (context-scoped chunks)
│   └── _INDEX.md
├── PROJECT_WORKFLOW.md        ← Phase D output (execution manual)
├── IMPLEMENTATION_ROADMAP.md  ← Phase E output (detailed battle plan)
├── RETRO_LOG.md               ← Phase F output (learning loop)
└── src/                       ← Phase F output (your actual code)
```

### Compatibility

Foundry works with any AI coding tool that can read markdown files. Tested with:
- **Cursor** — use `/foundry-start` in chat
- **Windsurf** — use `/foundry-start` in Cascade
- **Claude Code** — reference `SKILL.md` directly
- **Any LLM** — paste `SKILL.md` as the system prompt, it handles the rest

---

## Key Concepts

### Context Management
The interview document splits into focused section files (each targeting ~2,500 tokens, one topic per section). Each build phase reads only the sections relevant to its work. Sections never split mid-topic. If a topic needs more tokens to stay coherent, it stays whole. Even Claude Opus 4.6 [scores 76% on MRCR v2 at 1M tokens](https://www.anthropic.com/news/claude-opus-4-6). Focused sections close that gap.

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

The product discovery and review methodologies (CEO review, engineering review, design review, production review, QA, debug, ship, document release) are adapted from [GStack](https://github.com/garrytan/gstack) by Garry Tan. Foundry extends these with an end-to-end orchestration framework, persistent context architecture, implementation roadmapping, and learning loops.

---

## License

MIT
