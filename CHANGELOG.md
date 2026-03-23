# Changelog

All notable changes to Foundry are documented here.

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
