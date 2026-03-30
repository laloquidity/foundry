---
description: Bootstrap a new project using the full project-bootstrap skill
---

# /foundry-start — Project Bootstrap

This workflow initializes a new project using the project-bootstrap skill. It runs the full bootstrap sequence: product discovery, deep interview, CEO review, design consultation (if UI), persona generation, section extraction, implementation roadmapping, and build.

## Prerequisites

The Foundry skill must be in your workspace root with the full scaffolding:
```
├── SKILL.md              ← master orchestrator
├── ETH-SKILL-GUIDE.md    ← Ethereum ethskills integration guide (onchain projects)
├── TOB-SKILL-GUIDE.md    ← Trail of Bits audit skills integration guide (smart contract projects)
├── ethskills/            ← locally pulled ethskills reference files (run scripts/pull_ethskills.sh)
├── tob-skills/           ← locally pulled Trail of Bits audit skills (run scripts/pull_tob_skills.sh)
├── prompts/              ← all review & consultation prompts
├── scripts/              ← section extraction + ethskills/tob pull scripts
└── templates/            ← workflow template, interview guide
```

## Steps

1. Read the master orchestrator:
   ```
   Read SKILL.md in full — this is the master orchestrator for the entire process.
   ```

2. Execute the bootstrap phases in order as defined in `SKILL.md`:
   - **Phase 0: DISCOVER** — Run product discovery using `prompts/office_hours.md`. Adapts to startup or builder context. Output `DESIGN_DOC.md`. Client must approve before proceeding.
   - **Phase A: CAPTURE** — If the user has existing PRDs/specs/context docs, run Prior Context Ingestion (PCI) first. Generate seed personas from design doc (for Ethereum projects, include an onchain seed persona and read ethskills context files before the interview), then run the deep interview using `templates/interview_guide.md` with multi-perspective Advisory Mode. Run the CEO review gate using `prompts/ceo_review.md`. If prior context docs were ingested, run the Reconciliation Gate to verify 100% content carry-over.
   - **Phase A½: SKILLS & WORKFLOWS** — Ask the user about existing skills/workflows to integrate. For Ethereum/onchain projects, read `ETH-SKILL-GUIDE.md` and wire ethskills into the workflow and roadmap. For smart contract projects, also read `TOB-SKILL-GUIDE.md` and wire Trail of Bits audit skills (dimensional analysis, spec-to-code compliance, entry point analysis, property-based testing, etc.) into the workflow and roadmap.
   - **Phase A¾: DESIGN** *(UI projects only)* — Run design consultation using `prompts/design_consultation.md`. Output `DESIGN.md`.
   - **Phase B: SCAFFOLD** — Refine seed personas into full personas using `prompts/crowe_persona_generator.md` with full interview context. For Ethereum projects, the onchain seed persona must be refined into a full Solidity/onchain specialist (mandatory for Step 3c sign-off).
   - **Phase C: STRUCTURE** — Extract sections using `scripts/extract_sections.py`. Build index and implementation roadmap.
   - **Phase D: WORKFLOW** — Copy `templates/workflow_template.md` to `PROJECT_WORKFLOW.md` and adapt for this project. Get user sign-off.
   - **Phase E: ROADMAP** — Create the detailed implementation roadmap (`IMPLEMENTATION_ROADMAP.md`). For Ethereum projects, each phase entry must include an `## EthSkills` section per the ETH-SKILL-GUIDE. Wire every deliverable to specific context (section files + line ranges, spec IDs, personas, skills/prompts, review routing). Run eng review. User sign-off.
   - **Phase F: BUILD** — Execute the roadmap phase by phase. Each phase: ethskills context load (Step 0f) → context checkpoint → implement → verify → QA → CSO security audit + ethskills audit (if routed) → production check (Step 4f) → ship → docs → interface contract check → complexity budget check → retrospective → next phase.

3. After Phase F is complete, the project is built, tested, documented, and shipped. `RETRO_LOG.md` captures learnings from every phase.

## Important

- **Do NOT skip phases.** Execute in order: 0 → A → A½ → A¾ → B → C → D → E → F.
- **Do NOT proceed past Phase E without explicit user sign-off on the roadmap.**
- **The design doc, interview, and roadmap are the sources of truth.** Everything traces back to `DESIGN_DOC.md`, `PROJECT_INTERVIEW.md`, and `IMPLEMENTATION_ROADMAP.md`.
- All prompts in `prompts/` are called at specific points — `SKILL.md` tells you exactly when.
