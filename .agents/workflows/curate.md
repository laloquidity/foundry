---
description: Run an ad-hoc content curation pass against any source files — standalone, outside the phase-gate lifecycle
---

# /curate — Standalone Content Curation

Run the Content Curator (`.foundry/prompts/content_curator.md`) against arbitrary source files at any time. Use this when curation opportunities arise outside the build lifecycle: after a competitive analysis conversation, an investor call, a deep research session, or a market event.

## Usage

```
/curate [source files or directories]
```

Examples:
```
/curate data-room/competitive-analysis.md
/curate data-room/ PROJECT_INTERVIEW.md
/curate data-room/rate-curve-research.md data-room/investor-qa.md
```

If no source files are specified, the curator defaults to the standard Foundry artifacts:
- `DESIGN_DOC.md`
- `PROJECT_INTERVIEW.md`
- `PERSONA_*.md`
- `RETRO_LOG.md`

## Steps

1. **Collect source files:**
   - If the client specified files → use those
   - If no files specified → use the standard Foundry artifacts listed above
   - Always check that specified files exist before proceeding
   - If the source is a live session (conversation, not a pre-existing file), **extract the full session into a source-extract file first** (`content/source-extracts/YYYY-MM-DD-[slug].md`). Include the timeline, decision chain, failure modes, and specific numbers — not just the final state.
   - **Mine related conversations.** Check conversation summaries for sessions that contributed to the same arc. Read their logs for raw moments (specific failures, turning points, exact numbers) that source extracts may have flattened. The best details live in the debugging, not the summary.

2. **Read for voice, not just dedup:**
   - Read all files in `content/drafts/` (if the directory exists)
   - The curator uses these to avoid mining signals already covered in previous passes
   - **Read reviewed drafts to internalize the author's voice, register, and structural preferences.** These are the editorial standard. Match the sentence rhythm, the level of technical specificity, the way claims are grounded in experience rather than authority.
   - Note: the author's voice is direct, first-person, leads with specific claims, earns technical depth through narrative, closes narrow. No listicles. No headers within article bodies. Horizontal rules as section breaks. Prose, not bullet points.

3. **Find the arc, not just the signals:**
   - Before extracting individual signals, identify the **narrative arc** of the source material. What changed over time? What was the sequence of decisions, failures, and discoveries? What's the throughline that connects them?
   - The most common failure mode is mining isolated observations instead of finding the thesis that connects the entire experience.
   - **Ask: what is the single genuine insight that the source material earns?** Not the cleverest detail. Not the most counterintuitive factoid. The thing the author actually learned that they couldn't have known before the experience.
   - If the source shows a dramatic range of outcomes from the same fixed input (same hardware, same model, same budget), **name the multiplier explicitly**. Don't leave the math to the reader. State the range, then unpack what produced it.
   - If the source material represents a **threshold or unlock** — the first time something became possible at a hardware class, price point, or parameter count — name it. The reader needs to know whether this is incremental or categorical.
   - Build signals around the arc, not alongside it.

4. **Run the curator:**
   - Invoke `.foundry/prompts/content_curator.md` with the collected source files and the arc identified in step 3
   - The curator reads all sources, extracts candidate signals, ranks them, and produces draft pieces
   - All editorial rules and voice standards apply exactly as in phase-gate curation
   - **Quality over quantity.** One piece that captures the genuine arc is better than four pieces that each grab a fragment. Produce 1–4 pieces depending on the richness of the source material.
   - **Pace the arc evenly.** If the piece claims a progression, every transition needs its own beat. If one jump is buried inside a paragraph about something else, the arc feels lopsided and the reader loses the thread.
   - **Anchor with specs.** When a piece makes hardware- or performance-specific claims, close with a spec line so the reader knows exactly what was tested. Don't make them hunt for it.

5. **Save drafts:**
   - Each piece saved to `content/drafts/YYYY-MM-DD-[slug].md` with structured frontmatter
   - The curator outputs a Content Curation Summary table

6. **Run the Gatekeeper editorial review:**
   - Invoke `.foundry/prompts/content_editor.md` on each draft in `content/drafts/` that has `status: draft` in its frontmatter
   - The Gatekeeper runs 5 passes per piece: VC Test, Engineer Test, AI Pattern Sweep, Platform Fit Check, Credibility Gut Check
   - For each draft, the Gatekeeper outputs a verdict:
     - **APPROVED** → update frontmatter `status: reviewed`, apply inline edits, generate hook tweet (for articles)
     - **REVISE** → leave `status: draft`, append revision notes to the file. The draft stays in `content/drafts/` for rework.
     - **KILL** → update frontmatter `status: killed` and add kill reason. The file stays for the author to review the reasoning.
   - **Ask the client** before accepting any KILL verdict: "The Gatekeeper recommends killing [title] because [reason]. Agree, or override to REVISE?"
   - **Additional Gatekeeper pass — Arc Test:** Does this piece capture the genuine insight of the source material, or did it grab a detail and build a piece around it? If the source material has a clear narrative arc, the piece must reflect that arc — not just one observation from within it.

7. **Commit:**
   ```bash
   git add content/drafts/ && git commit -m "content: ad-hoc curator pass — [brief description of sources]"
   ```
   Note: if `content/` is in `.gitignore`, skip the commit step and note that drafts are saved locally only.

## When to Use This

- A deep working session produced insights worth mining (competitive analysis, technical deep dive, design decision chain)
- An investor call or external conversation surfaced new positioning or market insights
- An external market event creates a time-sensitive content opportunity
- You extracted conversation artifacts into workspace files and want the curator to mine them
- You want to re-run curation on updated artifacts without waiting for a phase gate

## Important

- **Full pipeline: Signal Miner → Gatekeeper → Human.** The curator (Signal Miner) writes drafts. The editor (Gatekeeper) reviews them. The human makes the final publish decision. No piece skips the Gatekeeper.
- **Same rigor as phase-gate curation.** The curator applies identical editorial rules, signal ranking, and deduplication whether triggered by a phase gate or by `/curate`.
- **Source files must be in the workspace.** The curator reads files, not conversation logs. If signal lives in a past conversation, extract it into a markdown file first (see the cross-conversation extraction pattern in `.foundry/prompts/content_curator.md`).
- **Drafts are always drafts.** Nothing is published. Everything goes to `content/drafts/` for human review, even after Gatekeeper approval.
- **Arc over signals.** The most common failure mode in AI-assisted curation is producing multiple pieces that each capture a "signal" without capturing the throughline. Fight this by finding the arc first and building around it.
- **Curate, don't catalog.** Mining conversations will surface more detail than the piece needs. Include what serves the narrative. If a data point doesn't advance the arc or earn a claim, cut it — even if it's interesting. The goal is a piece that flows, not a transcript.
- **Voice is earned, not configured.** The curator must read the existing reviewed drafts before writing. The author's voice is a constraint, not a style guide checkbox. If the new piece sounds different from the reviewed corpus, it's wrong.
