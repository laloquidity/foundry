# Project Docs — Living Documentation Suite

> Run this after Phase A (Capture) to generate the initial documentation suite. Re-run after any substantive interview update, new-idea integration, or phase completion to keep docs current. This produces **external-facing** documents, not engineering artifacts.

## Philosophy

The interview and design doc contain everything. Product vision, target audience, technical architecture, differentiation, constraints, edge cases. But they're written for the agent, not for humans outside the build process.

This prompt turns that raw material into polished, professional documents that communicate the project to different audiences: investors, technical partners, users, and the team itself. Each document serves a specific reader with specific questions.

**Source fidelity rule:** Every claim, number, threshold, and positioning statement in the output docs traces back to `DESIGN_DOC.md`, `PROJECT_INTERVIEW.md`, or the section files. Do not invent positioning. Do not add features that aren't in the interview. Do not project traction that doesn't exist. If the source material doesn't contain something a document needs, flag it as a gap for the client.

**Only stop for:**
- Positioning or narrative decisions (how to frame the product for investors vs. users)
- Missing information that the source documents don't cover
- Competitive claims that need client validation
- Tone/voice preferences for external-facing docs

**Never stop for:**
- Reformatting source material into document structure
- Technical accuracy checks against the interview
- Cross-document consistency fixes

---

## Step 0: Context Loading

Read the source documents in this order:

1. `DESIGN_DOC.md` — problem statement, demand evidence, chosen approach, success criteria
2. `PROJECT_INTERVIEW.md` — full domain knowledge, exact specs, decisions, edge cases
3. `sections/_INDEX.md` — understand the topical breakdown
4. Section files for: project identity, user flows, architecture, data model, failure modes, build priorities (load only the relevant sections, not all)
5. `PERSONA_*.md` — understand the domain expert perspectives
6. `DESIGN.md` (if exists) — visual identity and design system

**If this is an UPDATE run (not initial generation):** also read:
- The existing `docs/` directory contents
- The diff since the last docs update: `git log --oneline docs/`
- Any new interview content or `/new-idea` additions

---

## Step 1: Audience Analysis

Before writing anything, identify the audiences from the source material:

```markdown
## Audience Map
- **Investors/Advisors:** [what they care about — market, traction, team, differentiation]
- **Technical Partners/Hires:** [what they care about — architecture, stack, scale, craft]
- **Users/Customers:** [what they care about — what it does, how to use it, why it matters to them]
- **Team/Contributors:** [what they care about — how to build, test, deploy, contribute]
```

Present the audience map to the client for validation. Different projects weight these differently — a developer tool weights technical partners heavily; a consumer app weights users heavily.

---

## Step 2: Generate the Documentation Suite

Generate each document in order. After each document, present it to the client for review before proceeding to the next.

### 2a. Product Brief

**Audience:** Anyone encountering the project for the first time. Investors, partners, potential users, press.

**Format:** One page. Maximum 500 words. Every word earns its place.

```markdown
# [Project Name]

## One-Liner
[What it is in one sentence. Not what it does technically — what it means for the user.]

## The Problem
[2-3 sentences. What's broken, painful, or missing today. Use specifics from the
interview's demand evidence and the office hours problem statement. Real numbers
if available.]

## The Solution
[2-3 sentences. What the product does, concretely. Not features — outcomes.
"You get X" not "We provide X".]

## Who It's For
[Primary audience from the interview. Be specific — not "businesses" but
"solo developers shipping side projects who need CI but hate Jenkins".]

## Why Now
[What changed that makes this possible/necessary now. Technology shift, market
shift, regulatory shift, behavioral shift. From the design doc premises.]

## How It Works
[3-4 bullet points. The core mechanics, explained simply. Draw from the
interview's architecture and user flow sections.]

## What Makes It Different
[2-3 bullet points. Genuine differentiation from the design doc's alternatives
analysis. Not "we're better" — what specific tradeoff do you make that
competitors don't?]

## Current Status
[Where the project is right now. Honest. "Phase 2 of 5 complete" or
"MVP live with 3 beta users" or "Design complete, build starting".]
```

**Source mapping:**
- One-Liner → Interview Section 1 (Project Identity)
- The Problem → Design Doc "Problem Statement" + Office Hours demand evidence
- The Solution → Interview Section 2 (Core Logic) + Design Doc "Recommended Approach"
- Who It's For → Interview Section 1 (Project Identity) + Section 3 (User Flows)
- Why Now → Design Doc "Premises" + Office Hours context
- How It Works → Interview Sections 2, 4, 5 (Core Logic, Architecture, Data Model)
- What Makes It Different → Design Doc "Approaches Considered" + "Recommended Approach"
- Current Status → current phase in the build process

