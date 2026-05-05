# Changelog

All notable changes to Foundry are documented here.

---

## [0.7.1] - 2026-05-05 — Gstack Sync (Decision Briefs & Hard Gates)

### Added
- **Decision Brief Format.** All review prompts (eng review, CEO review, design review, production review) now prescribe a structured format for presenting findings: D-numbered title, ELI10 explanation, stakes, recommendation with substance, per-option ✅/❌ pros/cons, and a closing "Net:" tradeoff line. Prevents agents from dumping findings as free-form prose. Adapted from [GStack v1.10.0.0 through v1.25.0.0](https://github.com/garrytan/gstack).
- **Recommendation substance rule.** The "because" clause in every recommendation MUST compare against a specific alternative or name a concrete tradeoff. "Because it's better" or "because it's faster" is explicitly called out as filler. Applied across all 4 review prompts.
- **Coverage vs kind distinction.** Coverage-differentiated options get `Completeness: N/10` scores. Kind-differentiated options (architecture forks, mode selections) get "options differ in kind" notes instead of fabricated scores.
- **Synthesis Recommendation in eng review.** Required Outputs now includes a mandatory one-line `Recommendation: [ship / fix-then-ship / redesign] because [specific tradeoff]` — the single line someone should read if they read nothing else.
- **PR title format in ship.** Step 7 (Push and Report) now specifies `<type>: <component> — <what was done>`, matching the primary commit message. Prevents the "feat: various improvements" anti-pattern.

### Changed
- **Hard STOP gates replace soft prose.** All "STOP after each issue" instructions in eng review, CEO review, and office hours upgraded to explicit anti-rationalization blocks: `**STOP.** Do NOT batch. Do NOT continue. Do NOT skip because the answer seems obvious.` This is the exact pattern gstack discovered models route around across three releases (v1.15.0.0 → v1.21.1.0 → v1.25.0.0). Models rationalize past soft stops by deciding a finding is "clearly correct" and batching everything into a summary.
- **Phase 4 anti-auto-decide gate in office hours.** The alternatives presentation now has an explicit STOP gate naming blocked next steps: do NOT proceed to Signal Synthesis, do NOT proceed to Design Doc, do NOT select an approach on the user's behalf. A "clearly winning approach" is still a user decision.

### Upstream reference
Synced from gstack changelog v1.3.0.0 through v1.28.0.0+. Of ~30K lines of changelog reviewed, ~90% was gstack-specific infrastructure (gbrain memory, browser skills, PTY harness, security classifiers, Windows portability). The transferable methodology improvements converge on one root failure: **models route around soft instructions by rationalizing.** Fix: explicit format + explicit blocked actions + anti-rationalization clauses.

---

## [0.7.0] - 2026-04-27 — Namespace Migration & Install Script

### Breaking
- **All framework files moved into `.foundry/` directory.** `SKILL.md` → `.foundry/SKILL.md`, `prompts/` → `.foundry/prompts/`, `templates/` → `.foundry/templates/`, `scripts/` → `.foundry/scripts/`. This prevents collisions with user projects that already have `SKILL.md`, `prompts/`, or `scripts/` directories. All internal path references updated.
- **`git clone` is no longer the installation method.** Replaced with a curl-based install script that drops framework files into `.foundry/` and `.agents/workflows/` without touching the user's README, git history, or existing files.

### Added
- **`install.sh` — curl-based installer.** `bash <(curl -sL .../install.sh)` installs Foundry into any project directory (new or existing). Supports `--update` to pull the latest version. Zero root-level files dropped into the user's project.
- **Roadmap is the checklist (not a shadow copy).** Step 1 no longer creates an ephemeral deliverable checklist. Agents mark `[x]` directly in `IMPLEMENTATION_ROADMAP.md`. Step 2a.4, Step 2c, and Step 4d all explicitly name the roadmap file. Fixes the "two-list problem" where the roadmap stayed stale while a conversation-scoped checklist evaporated.
- **Deliverable count in checkpoint.** `.foundry/checkpoint.md` now includes `Deliverables: [completed]/[total]` with a pointer to the roadmap file.
- **`/curate` arc-first methodology.** New Step 3 (Find the arc, not just the signals) teaches agents to identify the narrative throughline before extracting individual signals. Includes multiplier naming, threshold/unlock framing, and an Arc Test as an additional Gatekeeper pass. Also adds voice internalization (read reviewed drafts for voice, not just dedup) and live session extraction guidance.

### Changed
- **README rewritten.** Install instructions, file structure, and all path references updated to reflect `.foundry/` layout. Version bumped to v0.7.0.
- **Plan Completion Audit (Step 4d) now writes back to the roadmap.** Marks DONE items `[x]`, PARTIAL items `[/]` with a note. Previously read-only.
- **Reset instruction updated.** "Delete `.foundry/checkpoint.md`" instead of "delete the entire `.foundry/` directory" since the directory now contains framework files.

---

## [0.6.0] - 2026-04-18 — Gstack Sync (Methodology Hardening)

### Added
- **Confusion Protocol.** Inline ambiguity gate in the workflow template. When the agent hits a high-stakes decision that could go two ways (architecture forks, data model ambiguity, destructive operations, security-sensitive choices), it STOPS and presents the fork with tradeoffs instead of guessing. Addresses Karpathy's #1 AI coding failure mode. Adapted from [GStack v0.17.0](https://github.com/garrytan/gstack).
- **Skill Execution Priority preamble.** Added to all 8 primary prompts (workflow template, ship, eng review, CEO review, production review, design review, QA, CSO). Ensures loaded prompts take precedence over plan mode or generic agent behavior. STOP points now actually stop. Adapted from [GStack v0.15.9](https://github.com/garrytan/gstack).
- **Anti-Skip Rule.** Added to all 4 review prompts (eng, CEO, production, design). Models can no longer skip review sections by claiming "this section doesn't apply to this plan type." Every section must be explicitly evaluated or have a one-sentence "No findings" justification. Adapted from [GStack v0.16.1](https://github.com/garrytan/gstack).
- **Scope Drift Detection (Step 5.5).** New step in `prompts/ship.md` that catches unplanned additions — the inverse of plan completion. Classifies unplanned changes as INCIDENTAL (acceptable), SCOPE CREEP (needs decision), or YOLO FIX (discovered during build). Adapted from [GStack v0.15.5](https://github.com/garrytan/gstack).
- **Adversarial Review (Step 3.6).** New step in the workflow template. Attacker-mindset review + chaos engineering pass after CSO, before ship. Always runs regardless of diff size — diff size is not a good proxy for risk. Adapted from [GStack v0.15.5](https://github.com/garrytan/gstack).
- **UX Behavioral Tests (Phase 4.5).** 6 usability tests added to `prompts/design_review.md` based on Steve Krug's "Don't Make Me Think": Trunk Test, 3-Second Scan, Page Area Test, Happy Talk Detection, Mindless Choice Audit, Goodwill Reservoir tracking. Adapted from [GStack v0.17.3](https://github.com/garrytan/gstack).
- **Finding Dedup Rule.** Added to workflow template review routing. Prevents the same finding from being re-surfaced across multiple reviews within the same phase when the code hasn't changed. Adapted from [GStack v0.16.0](https://github.com/garrytan/gstack).

### Changed
- **Communication Quality Standard expanded.** Added outcome-framing rule (frame questions in user-outcome terms, not abstract technical language) and explain-on-first-use rule (gloss technical terms when first used). Adapted from [GStack v1.0.0](https://github.com/garrytan/gstack).
- **Production review renamed from "Two-Pass" to "Three-Pass"** to accurately reflect the existing three-pass structure (Critical, Informational, Operational). Added specialist review pattern note for large diffs (200+ lines): treat each pass as a separate specialist review with fresh focus.
- **Workflow build loop expanded:** Step sequence is now `implement → verify → QA → CSO → Adversarial Review → Ship` (was `implement → verify → QA → CSO → Ship`).

---

## [0.5.5] - 2026-04-15 — Gatekeeper (Chief Editor)

### Added
- **Gatekeeper persona (`prompts/content_editor.md`).** Chief Editor that runs a 5-pass editorial review on all Signal Miner drafts before a human sees them: VC Signal Test, Engineer Accuracy Test, AI Pattern Sweep, Platform Fit Check, Credibility Gut Check. Verdicts: APPROVED, REVISE, or KILL.
- **`/curate` workflow updated.** Added Step 5: Gatekeeper review between draft creation and commit. Pipeline is now Signal Miner → Gatekeeper → Human.

---

## [0.5.4] - 2026-04-13 — Editorial Guide Hardening

### Changed
- **Parallelism rule expanded.** Both directions of contrastive phrasing now flagged as AI tells: "Not X, it's Y" AND "X, not Y." Checklist item updated. Content curator persona updated to match.
- **Inline-header rule expanded.** Added three explicit alternatives (lists, ordinal prose, sub-headings) for achieving visual separation without the AI-typical bold-lead pattern.

### Added
- **Invented time frames rule.** Do not fabricate how long something took. "I spent weeks modeling..." assigns unverified duration. State the work itself if countable, omit duration if not known with certainty. Added to `editorial_guide.md` (tone mistakes + checklist item 11) and `content_curator.md`.

---

## [0.5.3] - 2026-04-13 — Session Continuity

### Added
- **Checkpoint Protocol.** Every commit updates `.foundry/checkpoint.md` with current phase, step, artifacts, open items, and interview progress. Amended into the phase commit to keep git history clean.
- **`/foundry-start` auto-detection.** Detects fresh vs. resume via checkpoint file. On resume, runs workspace drift scan (`git diff` + untracked files), classifies changes by impact (HIGH/MEDIUM/LOW), and reconciles accepted changes into Foundry artifacts before continuing.
- **`/foundry-resume` workflow.** Convenience alias for the resume path. Reports "no session found" if no checkpoint exists.

---

## [0.5.2] - 2026-04-10 — Content Pipeline

### Added
- **Signal Miner persona (`prompts/content_curator.md`).** Mines Foundry artifacts (interview, design doc, retro log, section files) for genuine first-principles insights. Produces X Article and Post drafts ready for human review. Anti-AI-slop rules embedded: no manufactured enthusiasm, no listicle structure, no "journey" framing, no performance of expertise.
- **Content pipeline wired into lifecycle.** 4 opt-in trigger points in `SKILL.md`: Post-Interview, Post-Design, Post-Architecture, Post-Phase Retro. Cumulative awareness: later passes read existing drafts to skip already-covered signals.
- **`/curate` workflow (`.agents/workflows/curate.md`).** Standalone curation pass for ad-hoc use outside phase gates. Supports extended source material: `data-room/`, conversation extracts, external analyses.
- **Routing table updated.** Content Curation column added to the review routing table in `workflow_template.md`. Step 6c½ added for post-retro curation.

---



## [0.5.1] - 2026-03-27 — Living Documentation Suite

### Added
- **`prompts/project_docs.md`** — New prompt that generates professional, external-facing documentation from `DESIGN_DOC.md` and `PROJECT_INTERVIEW.md`. Produces four documents: Product Brief (one-pager), Investor Memo (thesis, market, risks), Technical Overview (architecture, decisions), and README draft. Includes source mapping (every claim traces to interview), gap reporting, and an incremental update protocol for keeping docs current as the project evolves.
- **Phase A step 10** — Initial project docs generation wired into the bootstrap lifecycle after the Reconciliation Gate. Re-run after each build phase or substantive interview update.
- **Communication Quality Standard** — Banned AI vocabulary (20 words), banned phrases (7), concreteness rules, and user outcome connection in the workflow template.

---

## [0.5.0] - 2026-03-26 — Prior Context Ingestion

### Added
- **Prior Context Ingestion (PCI).** Phase A now supports ingesting existing PRDs, specs, and context documents with 100% detail carry-over. Four sub-steps: full document read (PCI-1), structured extraction into manifest (PCI-2), gap analysis against interview sections (PCI-3), and adaptive interview mode that confirms pre-filled content instead of re-asking (PCI-4). Verbatim preservation rule ensures exact thresholds, formulas, and technical values are never paraphrased.
- **Reconciliation Gate.** New gate at end of Phase A verifies every substantive item from source documents is either CAPTURED in the interview, EXPLICITLY DEFERRED, or surfaced as MISSING for client decision. Zero MISSING items required to proceed.
- **Section 16: Prior Context & Business Intelligence.** New interview guide section for capturing source document content that doesn't map to Sections 1-15 (competitive analysis, historical context, business constraints, stakeholder requirements, prior art).
- **Source provenance tracking.** Verification loop (Step 2e in workflow) now tracks whether specs originated from the live interview or an ingested source document.
- **Source Documents field in design doc templates.** Both startup and builder mode design docs now list source documents for Phase A handoff traceability.

### Changed
- Phase A step numbering updated: Prior Context Ingestion is step 3, Deep Interview is step 4, Advisory Mode is step 5, Save is step 6, Commit is step 7, CEO Review is step 8, Reconciliation Gate is step 9.
- Office Hours (Phase 0) context gathering enhanced to treat existing PRDs as primary input, not background reading.
- Interview guide gains principle 9 (ingest before interviewing) and three new post-interview checklist items for source document reconciliation.

---

## [0.4.0] - 2026-03-26 — Ship With Teeth

### Added
- **Test failure ownership triage.** `/ship` now classifies test failures as in-branch (your code broke it, must fix) or pre-existing (not your fault, can triage). Uses `git stash` to isolate ownership.
- **Coverage gate with hard thresholds.** AI-assessed coverage below 60% is a hard stop. 60-79% gets a prompt. 80%+ passes. Adapted from [GStack 0.11.18.0](https://github.com/garrytan/gstack).
- **E2E test decision matrix.** Coverage audit now recommends E2E tests for multi-component user flows, integration points where mocking hides real failures, and auth/payment/data-destruction flows.
- **Regression rule (iron law).** When the coverage audit identifies a regression — code that previously worked but the diff broke — a regression test is written immediately. No asking. No skipping.
- **Plan completion audit.** `/ship` reads `IMPLEMENTATION_ROADMAP.md`, extracts every actionable item from the current phase, cross-references against the diff, and produces a DONE/PARTIAL/NOT DONE/CHANGED checklist. Missing items are a shipping blocker (with override).
- **Verification gate before push.** If ANY code changed after Step 3's test run (coverage tests, review fixes), tests must re-run with fresh output before pushing. "Confidence is not evidence."
- **Bisectable commit ordering.** Commits are now ordered by dependency: infrastructure → models/services → controllers/views → docs/metadata. Each commit must be independently valid.
- **Test framework auto-detection.** Ship detects runtime (Node, Python, Ruby, Go, Rust) and test framework before the coverage audit, enabling automatic test generation.
- **User flow coverage mapping.** Coverage audit now traces user interaction flows alongside code paths — double-click, navigate-away, empty/zero states, error UX.

### Changed
- Ship workflow expanded from 6 steps to 7.5 steps (1 → 2 → 3 → 4 → 5 → 6 → 6.5 → 7).
- Coverage audit upgraded from a simple diagram to a full gate with threshold enforcement.
- Test failures are now triaged instead of being an unconditional hard stop.

---

## [0.3.0] - 2026-03-23 — CSO v2 + Operational Hardening

### Added
- **CSO upgraded to v2.** Complete rewrite of the security audit from [GStack](https://github.com/garrytan/gstack): 15 phases (up from 8), stack-aware scanning, secrets archaeology, CI/CD pipeline security, infrastructure shadow surface, webhook & integration audit, LLM/AI security, skill supply chain scanning, variant analysis, incident response playbooks, parallel finding verification, and structured JSON report with trend tracking. 22 hard exclusions (up from 17), 12 precedents (up from 9). All 4 community-reported blind spots fixed: stack detection first, Grep tool not raw bash, no `head -20` truncation, context-window-aware scope flags (`--infra`, `--code`, `--skills`, `--supply-chain`, `--owasp`).
- **Production review Pass 3 — OPERATIONAL.** New third pass covering 10 scaling/resilience problems that survive CI: rate limiting & abuse prevention, database performance (indexing, pagination, connection pooling), error resilience (error boundaries, graceful degradation), environment validation (startup checks, `.env.example`), async patterns (queue/worker for slow ops, CDN strategy), and observability (health checks, structured logging, backup strategy, alerting).
- **Fix-first heuristic expanded.** AUTO-FIX items now include adding DB indexes, health check endpoints, error boundary wrappers, and `.env.example` files. ASK items include rate limiting strategy, CDN/infrastructure changes, and backup schedule decisions.

### Changed
- Report save path changed from `.gstack/security-reports/` to `.foundry/security-reports/`.
- CSO description in SKILL.md file reference table updated to reflect v2 scope.
- `bootstrap/` path prefix removed from all file references in `foundry-start.md` — repo now works universally after cloning regardless of directory name.
- Phase D path instruction changed from "update all prompt file paths" to "verify all prompt file paths resolve from the project root."

---

## [0.2.0] - 2026-03-22 — CSO Security Audit Integration

### Added
- **`/cso` — Chief Security Officer audit.** Full codebase security audit adapted from [GStack](https://github.com/garrytan/gstack): OWASP Top 10 assessment, STRIDE threat modeling, attack surface mapping, data classification, and dependency scanning. Each finding requires a concrete exploit scenario, 8/10+ confidence score, and independent verification. Zero-noise false positive filtering with 17 hard exclusions and 9 established precedents.
- **Security classification in roadmap.** Each implementation phase now declares whether it touches auth/sessions, data/PII, external integrations, or new dependencies. This determines which CSO mode fires (`--diff`, `--supply-chain`, full audit, or skip).
- **Step 3.5 in build loop.** CSO audit runs after QA, before ship. Prevents shipping code with unresolved security findings.
- **Fix-verify-CSO remediation cycle.** If the CSO finds CRITICAL or HIGH findings, the agent fixes, verifies the fix, then CSO re-audits the specific finding. Repeats until resolved or user accepts risk.
- **Cumulative full audit at final phase.** Per-phase audits use `--diff` mode. The final roadmap phase triggers a full cumulative audit to catch cross-phase security interactions.
- **Supply chain scanning.** Phases that introduce new dependencies automatically trigger `--supply-chain` mode.
- **Spec-aware threat modeling.** The CSO reads the phase's section files for context, enabling threat modeling against the intended design rather than just pattern matching against code.
- **Security-specific checkpoint questions.** Phases touching auth/data/crypto get additional checkpoint questions (auth model, data classification level, trust boundaries) before coding starts.
- **Security column in review routing table.** Both SKILL.md and the workflow template route CSO by change type alongside existing reviews.
- **CSO findings in retro metrics.** Phase retrospectives now track security findings count alongside QA health score and complexity budget.

### Changed
- Build loop sequence updated from `implement → verify → QA → ship` to `implement → verify → QA → CSO → ship`.
- Review routing tables in README, SKILL.md, and workflow template now include Security (CSO) column.

---

## [0.1.1] - 2026-03-21 — README Alignment

### Changed
- Updated README to align with finalized article: sourced 76% MRCR v2 benchmark replaces unverified 95% retention claim.
- Fixed pronouns ("we" → "I") and added product discovery to methodology credits.
- Added Phase A½ (Skills & Workflows) and Phase A¾ (Design) to the process diagram.
- Repository made public.

---

## [0.1.0] - 2026-03-18 — Initial Release

### Added
- Complete Foundry framework: SKILL.md orchestrator, 12 prompt files, workflow template, interview guide, section extraction script.
- Multi-phase process: Discover → Capture → Scaffold → Structure → Workflow → Roadmap → Build.
- Persistent context architecture: interview splitting, section files, spec registry, context checkpoint gates.
- Smart review routing: CEO, engineering, design, production, QA reviews fire based on change type.
- Phase retrospectives with learning compounding across the build.
- `/foundry-start` one-command entry point.
