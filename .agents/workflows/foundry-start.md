---
description: Bootstrap a new project using the full project-bootstrap skill
---

# /foundry-start — Project Bootstrap

This workflow initializes a new project OR resumes an in-progress project using the project-bootstrap skill. It auto-detects whether a Foundry session is already underway and handles both cases.

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

### Step 0: State Detection

1. **Check for existing checkpoint:**
   ```
   Check if .foundry/checkpoint.md exists in the workspace root.
   ```

2. **If `.foundry/checkpoint.md` does NOT exist → FRESH START:**
   - Create the `.foundry/` directory
   - Initialize `.foundry/checkpoint.md` with:
     ```markdown
     # Foundry Checkpoint

     ## Current State
     - Phase: 0
     - Step: 0
     - Status: STARTING
     - Last action: "Foundry session initialized"
     - Last commit: (none)
     - Timestamp: [current ISO timestamp]

     ## Completed Phases
     (none yet)

     ## Artifacts Produced
     (none yet)

     ## Open Items
     (none yet)

     ## Interview Progress
     (not started)
     ```
   - Proceed to **Step 1: Fresh Start** below.

3. **If `.foundry/checkpoint.md` EXISTS → RESUME:**
   - Read the checkpoint file in full
   - Report to the user:
     ```
     📍 Found existing Foundry session.
     - Last phase: [phase from checkpoint]
     - Last step: [step from checkpoint]  
     - Last action: [description from checkpoint]
     - Last active: [timestamp from checkpoint]
     ```
   - Proceed to **Step 0.5: Workspace Drift Scan** below.

---

### Step 0.5: Workspace Drift Scan (Resume Only)

> **Purpose:** Detect what changed in the workspace while Foundry was paused. The user may have done competitive analysis, investor prep, design research, or other work that should feed into Foundry's artifacts.

1. **Get the baseline commit:**
   - Read the `Last commit` hash from `.foundry/checkpoint.md`
   - If no commit hash (session was interrupted before first commit), use the initial commit of the repo

2. **Scan for changes:**
   ```bash
   # Committed changes since last Foundry action
   git diff --name-status <last_commit_hash> HEAD

   # Uncommitted modifications to tracked files
   git diff --name-only

   # New untracked files (the most common case)
   git ls-files --others --exclude-standard
   ```

3. **Categorize every detected file by impact:**

   **HIGH impact** — Foundry source-of-truth artifacts were modified:
   - `DESIGN_DOC.md`
   - `PROJECT_INTERVIEW.md`
   - `PERSONA_*.md`
   - `DESIGN.md`
   - `IMPLEMENTATION_ROADMAP.md`
   - `PROJECT_WORKFLOW.md`
   - `sections/*.md`

   **MEDIUM impact** — New or modified files that could inform the current phase:
   - Any `.md` file in the workspace root, `docs/`, `data-room/`, `research/`, or `notes/`
   - Any file explicitly referenced in the interview or roadmap
   - PRDs, specs, analysis documents, competitive research

   **LOW impact** — Normal development activity (note but don't interrupt):
   - Source code files (`.py`, `.ts`, `.js`, `.sol`, etc.)
   - Config files (`.json`, `.yaml`, `.toml`, `.env`)
   - Test files
   - Build artifacts, lock files
   - `.gitignore`, `README.md` (unless substantive changes)

4. **Present the scan results to the user:**

   ```markdown
   ## 🔍 Workspace Drift Scan

   **Since your last Foundry action** ([timestamp] — [description]):

   ### ⚠️ HIGH — Foundry Artifacts Modified
   - `PROJECT_INTERVIEW.md` (modified [date]) — This is a source-of-truth document.
     → Should Foundry adopt these changes? (y/n)

   ### 📄 MEDIUM — New Documents Found
   - `data-room/competitive-analysis.md` (new, [date])
   - `data-room/investor-qa-notes.md` (new, [date])
   - `research/rate-curve-v2.md` (new, [date])
     → Should any of these be ingested into the current Foundry phase? (list which ones, or "none")

   ### ℹ️ LOW — Development Activity (noted, no action needed)
   - 12 source files modified
   - 3 test files added
   ```

   If there are **zero changes** across all categories:
   ```
   ✅ No workspace changes detected since last Foundry action. Resuming from checkpoint.
   ```

5. **Reconcile HIGH-impact changes (if user confirms):**
   - `PROJECT_INTERVIEW.md` changed → run `/interview-update` to re-extract sections, then resume
   - `DESIGN_DOC.md` changed → re-run premise challenge on changed content, update interview if needed
   - `IMPLEMENTATION_ROADMAP.md` changed → re-run eng review on changed phases
   - `PERSONA_*.md` changed → note the change, have personas re-validate their domain during next review
   - `sections/*.md` changed → **STOP.** Section files are derived artifacts. Ask: "Did you edit a section file directly? Section files are auto-generated from the interview. Your changes will be overwritten on next extraction. Should I move your changes into PROJECT_INTERVIEW.md instead?"

6. **Ingest MEDIUM-impact files (if user selects any):**
   - For each file the user wants ingested:
     - Read the file in full
     - Run Prior Context Ingestion (PCI steps 1-3 from SKILL.md Phase A) against it
     - Append extracted content to `PROJECT_INTERVIEW.md` with attribution:
       ```markdown
       ### [Topic] (ingested from [filename], [date])
       [captured content]
       ```
     - Run `/interview-update` to re-extract sections
   - If the ingestion changes interview content that affects completed phases → flag: "This new information affects Phase [N] which is already complete. Should I re-verify the affected deliverables?"

7. **Resume from checkpoint:**
   - Continue from the exact phase and step recorded in `.foundry/checkpoint.md`
   - Update the checkpoint status to `IN_PROGRESS`
   - Proceed to the appropriate phase in SKILL.md

---

### Step 1: Fresh Start

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

---

### Step 2: Post-Completion

After all phases are complete:
- Update `.foundry/checkpoint.md` with final status:
  ```markdown
  ## Current State
  - Phase: COMPLETE
  - Status: ALL_PHASES_DONE
  - Last action: "All roadmap phases built, tested, and shipped"
  ```

---

## Important

- **Do NOT skip phases.** Execute in order: 0 → A → A½ → A¾ → B → C → D → E → F.
- **Do NOT proceed past Phase E without explicit user sign-off on the roadmap.**
- **The design doc, interview, and roadmap are the sources of truth.** Everything traces back to `DESIGN_DOC.md`, `PROJECT_INTERVIEW.md`, and `IMPLEMENTATION_ROADMAP.md`.
- All prompts in `prompts/` are called at specific points — `SKILL.md` tells you exactly when.
- **The Checkpoint Protocol in SKILL.md governs checkpoint writes.** Every commit in the bootstrap sequence updates `.foundry/checkpoint.md`. This is what makes resume work.
- **Workspace drift is normal.** Users will do work outside of Foundry between sessions. The drift scan ensures nothing falls through the cracks, but it should never feel like a blocker or an interrogation. Present changes, ask once, move on.