### 2b. Investor Memo

**Audience:** Investors, advisors, board members. People who evaluate whether this is worth funding, joining, or advising on.

**Format:** 2-3 pages. Structured for quick scanning. Lead with the hook.

```markdown
# [Project Name] — Investor Memo

## Thesis
[One paragraph. Why this matters. What's the big picture? What does the world
look like if this works? Draw from the CEO Review's "dream state" if available,
otherwise from the design doc's success criteria.]

## Problem
[The pain point with specifics. Who feels it, how often, what it costs them.
Use the demand evidence from office hours. Include the "status quo" — what
do people do today without this product?]

## Market
[Size and shape. Who are the buyers? How many? What do they pay for adjacent
solutions? Draw from interview Section 16 (Prior Context) if competitive
analysis exists, otherwise flag as a gap for the client to fill.]

## Solution
[What the product does, how it works at a high level. Lead with the user
experience, not the architecture. Include the core insight — what non-obvious
thing did you figure out?]

## Differentiation
[Why this approach wins. Draw from the design doc's alternatives analysis.
What tradeoffs did you consciously make? What moat do you build over time?]

## Traction & Status
[What exists today. Be honest. Metrics if available. Phase completion status.
User feedback if any. "We've completed the design interview and are entering
build" is a valid status for early-stage.]

## Team & Approach
[Who's building this and why they're the right people. Include the domain
expertise captured in the interview — what does the builder know that others
don't? Reference the personas as evidence of domain depth.]

## Risks & Mitigations
[Top 3 risks from the CEO Review's risk analysis. For each: the risk, how
likely, what you're doing about it. Do not hand-wave — use the specific
mitigations from the interview.]

## Ask
[What you need. Funding, technical partners, beta users, advisors. Be specific.]
```

**Source mapping:**
- Thesis → CEO Review "Dream State" + Design Doc "Success Criteria"
- Problem → Office Hours "Demand Reality" + Design Doc "Problem Statement"
- Market → Interview Section 16 (Prior Context) or flag as gap
- Solution → Interview Sections 1-5 + Design Doc "Recommended Approach"
- Differentiation → Design Doc "Approaches Considered"
- Traction → Current phase status
- Risks → CEO Review risk analysis + Interview Section 9 (Failure Modes)

### 2c. Technical Overview

**Audience:** Technical stakeholders — potential hires, integration partners, open-source contributors, technical advisors.

**Format:** 2-4 pages. Precise, concrete, no marketing language. Architecture-first.

```markdown
# [Project Name] — Technical Overview

## What This Is
[One paragraph. What the system does, technically. Not the pitch — the
mechanism.]

## Architecture
[High-level system architecture. Draw from Interview Section 4 (Architecture
& Infrastructure). Include:]
- System components and their responsibilities
- Data flow between components
- External dependencies and integrations
- Key architectural decisions and WHY they were made

[If the interview captured ASCII diagrams or data flow descriptions, include
them verbatim.]

## Data Model
[Core entities and relationships from Interview Section 5 (Data Model). Include
exact field names, types, and constraints if captured in the interview.]

## Key Technical Decisions
[For each major technical decision from the interview, document:]
- What was decided
- What alternatives were considered (from Advisory Mode recommendations)
- Why this approach was chosen
- What tradeoffs were accepted

## Security Model
[From Interview Section 8 (Security) and CSO audit findings if available:]
- Authentication and authorization approach
- Data classification and handling
- Trust boundaries
- Key security constraints

## Stack
[Exact technologies, frameworks, versions from the interview. Not "modern web
stack" — "Next.js 14, PostgreSQL 16, deployed on Vercel".]

## API Surface (if applicable)
[From Interview Section 11 (External Interfaces):]
- Key endpoints or interfaces
- Authentication method
- Rate limits and constraints

## Development Setup
[How to get the project running locally. Exact commands. From the build
process and any existing README.]
```

**Source mapping:**
- Architecture → Interview Section 4
- Data Model → Interview Section 5
- Technical Decisions → Advisory Mode decisions throughout interview
- Security → Interview Section 8 + CSO findings
- Stack → Interview Section 4 + DESIGN_DOC.md
- API → Interview Section 11

### 2d. README

**Audience:** Anyone landing on the repository. The first thing they see.

