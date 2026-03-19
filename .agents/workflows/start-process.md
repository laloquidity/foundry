---
description: Bootstrap a new project using the full project-bootstrap skill
---

# /start-process — Project Bootstrap

This workflow initializes a new project using the project-bootstrap skill. It runs the full bootstrap sequence: deep interview, CEO review, design consultation (if UI), persona generation, section extraction, and execution workflow creation.

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
   - **Phase A: CAPTURE** — Run the deep interview using `bootstrap/templates/interview_guide.md`, building on the design doc. Record every answer. Then run the CEO review gate using `bootstrap/prompts/ceo_review.md`.
   - **Phase A½: SKILLS & WORKFLOWS** — Ask the user about existing skills/workflows to integrate.
   - **Phase A¾: DESIGN** *(UI projects only)* — Run design consultation using `bootstrap/prompts/design_consultation.md`. Output `DESIGN.md`.
   - **Phase B: SCAFFOLD** — Generate personas using `bootstrap/prompts/crowe_persona_generator.md`.
   - **Phase C: STRUCTURE** — Extract sections using `bootstrap/scripts/extract_sections.py`. Build index and implementation roadmap.
   - **Phase D: WORKFLOW** — Copy `bootstrap/templates/workflow_template.md` to `PROJECT_WORKFLOW.md` and adapt for this project. Run engineering review using `bootstrap/prompts/eng_review.md`. Get user sign-off.

3. After Phase D is complete, the project has a `PROJECT_WORKFLOW.md`. Follow that file for all execution — it includes all review gates, QA steps, ship, and document release.

## Important

- **Do NOT skip phases.** Execute in order: 0 → A → A½ → A¾ → B → C → D.
- **Do NOT proceed past Phase D without explicit user sign-off.**
- **The design doc and interview are the sources of truth.** Everything traces back to `DESIGN_DOC.md` and `PROJECT_INTERVIEW.md`.
- All prompts in `bootstrap/prompts/` are called at specific points — `SKILL.md` tells you exactly when.
