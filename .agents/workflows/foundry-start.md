---
description: Bootstrap a new project using the full project-bootstrap skill
---

# /foundry-start — Project Bootstrap

This workflow initializes a new project using the project-bootstrap skill. It runs the full bootstrap sequence: product discovery, deep interview, CEO review, design consultation (if UI), persona generation, section extraction, implementation roadmapping, and build.

## Prerequisites

The `bootstrap/` folder must exist in your workspace with the full skill scaffolding:
```
bootstrap/
├── SKILL.md              ← master orchestrator
├── prompts/              ← all review & consultation prompts
├── scripts/              ← section extraction script
└── templates/            ← workflow template, interview guide
```

## Steps

1. Read the master orchestrator:
   ```
   Read bootstrap/SKILL.md in full — this is the master orchestrator for the entire process.
   ```

2. Execute the bootstrap phases in order as defined in `SKILL.md`:
   - **Phase 0: DISCOVER** — Run product discovery using `bootstrap/prompts/office_hours.md`. Adapts to startup or builder context. Output `DESIGN_DOC.md`. Client must approve before proceeding.
   - **Phase A: CAPTURE** — Generate seed personas from design doc, then run the deep interview using `bootstrap/templates/interview_guide.md` with multi-perspective Advisory Mode. Run the CEO review gate using `bootstrap/prompts/ceo_review.md`.
   - **Phase A½: SKILLS & WORKFLOWS** — Ask the user about existing skills/workflows to integrate.
   - **Phase A¾: DESIGN** *(UI projects only)* — Run design consultation using `bootstrap/prompts/design_consultation.md`. Output `DESIGN.md`.
   - **Phase B: SCAFFOLD** — Refine seed personas into full personas using `bootstrap/prompts/crowe_persona_generator.md` with full interview context.
   - **Phase C: STRUCTURE** — Extract sections using `bootstrap/scripts/extract_sections.py`. Build index and implementation roadmap.
   - **Phase D: WORKFLOW** — Copy `bootstrap/templates/workflow_template.md` to `PROJECT_WORKFLOW.md` and adapt for this project. Get user sign-off.
   - **Phase E: ROADMAP** — Create the detailed implementation roadmap (`IMPLEMENTATION_ROADMAP.md`). Wire every deliverable to specific context (section files + line ranges, spec IDs, personas, skills/prompts, review routing). Run eng review. User sign-off.
   - **Phase F: BUILD** — Execute the roadmap phase by phase. Each phase: context checkpoint → implement → verify → QA → ship → docs → interface contract check → complexity budget check → retrospective → next phase.

3. After Phase F is complete, the project is built, tested, documented, and shipped. `RETRO_LOG.md` captures learnings from every phase.

## Important

- **Do NOT skip phases.** Execute in order: 0 → A → A½ → A¾ → B → C → D → E → F.
- **Do NOT proceed past Phase E without explicit user sign-off on the roadmap.**
- **The design doc, interview, and roadmap are the sources of truth.** Everything traces back to `DESIGN_DOC.md`, `PROJECT_INTERVIEW.md`, and `IMPLEMENTATION_ROADMAP.md`.
- All prompts in `bootstrap/prompts/` are called at specific points — `SKILL.md` tells you exactly when.
