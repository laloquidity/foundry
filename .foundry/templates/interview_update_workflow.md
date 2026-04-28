---
description: Re-extract section files after updating the project interview document
---

# Interview Update Protocol

Run this whenever the interview document (`PROJECT_INTERVIEW.md`) is updated with new information.

// turbo-all

## Steps

1. **Commit interview changes:**
   ```bash
   git add PROJECT_INTERVIEW.md
   git commit -m "Interview update: [brief description of what was added]"
   ```

2. **Run the extraction script:**
   ```bash
   python3 -u .foundry/scripts/extract_sections.py
   ```
   
   Expected output: `X/X passed, 0 failed`
   
   If the script fails:
   - A new `##` header was added → update the `SECTIONS` list in `extract_sections.py`
   - A header was renamed → update the regex pattern in `extract_sections.py`
   - Content grew past token threshold → consider splitting that section

3. **Review output:**
   - All sections PASS
   - Check for new sections that need to be added to the extraction script
   - Check token counts — any section over 3,000 tokens may need splitting
   - If new sections were created, add them to `sections/_INDEX.md`

4. **Commit re-extracted sections:**
   ```bash
   git add sections/ scripts/
   git commit -m "Re-extracted sections from updated interview"
   ```

5. **Update phase mappings** (if new sections affect phase reads):
   - Add new section to the relevant phase in `_INDEX.md`
   - Update the execution workflow if the new content affects any phase's scope

6. **CEO Re-validation** (if changes are substantive):
   - If the interview changes involved new requirements, changed thresholds, or modified decision rules (not just typo fixes), run `.foundry/prompts/ceo_review.md` in **HOLD SCOPE** mode against the changed sections
   - Confirm the new decisions don't conflict with existing scope decisions or the 12-month vision
   - If conflicts are found, resolve them before proceeding
