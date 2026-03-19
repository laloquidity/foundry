---
description: Capture a new idea or feature request and integrate it into the project interview
---

# /new-idea — Capture & Integrate a New Idea

This workflow captures a new idea, feature request, or requirement change and integrates it into the existing project with full rigor — same standards as the original interview.

## Steps

1. **Mini-Interview — capture the idea with precision:**

   Ask the client:
   - **What is the idea?** One sentence.
   - **Why does this matter?** What problem does it solve or what value does it add?
   - **Who does it affect?** Which users, flows, or components?
   - **What are the exact requirements?** Thresholds, rules, edge cases — same rigor as the original interview. No approximations.
   - **What happens when it fails?** Error handling, fallback behavior.
   - **Priority?** Must-have for current phase, next phase, or backlog?
   - **Does it change any existing decisions?** If yes, which ones and how?

   Use Advisory Mode — provide production-grade recommendations alongside each question, just like the original interview.

2. **Locate the right section in `PROJECT_INTERVIEW.md`:**

   Read the section index (`sections/_INDEX.md`) to determine:
   - Which existing section(s) this idea belongs in
   - Whether it requires a NEW section (new `##` header)
   - Whether it conflicts with any existing decisions

   If it conflicts with existing decisions, STOP and flag the conflict before making any edits.

3. **Update `PROJECT_INTERVIEW.md`:**

   - If the idea fits an existing section → append to that section with clear attribution:
     ```markdown
     ### [Idea Name] (added [date])
     [captured requirements]
     ```
   - If the idea requires a new section → add a new `##` header following the existing naming convention
   - **Do NOT delete or modify existing content** unless the client explicitly says a previous decision is superseded

4. **Commit the interview update:**
   ```bash
   git add PROJECT_INTERVIEW.md
   git commit -m "Interview update: added [idea name]"
   ```

5. **Run `/interview-update`** to propagate changes:
   - Re-extract sections
   - Rebuild index
   - Update phase mappings
   - CEO re-validation (if the idea is substantive)

6. **Assess workflow impact:**

   After propagation, determine if the idea affects the current execution workflow:
   - **New deliverables needed?** → Add to the current or next phase's deliverable checklist
   - **Existing deliverables changed?** → Update the checklist and flag for re-verification
   - **New phase needed?** → Add to the implementation roadmap
   - **Design system affected?** (UI projects) → Flag for design consultation update

   Report the impact:
   ```markdown
   ## New Idea Impact Assessment
   - Idea: [name]
   - Sections affected: [list]
   - New sections created: [list or "none"]
   - Conflicts with existing decisions: [list or "none"]
   - Workflow impact: [new deliverables / changed deliverables / new phase / none]
   - Next action: [what needs to happen next]
   ```

## Important

- **Same rigor as the original interview.** Exact values, not approximations. Edge cases, not just happy paths.
- **The interview remains the canonical source of truth.** New ideas go INTO the interview, not into separate documents.
- **Never modify existing decisions without explicit client approval.** Flag conflicts, don't resolve them silently.
