# Changelog

All notable changes to Foundry are documented here.

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
