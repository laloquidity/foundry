---
name: project-bootstrap
description: Universal project bootstrapping skill — from domain interview to production-ready execution workflow. Works for any project type.
---

# Project Bootstrap Skill

> **⚠️ EXECUTION DISCIPLINE: Do not skip ahead. Do not summarize. Do not assume. Go in order.**

This skill transforms a domain expert's knowledge into a structured, LLM-optimized project architecture. It solves the universal problem: **large context → lost detail → wrong implementation.**

## When to Use This Skill

Use this when starting ANY new project that involves:
- Complex domain knowledge that must be captured accurately
- Multiple implementation phases with inter-dependencies  
- Code that must match specifications precisely
- A need for persona-driven review and validation

Works for: trading systems, consumer apps, enterprise SaaS, iOS apps, terminal UIs, data pipelines, or any domain.

## Prerequisites

- A domain expert (the "client") available for interview
- A project directory initialized with git

## The Bootstrap Sequence

Execute these phases IN ORDER. Do not skip.

---

### Phase 0: DISCOVER

**Goal:** Validate what to build and why, before capturing how to build it.

1. **Run `prompts/office_hours.md`** — this runs a full product discovery session. It adapts to the user's context:
   - **Startup/intrapreneurship** → 6 Forcing Questions (Demand Reality, Status Quo, Desperate Specificity, Narrowest Wedge, Observation & Surprise, Future-Fit)
   - **Builder/hackathon/learning** → Generative design partner (coolest version, fastest path, 10x vision)

