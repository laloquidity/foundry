# Interview Guide — Structured Domain Knowledge Capture

> Use this template to conduct a thorough domain interview with the project's subject matter expert. The goal is to capture EVERYTHING — thresholds, formulas, edge cases, decision rules, failure modes, preferences, and priorities.

## Interview Principles

1. **Record exact values** — not "around 30" but "34"
2. **Capture the WHY** — not just what the rule is, but why it exists
3. **Ask for edge cases** — "what happens when X fails?"
4. **Get decision trees** — "if A then B, else if C then D"
5. **Ask for examples** — "walk me through a real scenario"
6. **Capture priorities** — "if you could only have 3 features, which?"
7. **Document conflicts** — if two answers contradict, flag it immediately
8. **Discover existing workflows** — ask: "Do you have any existing skills, workflows, coding standards, or processes that should be part of this project's development?" Wire these into the execution workflow like personas.
9. **Ingest before interviewing** — if the client provides existing PRDs, specs, or context docs, read them in full and pre-fill answers. Only ask questions where the document is silent, ambiguous, or incomplete. Preserve exact values verbatim — do not paraphrase thresholds, formulas, or technical specifications.

---

## Section Template

Use `##` headers for each major topic. This structure will be used by the extraction script to split the document into task-scoped chunks.

### Suggested Sections (adapt for your domain)

```markdown
## 1. Project Identity & Core Purpose
- What does this system do?
- Who uses it?
- What is the ONE metric that defines success?
- What existing system/process is this replacing?

## 2. Performance Requirements
- Target metrics (latency, throughput, accuracy, etc.)
- Current baseline (if replacing existing system)
- Non-negotiable constraints

## 3. Core Logic / Decision Rules
- Step-by-step: how does the system make decisions?
- What are the exact thresholds and parameters?
- What is the priority / evaluation order?
- What signals or inputs are used?

## 4. Data Sources & Dependencies
- What data feeds are required?
- What format/frequency?
- What happens if a data source is unavailable?
- Authentication / API requirements

## 5. Entry / Input Processing
- How does data enter the system?
- Validation rules
- Required transformations

## 6. Output / Exit Processing
- What does the system produce?
- Format, frequency, delivery method
- Error handling for outputs

## 7. Failure Modes & Edge Cases
- What can go wrong?
- How should the system handle each failure?
- Which failures are recoverable vs fatal?
- Historical examples of failures

## 8. Configuration & Tuning
- Which parameters should be user-configurable?
- What are the default values?
- What are the valid ranges?
- Which parameters are structural (rarely change) vs adaptive (tuned often)?

## 9. Timing & Scheduling
- When does the system run?
- Are there time-sensitive windows?
- Calendar/schedule dependencies

## 10. Risk & Safety
- What are the worst-case scenarios?
- What safeguards are needed?
- Kill switches, circuit breakers, rate limits

## 11. Additional Signals / Secondary Features
- Nice-to-have features
- Future expansion items
- Optional data sources

## 12. Architecture Notes
- Any strong preferences on tech stack?
- Integration points with existing systems
- Deployment requirements

## 13. Open Items
- Unresolved questions
- Items needing research
- Dependencies on external parties

## 14. Build Priority
- What needs to be built first?
- What can wait?
- Phase ordering and dependencies

## 15. Validation & Examples
- Real-world examples to test against
- Known inputs → expected outputs
- Case studies from manual operation

## 16. Prior Context & Business Intelligence
- Competitive analysis and market positioning (from source docs)
- User research findings and existing personas
- Historical context (prior approaches, why they failed)
- Business constraints (budget, timeline, regulatory, compliance)
- Stakeholder requirements and organizational context
- Reference architectures, prior art, and inspirations
- Any source document content that doesn't map to Sections 1-15
```

---

## Post-Interview Checklist

After the interview, verify:
- [ ] Every parameter has an exact value (not approximations)
- [ ] Every decision rule has a complete if/then/else chain
- [ ] All data sources are identified with access details
- [ ] Failure modes have explicit handling instructions
- [ ] Priorities are clear and ordered
- [ ] Conflicts are flagged with `> [!WARNING]` blocks
- [ ] The document is committed to git as baseline
- [ ] If source documents were provided: reconciliation gate passed (zero MISSING items)
- [ ] All source document values preserved verbatim (not paraphrased)
- [ ] Source documents listed in interview header for traceability