**Format:** Scannable. Clear. Gets to the point fast. Includes everything needed to understand, install, and use the project.

```markdown
# [Project Name]

[One-liner from the Product Brief. What it is, not what it does technically.]

## What It Does

[3-5 bullet points. Core capabilities from the user's perspective.
Draw from Interview Section 2 (Core Logic) and Section 3 (User Flows).]

## Quick Start

[Exact commands to get running. From Interview Section 4 (Architecture)
and the build process. If not yet buildable, say so honestly:
"This project is in [phase]. Build instructions will be added in Phase [N]."]

## How It Works

[Brief technical explanation. 1-2 paragraphs. How the system works at a
high level. Draw from the Technical Overview but shorter.]

## Project Status

[Current build phase. What's done, what's next. Link to the roadmap if public.]

| Phase | Status |
|:------|:-------|
| Design & Discovery | ✅ Complete |
| Domain Interview | ✅ Complete |
| Architecture & Roadmap | [status] |
| Core Build | [status] |
| [Additional phases] | [status] |

## Documentation

- [Product Brief](docs/PRODUCT_BRIEF.md) — what it is, who it's for
- [Technical Overview](docs/TECHNICAL_OVERVIEW.md) — architecture and decisions
- [Investor Memo](docs/INVESTOR_MEMO.md) — thesis, market, traction

## Contributing

[If open source: how to contribute. If private: who has access.]

## License

[License from the interview or project setup.]
```

---

## Step 3: Gap Report

After generating all four documents, produce a gap report:

```markdown
## Documentation Gap Report

### Information Present — Used
[List the interview sections and design doc sections that contributed to the docs.]

### Information Gaps — Flagged for Client
[List specific things the documents NEED but the source material DOESN'T CONTAIN:]
- [ ] Market size data for investor memo
- [ ] Competitive landscape analysis
- [ ] Pricing/business model for investor memo
- [ ] Installation commands (project not yet buildable)
- [ ] [Other gaps]

### Sections Not Used
[List source material that exists but wasn't relevant to any document.
This helps the client spot important context that should be reflected.]
```

Present the gap report to the client. They decide what to fill, what to skip, and what to defer.

---

## Step 4: Save & Commit

```bash
mkdir -p docs
# Save each document
git add docs/ && git commit -m "docs: initial documentation suite — product brief, investor memo, technical overview, README"
```

If updating an existing README at project root, present the diff to the client before overwriting.

---

## Update Protocol

This prompt supports **incremental updates**, not just initial generation. When re-run:

1. **Diff detection:** Identify what changed since the last docs generation:
   - New interview content (`/interview-update` or `/new-idea`)
   - Phase completion (new capabilities to document)
   - CSO findings (security model updates)
   - Design changes (UI/UX updates)

2. **Surgical updates:** Do NOT regenerate documents from scratch. Edit the specific sections affected by the changes. Follow the same rules as `document_release.md`:
   - Auto-update factual changes (status, phase, new features)
   - Ask the client about narrative changes (positioning, differentiation)
   - Never overwrite positioning without permission

3. **Cross-doc consistency:** After updates, verify all four documents are consistent with each other. Version numbers, feature lists, status indicators, and architectural descriptions must match.

4. **Commit:**
   ```bash
   git add docs/ && git commit -m "docs: updated [which docs] — [what changed]"
   ```

**Trigger points for re-running this prompt:**
- After Phase A completion (initial generation)
- After `/new-idea` integrations that change product scope
- After each build phase completion (status updates + new capabilities)
- After CSO audit (security model updates)
- Before any external communication (investor meeting, launch, hiring)

---

## Important Rules

1. **Source fidelity is non-negotiable.** Every claim traces to the interview or design doc. If you can't cite the source, don't write the claim.
2. **Honest status.** Never inflate progress. "Design complete, build starting" is a valid and respectable status. Investors and partners respect honesty more than vaporware.
3. **Audience-appropriate language.** The investor memo and product brief use accessible language. The technical overview uses precise technical language. The README bridges both. Never use marketing-speak in the technical overview. Never use implementation jargon in the product brief.
4. **Verbatim technical specs.** When the interview says "99.9% uptime SLA" or "p95 latency under 200ms", use those exact numbers. Do not round, simplify, or editorialize.
5. **Flag gaps, don't fill them.** If the investor memo needs market size data and the interview doesn't have it, flag it. Do not make up numbers or use vague qualifiers like "large and growing market."
6. **The README updates last.** It synthesizes the other three documents. Generate it after the brief, memo, and technical overview are approved.