2. The session runs through:
   - Context gathering (what exists, what's the goal)
   - Product diagnostic OR design brainstorm (depending on mode)
   - Premise challenge (is this the right problem? what if we do nothing?)
   - **Mandatory** alternatives generation (2-3 distinct approaches with effort/risk/pros/cons)
   - Signal synthesis (what founder/builder signals appeared)

3. **Output: `DESIGN_DOC.md`** — saved to the project root. Contains problem statement, demand evidence (startup) or delight factor (builder), premises, chosen approach, open questions, success criteria, and the assignment.

4. **Client must APPROVE the design doc** before proceeding to Phase A.

5. **Commit:**
   ```bash
   git add DESIGN_DOC.md && git commit -m "Design doc: [project name]"
   ```

> **Skip condition:** If the user already has a fully formed plan or spec, skip to Phase A — but still run the Premise Challenge and Alternatives Generation from the office hours prompt. Even "simple" plans benefit from these checks.

---

### Phase A: CAPTURE

**Goal:** Extract all domain knowledge into a single canonical document. Use the `DESIGN_DOC.md` from Phase 0 as the foundation — the interview adds precision (thresholds, formulas, edge cases, decision rules).

1. **Create project directory** and initialize git:
   ```bash
   mkdir project-name && cd project-name && git init
   ```

2. **Generate Seed Personas** from `DESIGN_DOC.md`. The design doc from Phase 0 contains enough context (domain, target users, technical approach, constraints) to generate lightweight domain consultants:
   - Run `prompts/crowe_persona_generator.md` with the `DESIGN_DOC.md` as input
   - Generate 2-3 seed personas — these are domain-aware advisors, not full implementation personas
   - Seed personas provide **domain-specific recommendations** during the interview (step 4 below)
   - In Phase B, these seed personas get refined and expanded with the full interview context

3. **Run the Deep Interview** using `templates/interview_guide.md` as your structure. Ask every question. Record every answer. Capture exact thresholds, formulas, edge cases, decision rules.

4. **🧭 Advisory Mode — proactive, multi-perspective, inline with every question:**

   For every architectural or technical question, provide **recommendations from multiple perspectives** alongside the question. The seed personas and review skill perspectives all contribute.

   **How it works:**
   - Ask the question
   - Provide a **production-grade recommendation** from the most relevant perspective:
     - **Seed Persona view** — domain-specific advice based on the persona's expertise (e.g., a fintech persona recommends settlement patterns)
     - **CEO Review lens** (`prompts/ceo_review.md`) — strategic scope, dream state, reversibility
     - **Eng Review lens** (`prompts/eng_review.md`) — architecture, blast radius, failure modes
     - **Design lens** (`prompts/design_consultation.md`) — UX, interaction patterns (if UI-relevant)
   - Keep it concise — one recommendation with the key tradeoff, not a dissertation
   - The client confirms, adjusts, or picks a different path

   **Calibrate to domain:**
   - Consumer app → senior Apple PM standard
   - Onchain → principal Solidity architect (OpenZeppelin/Paradigm level)
   - SaaS → Stripe/Datadog infrastructure standard
   - Trading → quant desk production standard

   **Example:**
   ```markdown
   **Q: How should the system handle failed API calls to the data feed?**
   
   Recommendation: Exponential backoff with circuit breaker (3 failures 
   in 60s → circuit opens for 5m, falls back to cached data). This is 
   how production trading systems handle it — you never want a transient 
   API issue to cascade into missed signals. The alternative (immediate 
   retry) risks rate-limiting yourself.
   
   > **Client:** Agreed, but lower the circuit breaker to 2 failures — 
   > I'd rather fail fast and use cached data than risk stale signals.
   ```

   **Rules:**
   - No fluff. Real production recommendations only.
   - No shortcuts. If the right answer is complex, say so and explain why.
   - The interview captures the **DECISION** (what the client chose), not just the recommendation.
   - Client always has final authority.

5. **Save as `PROJECT_INTERVIEW.md`** — this becomes the canonical source of truth. EVERYTHING traces back to this document.

6. **Commit the interview:**
   ```bash
   git add PROJECT_INTERVIEW.md && git commit -m "Baseline: domain interview"
   ```

7. **🔍 CEO Review Gate** — Run the CEO review process using `prompts/ceo_review.md`. Present the captured interview to a CEO/Founder lens for premise challenge, dream state mapping, and scope validation.

   - The client selects a mode: **Expansion** (dream big), **Selective Expansion** (cherry-pick), **Hold Scope** (make bulletproof), or **Reduction** (cut to minimum)
   - Each proposed change is presented individually — client opts in or out
   - If changes are accepted, update `PROJECT_INTERVIEW.md` and run the `/interview-update` workflow to propagate changes through sections and index
   - All accepted changes are folded INTO the interview — the CEO review is a validation gate, not a separate document

---

### Phase A½: SKILLS & WORKFLOWS DISCOVERY

**Goal:** Identify any existing skills, workflows, or processes the user wants integrated into the project.

1. **Ask the user:**
   > "Do you have any existing skills, workflows, coding standards, simplification passes, deployment procedures, or other process documents that should be part of this project's development flow? These will be wired into the execution workflow alongside the personas."

2. **For each skill/workflow provided:**
   - Read and understand its purpose, triggers, and outputs
   - Determine WHERE in the execution workflow it applies:
     - Pre-implementation? (e.g., coding standards → Step 2c)
     - Post-implementation? (e.g., simplify loop → Step 2c½)
     - During verification? (e.g., audit checklists → Step 3)
     - Cross-cutting? (e.g., deployment workflows → every phase gate)
   - Document the mapping in the workflow template

3. **Wire them into the workflow** like personas — give each skill/workflow:
   - A named reference in the workflow (e.g., "Simplify Loop", "Deploy Check")
   - An explicit trigger point (when it runs)
   - Clear inputs and outputs
   - Authority level (mandatory vs optional, blocking vs advisory)

4. **Save to project:**
   ```bash
   # Copy relevant skill/workflow files to .agents/ directory
   cp -r user-provided-workflow.md .agents/workflows/
   git add .agents/ && git commit -m "Added user-provided skills and workflows"
   ```

---

### Phase A¾: DESIGN (UI Projects Only)

**Goal:** Establish the project's visual identity and design system before implementation begins.

> **Skip this phase** if the project has no user-facing interface (backend-only, CLI, data pipeline, headless).

1. **Run the Design Consultation** using `prompts/design_consultation.md` as the process guide. This is a conversation, not a form — the design consultant will:
   - Understand the product's audience, personality, and competitive landscape
   - Propose a complete design system: typography, color palette, spacing scale, motion strategy
   - Identify safe choices AND creative risks — the client picks which risks to take
   - Optionally generate an interactive HTML preview page

2. **Save as `DESIGN.md`** in the project root — this becomes the design source of truth.

3. **Commit:**
   ```bash
   git add DESIGN.md && git commit -m "Added design system"
   ```

> **Why here?** Design decisions inform the implementation structure. Running this before section extraction (Phase C) means design requirements can be captured in the interview and wired into the execution workflow. The design review prompt (`prompts/design_review.md`) can then audit the implementation against `DESIGN.md` during verification.

---

### Phase B: SCAFFOLD

**Goal:** Create domain-specific expert personas to validate the work.

1. **Identify 2-4 specialist roles** the project needs. Examples:
   - Trading system → Strategist + Engineer + Mathematician
   - Consumer app → UX Designer + Frontend Engineer + Backend Architect
   - SaaS → Product Owner + Security Engineer + Infrastructure Lead

2. **Generate personas** using the Crowe meta-prompt in `prompts/crowe_persona_generator.md`. For each role, prompt Crowe with:
   ```
   Create a persona for [exact role, domain, and specific requirements]
   ```

3. **Save persona files** to project root as `PERSONA_[NAME].md`

4. **Commit:**
   ```bash
   git add PERSONA_*.md && git commit -m "Added specialist personas"
   ```

---

### Phase C: STRUCTURE

**Goal:** Split the interview into focused, task-scoped chunks for high-fidelity context loading.

1. **Adapt the extraction script** from `scripts/extract_sections.py` for your project:
   - Update the `SECTIONS` list with your interview's `##` header patterns
   - Update spec IDs and cross-references for your domain
   - Run: `python3 -u extract_sections.py`
   - Verify: all sections PASS, each targeting ~2,500 tokens
   - **Splitting rules:** Split at `##` header boundaries (one topic per section). Never split mid-topic to hit the token target — if a topic needs 3,500 tokens to stay coherent, keep it whole. If a section exceeds ~5,000 tokens, review for natural sub-topic splits at `###` headers.

2. **Generate section index** — create `sections/_INDEX.md`:
   - List every section file with line range and token count
   - Create **Phase → Section Mapping** for each implementation phase
   - Include cross-references between interdependent sections

3. **Create implementation roadmap** — break the project into phases:
1.  **Adapt the extraction script** from `scripts/extract_sections.py` for your project:
    -   Update the `SECTIONS` list with your interview's `##` header patterns
    -   Update spec IDs and cross-references for your domain
    -   Run: `python3 -u extract_sections.py`
    -   Verify: all sections PASS, each targeting ~2,500 tokens (extend to preserve topical coherence; review sections exceeding ~5,000 tokens for sub-topic splits)

2.  **Generate section index** — create `sections/_INDEX.md`:
    -   List every section file with line range and token count
    -   Create **Phase → Section Mapping** for each implementation phase
    -   Include cross-references between interdependent sections

3.  **Create implementation roadmap** — break the project into phases:
    -   Phase 1: Foundation / Core (no dependencies)
    -   Phase 2+: Layered by dependency order
    -   Each phase lists specific deliverables and sub-deliverables
    -   Each deliverable traces to a spec ID

4.  **Map sections → phases** in the index:
    -   **Do NOT skip phases.** Execute in order: 0 → A → A½ → A¾ → B → C → D → E → F.
    ```markdown
    ### Phase 1: Core Build
    **Reads:**
    -   `01_section_name.md` — what it contains
    -   `05_another_section.md` — what it contains

    **Verification reads (after coding):**
    -   `12_case_study.md` — validate against known examples
    ```

5.  **Commit:**
    ```bash
    git add sections/ && git commit -m "Extracted sections, built index"
    ```

---

### Phase D: WORKFLOW

**Goal:** Generate the project-specific execution workflow that agents follow during coding.

1.  **Copy and adapt** `templates/workflow_template.md` to your project's `PROJECT_WORKFLOW.md`:
    -   Inject your persona roles into the Role Clarification table
    -   Update section file references for your project
    -   Configure the verification loop with your section files
    -   Set up the conflict resolution table for any ambiguities found during extraction
    -   Add the simplify loop from `prompts/simplify_loop.md` IF your project is NOT high-risk (see note below)
    -   **Verify all prompt file paths** — every reference like `prompts/eng_review.md` must resolve from the project root. Confirm that `prompts/`, `scripts/`, and `templates/` are accessible from where the agent runs.
    -   The workflow template already includes: engineering review (Step 1c), production review (Step 2g), design review (Step 3d), QA (Step 3e), ship (Step 4), and document release (Step 5)

2.  **Configure risk level:**
    -   **High-risk** (trading, medical, financial): Do NOT include the simplify loop. The verification loop (Step 2d) is sufficient. Any code cleanup happens as a deliberate, separate decision.
    -   **Standard-risk** (consumer apps, SaaS, tools): Include the simplify loop after each component, before verification.

3.  **Run the Engineering Plan Review** using `prompts/eng_review.md` — have the implementation roadmap reviewed with engineering manager rigor before finalizing the workflow. This catches architecture issues, scope creep, missing test plans, and failure modes.

4.  **Create the `/interview-update` workflow** — copy `templates/interview_update_workflow.md` to `.agents/workflows/interview-update.md` and adapt for your project's paths.

5.  **Wire up `/foundry-start`** — the bootstrap folder includes `.agents/workflows/foundry-start.md`. When copying the bootstrap folder to a new workspace, ensure this directory is included so `/foundry-start` works immediately.
    -   **Update the `foundry-start.md` workflow** to begin execution at Phase 0.

6.  **Persona review** — have each persona audit the workflow for gaps in their domain.

7.  **User approval** — do NOT proceed to execution without explicit sign-off.

8.  **Commit:**
    ```bash
    git add PROJECT_WORKFLOW.md .agents/workflows/ && git commit -m "Execution workflow finalized"
    ```

---

### Phase E: ROADMAP

**Goal:** Create a detailed implementation roadmap that wires every deliverable to specific context, personas, skills, and review gates. This is the battle plan.

1.  **Break the project into implementation phases** based on the dependency-ordered roadmap from Phase C:
    -   Each phase is a coherent unit of work that can be built, tested, and verified independently
    -   Dependencies between phases are explicit: "Phase 2 requires Phase 1's API surface"

2.  **For each phase, create a detailed entry:**
    ```markdown
    ## Roadmap Phase [N]: [Name]
    
    ### Deliverables
    - [ ] [Deliverable 1] — Spec ID: [ID]
    - [ ] [Deliverable 2] — Spec ID: [ID]
    
    ### Context Map
    - Section files: `sections/03_auth.md` (lines 12-45), `sections/07_api.md` (lines 1-30)
    - Interview references: `PROJECT_INTERVIEW.md` (lines 156-210) — auth decision rationale
    - Design references: `DESIGN.md` §4.2 — login flow mockup (if UI)
    
    ### Context Checkpoint (answer before building)
    1. What is the [specific threshold/rule] for [component]? (answer: from section file)
    2. What edge case did the client specify for [scenario]? (answer: from interview)
    3. What pattern/approach was chosen for [decision]? (answer: from design doc or interview)
    
    ### Personas Involved
    - [Persona A] — reviews [what]
    - [Persona B] — reviews [what]
    
    ### Skills & Prompts
    - Eng review: ✅ (new feature)
    - Production review: ✅
    - Design review: ⬚ Skip (backend only)
    - CSO security audit: ✅ | ⬚ Skip — route based on change type (see below)
    - QA mode: diff-aware
    - Debug: on-demand
    
    ### Security Classification
    - Touches auth/sessions/tokens: [yes/no]
    - Touches data handling/PII/payments: [yes/no]
    - Introduces external integrations: [yes/no]
    - Introduces new dependencies: [yes/no]
    - CSO mode: [--diff | full | --supply-chain | skip]
    
    **CSO routing rules:**
    | Change Type | CSO Mode |
    |:------------|:---------|
    | New feature (touches auth/data/external) | `--diff` |
    | New feature (no security surface) | Skip |
    | Backend API changes | `--diff` |
    | Bug fix | Skip |
    | Dependency introduction | `--supply-chain` |
    | Final phase (last roadmap phase) | Full audit |
    
    ### Interface Contract
    **Exposes to downstream phases:**
    - [API/function/module] — [what it provides]
    - [Data model/schema] — [what downstream phases depend on]
    
    **Depends on from upstream:**
    - Phase [N-1]: [what it needs to be stable]
    
    ### Complexity Budget
    - Estimated files: [N]
    - New abstractions: [N]
    - New dependencies: [N]
    - If exceeded → STOP and reassess
    ```

3.  **Run the Engineering Plan Review** using `prompts/eng_review.md` against the full roadmap. This catches:
    -   Phases that are too large (complexity budget too high)
    -   Missing dependencies between phases
    -   Context checkpoint questions that are too vague
    -   Interface contracts that are underspecified

4.  **User sign-off** — the roadmap is the contract. Do NOT proceed to Phase F without explicit approval.

5.  **Commit:**
    ```bash
    git add IMPLEMENTATION_ROADMAP.md && git commit -m "Implementation roadmap finalized"
    ```

---

### Phase F: BUILD

**Goal:** Execute the roadmap, phase by phase. Each phase follows the workflow: implement → verify → QA → CSO → repeat until done.

1.  **For each roadmap phase, prompt the agent:**
    ```
    Read PROJECT_WORKFLOW.md completely, then execute it starting at Step 0.
    You are implementing Roadmap Phase [N]. Follow every step exactly.
    Read IMPLEMENTATION_ROADMAP.md Phase [N] for your context map, 
    deliverables, checkpoint questions, security classification, and complexity budget.
    Do not skip ahead. Do not summarize. Do not assume.
    ```

2.  **Context checkpoint gate** (before any code):
    -   Read the retro log (`RETRO_LOG.md`) for all prior phases — apply learnings
    -   Answer the 3 context checkpoint questions from the roadmap entry
    -   If the phase has a security classification (touches auth/data/external) → also answer:
        - What authentication/authorization model applies to this phase's endpoints?
        - What data classification level does this phase handle (restricted/confidential/internal/public)?
        - What trust boundaries does this phase cross?
    -   If answers are wrong or uncertain → re-read the section files and interview references
    -   Only proceed when answers are correct

3.  The workflow handles execution from here:
    -   Step 0: Context loading (index, section files, spec registry, retro log)
    -   Step 1: Planning (deliverable checklist from roadmap) + smart review routing + eng review
    -   Step 2: Implementation (with /debug on-demand + continuous verification + production review)
    -   Step 3: Verification (quantitative proof + design audit + full QA loop)
    -   Step 3.5: CSO security audit (if routed for this phase — see security classification)
    -   Step 4: Ship (sync, test, coverage audit, commit, push)
    -   Step 5: Document release (post-ship documentation update)

    **Step 3.5: CSO Security Audit** (when routed):
    -   Run `prompts/cso.md` with the mode specified in the roadmap's security classification
    -   The CSO reads the phase's section files for spec-aware threat modeling
    -   If findings are CRITICAL or HIGH → enter **fix-verify-CSO cycle**:
        1. Agent fixes the finding (code change + unit test for the fix)
        2. Agent verifies the fix doesn't break existing tests
        3. CSO re-audits the specific finding (not full re-audit)
        4. Repeat until the finding is resolved or user accepts risk
    -   If this is the **final roadmap phase** → run CSO in full audit mode (cumulative, not diff)
        to catch cross-phase security interactions
    -   If this phase introduces new dependencies → also run `--supply-chain`

4.  **Interface contract verification** (after Step 3.5, before Step 4):
    -   Verify that the phase's interface contract is fulfilled — what it promised to expose to downstream phases exists and works
    -   If the interface drifted from the roadmap → update downstream roadmap entries before continuing

5.  **Complexity budget check** (after Step 3):
    -   Compare actual files/abstractions/dependencies against the roadmap budget
    -   If exceeded → document why, update the roadmap for downstream phases

6.  **Phase retrospective** (after Step 5, before starting next phase):
    -   Append to `RETRO_LOG.md`:
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
    - Interface contract: [fulfilled / drifted — describe]
    ```
    -   If "Assumptions to Re-Validate" has entries → run `/interview-update` workflow
    -   Commit: `git add RETRO_LOG.md && git commit -m "retro: Phase [N] complete"`

7.  **Run `/interview-update`** whenever the interview document grows with new information.

8.  **Repeat** for the next roadmap phase until all phases are complete.

---

### Phase F: EXTEND (Post-MVP)

For additional product surfaces (UI, bots, integrations):
1.  Create a SEPARATE PRD/interview document for each
2.  These consume the core engine's API/event bus
3.  Do NOT mix them into the original workflow
4.  Generate separate personas if the domain expertise differs

---

## File Reference

| File | Purpose |
|:-----|:--------|
| `SKILL.md` | This file — master orchestration |
| `prompts/crowe_persona_generator.md` | Dr. Julian Crowe persona generator meta-prompt |
| `prompts/simplify_loop.md` | Code simplification specialist (for standard-risk projects) |
| `prompts/office_hours.md` | Phase 0 product discovery — 6 Forcing Questions, premise challenge, alternatives |
| `prompts/ceo_review.md` | CEO/founder review — scope management, cognitive patterns, 6 deep review sections |
| `prompts/eng_review.md` | Engineering plan review — architecture, tests, diagrams, failure modes |
| `prompts/design_consultation.md` | Design system consultation — typography, color, spacing, motion (UI projects) |
| `prompts/design_review.md` | 80-item design audit with A-F scoring and AI slop detection (UI projects) |
| `prompts/production_review.md` | Production bug review — two-pass checklist with fix-first heuristic |
| `prompts/cso.md` | CSO security audit v2 — 15-phase audit: stack detection, OWASP Top 10, STRIDE, secrets archaeology, CI/CD pipeline, infrastructure, webhooks, LLM/AI security, skill supply chain, dependency scanning, zero-noise filtering |
| `prompts/qa.md` | Full QA: test → fix → verify loop, health score, regression tests, diff-aware mode |
| `prompts/debug.md` | Systematic debugging — Iron Law, root cause investigation, 3-strike escalation |
| `prompts/ship.md` | Release workflow — sync, test, coverage audit, commit, push |
| `prompts/document_release.md` | Post-ship documentation update — keeps all docs current |
| `scripts/extract_sections.py` | Header-anchored section extraction script template |
| `templates/workflow_template.md` | Execution workflow skeleton |
| `templates/interview_guide.md` | Structured interview question template |
| `templates/interview_update_workflow.md` | Ready-made `/interview-update` workflow template |
| `.agents/workflows/foundry-start.md` | One-command `/foundry-start` workflow — entry point for the entire bootstrap |
| `.agents/workflows/new-idea.md` | `/new-idea` workflow — capture new ideas with interview rigor, then propagate |

## Key Principles

1. **The interview splits on its OWN structure** (headers). The tasks/phases determine which sections to READ, not where to split.
2. **Section files are read-only derived artifacts.** Never edit them directly. Edit the interview, re-extract.
3. **Task-scoped reading** closes the context gap. Even the best models retain ~76% of buried details at scale. Focused sections ensure the agent reads exactly what it needs. Never load all sections at once.
4. **Verify against source** — every threshold, formula, and decision in code must trace back to the interview document.
5. **Personas debate, client decides.** The specialist personas provide analysis and recommendations. The human client has final authority on all domain decisions.
