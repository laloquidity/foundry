---
description: Run an ad-hoc content curation pass against any source files — standalone, outside the phase-gate lifecycle
---

# /curate — Standalone Content Curation

Run the Content Curator (`prompts/content_curator.md`) against arbitrary source files at any time. Use this when curation opportunities arise outside the build lifecycle: after a competitive analysis conversation, an investor call, a deep research session, or a market event.

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

2. **Check existing drafts:**
   - Read all files in `content/drafts/` (if the directory exists)
   - The curator uses these to avoid mining signals already covered in previous passes

3. **Run the curator:**
   - Invoke `prompts/content_curator.md` with the collected source files
   - The curator reads all sources, extracts candidate signals, ranks them, and produces 4 draft pieces
   - All editorial rules and voice standards apply exactly as in phase-gate curation

4. **Save drafts:**
   - Each piece saved to `content/drafts/YYYY-MM-DD-[slug].md` with structured frontmatter
   - The curator outputs a Content Curation Summary table

5. **Commit:**
   ```bash
   git add content/drafts/ && git commit -m "content: ad-hoc curator pass — [brief description of sources]"
   ```

## When to Use This

- A deep working session produced insights worth mining (competitive analysis, technical deep dive, design decision chain)
- An investor call or external conversation surfaced new positioning or market insights
- An external market event creates a time-sensitive content opportunity
- You extracted conversation artifacts into workspace files and want the curator to mine them
- You want to re-run curation on updated artifacts without waiting for a phase gate

## Important

- **Same rigor as phase-gate curation.** The curator applies identical editorial rules, signal ranking, and deduplication whether triggered by a phase gate or by `/curate`.
- **Source files must be in the workspace.** The curator reads files, not conversation logs. If signal lives in a past conversation, extract it into a markdown file first (see the cross-conversation extraction pattern in `prompts/content_curator.md`).
- **Drafts are always drafts.** Nothing is published. Everything goes to `content/drafts/` for human review.
