# Document Release — Post-Ship Documentation Update

> Run this as Step 5 in the execution workflow — after shipping (Step 4) but before marking the phase complete. Ensures every documentation file is accurate and up to date.

## Philosophy

You are mostly automated. Make obvious factual updates directly. Stop and ask only for risky or subjective decisions.

**Only stop for:**
- Risky/questionable doc changes (narrative, philosophy, security, removals, large rewrites)
- New items to add to project backlog
- Cross-doc contradictions that are narrative (not factual)

**Never stop for:**
- Factual corrections clearly from the diff
- Adding items to tables/lists
- Updating paths, counts, version numbers
- Fixing stale cross-references
- Marking completed items in checklists

**NEVER do:**
- Overwrite or regenerate existing content wholesale — edit surgically
- Remove entire sections from any document without asking
- Change project positioning or philosophy without asking

---

## Step 1: Pre-flight & Diff Analysis

1. Gather context about what changed:
   ```bash
   git diff main --stat
   git log main..HEAD --oneline
   git diff main --name-only
   ```

2. Discover all documentation files in the project:
   ```bash
   find . -maxdepth 3 -name "*.md" -not -path "./.git/*" -not -path "./node_modules/*" | sort
   ```

3. Classify the changes:
   - **New features** — new files, new capabilities
   - **Changed behavior** — modified services, updated APIs, config changes
   - **Removed functionality** — deleted files, removed commands
   - **Infrastructure** — build system, test infrastructure

4. Output: "Analyzing N files changed across M commits. Found K documentation files to review."

---

## Step 1.5: Diataxis Coverage Map

For each new public surface introduced by the diff (new features, new CLI commands, new API endpoints, new config options, new components), classify its documentation coverage:

```markdown
## Documentation Coverage for This Change

| New Entity | Tutorial | How-To | Reference | Explanation | Gap |
|---|---|---|---|---|---|
| [new feature/endpoint] | ✅/❌ | ✅/❌ | ✅/❌ | ✅/❌ | [CRITICAL/COMMON/OK] |
```

**Gap classification:**
- **CRITICAL** — new entity has zero documentation coverage
- **COMMON** — only reference docs exist (typical: API added but no usage example)
- **OK** — at least 2 Diataxis quadrants covered

Include this map in the Documentation Update Report. Critical gaps should be highlighted as action items.

---

## Step 2: Per-File Documentation Audit

Read each documentation file and cross-reference against the diff:

**README.md:**
- Does it describe all features visible in the diff?
- Are install/setup instructions consistent with changes?
- Are examples and usage descriptions still valid?
- Are troubleshooting steps still accurate?

**ARCHITECTURE.md / DESIGN.md:**
- Do diagrams and descriptions match the current code?
- Are design decisions and "why" explanations still accurate?
- Be conservative — only update things clearly contradicted by the diff

**PROJECT_INTERVIEW.md / Section files:**
- Do any changes invalidate interview decisions?
- Are section files stale? (They should be regenerated via `/interview-update`, not manually edited)

**PROJECT_WORKFLOW.md:**
- Are phase descriptions still accurate?
- Are section file references still correct?
- Are persona references still valid?

**Any other .md files:**
- Read the file, determine its purpose
- Cross-reference against the diff

For each file, classify updates as:
- **Auto-update** — factual corrections from the diff (add to table, update path, fix count, update structure tree)
- **Ask client** — narrative changes, section removal, security model changes, ambiguous relevance

**CHANGELOG Voice Check (if CHANGELOG.md exists):**

For each new CHANGELOG entry, apply the 0-3 sell-test rubric:
- **+1 point:** Answers "what changed?" (reference — specific, factual)
- **+1 point:** Answers "why should I care?" (explanation — consequence, impact)
- **+1 point:** Answers "how do I use it?" (how-to — action the reader can take)

Entries scoring below 2/3 should be rewritten. Example:
- ❌ Score 1: "Added retry logic to payment service" (reference only)
- ✅ Score 3: "Added retry logic to payment service — failed charges now auto-retry 3× with exponential backoff. Set `PAYMENT_MAX_RETRIES=N` to customize."

---

## Step 3: Apply Auto-Updates

Make all clear, factual updates directly.

For each file modified, output a one-line summary: not "Updated README.md" but "README.md: added new component to architecture table, updated file count from 12 to 14."

**Never auto-update:**
- Project introduction or positioning
- Architecture philosophy or design rationale
- Security model descriptions

---

## Step 4: Ask About Risky Changes

For each risky update, present:
- Context: which doc file, what section
- The specific documentation decision
- Your recommendation with rationale
- Options including "Skip — leave as-is"

Apply approved changes immediately.

---

## Step 5: Cross-Doc Consistency Check

After all updates, scan for:
- Version numbers that don't match across docs
- File paths referenced in one doc but outdated in another
- Feature names used inconsistently
- Architecture diagrams that contradict each other

Fix factual inconsistencies directly. Flag narrative inconsistencies for the client.

---

## Step 6: Commit & Output

```bash
git add -A && git commit -m "docs: updated documentation for [phase/feature]"
```

Output summary:
```markdown
## Documentation Update Report

**Files reviewed:** [count]
**Auto-updated:** [count]
**Client decisions:** [count]
**No changes needed:** [count]

### Changes Made
- [file]: [what changed]
- [file]: [what changed]

### Skipped (no changes needed)
- [file]: current

### Flagged for Future
- [any docs that need attention but aren't stale yet]
```
