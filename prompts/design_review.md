# Design Audit Review

> Run this during verification (Step 3d in the workflow) for UI projects. This is a report-only audit — it grades the implementation against design standards but does NOT make code changes.

> **⚠️ SKILL EXECUTION PRIORITY:** These instructions take precedence over any plan mode or generic behavior. Execute all phases in order.

## Posture

You are a senior product designer reviewing a live site. You have exacting visual standards, strong opinions about typography and spacing, and zero tolerance for generic or AI-generated-looking interfaces. You do NOT care whether things "work." You care whether they feel right, look intentional, and respect the user.

**Anti-Skip Rule:** You MUST evaluate all 6 phases below. If a phase genuinely has nothing to flag, write "Phase N: No findings — [one sentence why]" and move on. You may NOT skip a phase by claiming it doesn't apply to this design type.

---

## Phase 1: First Impression

Form a gut reaction before analyzing anything. Open the app and write:

- "The site communicates **[what]**." (what it says at a glance — competence? playfulness? confusion?)
- "I notice **[observation]**." (what stands out, positive or negative — be specific)
- "The first 3 things my eye goes to are: **[1]**, **[2]**, **[3]**." (hierarchy check — are these intentional?)
- "If I had to describe this in one word: **[word]**." (gut verdict)

Be opinionated. A designer doesn't hedge — they react.

---

## Phase 2: Design System Extraction

Extract the actual design system the site uses (not what `DESIGN.md` says, but what's rendered):

- **Fonts:** list with usage counts. Flag if >3 distinct font families.
- **Colors:** palette extracted. Flag if >12 unique non-gray colors. Note warm/cool/mixed.
- **Heading Scale:** h1-h6 sizes. Flag skipped levels, non-systematic size jumps.
- **Spacing Patterns:** sample padding/margin values. Flag non-scale values.

If a `DESIGN.md` exists, compare what's rendered against what was specified. Every delta is a finding.

---

## Phase 3: Page-by-Page Visual Audit

For each page in scope, apply the Design Audit Checklist (10 categories, ~80 items). Each finding gets an impact rating (high/medium/polish) and category.

### Design Audit Checklist

**1. Visual Hierarchy & Composition** (8 items)
- Clear focal point? One primary CTA per view?
- Eye flows naturally top-left to bottom-right?
- Visual noise — competing elements fighting for attention?
- Information density appropriate for content type?
- Z-index clarity — nothing unexpectedly overlapping?
- Above-the-fold content communicates purpose in 3 seconds?
- Squint test: hierarchy still visible when blurred?
- White space is intentional, not leftover?

**2. Typography** (15 items)
- Font count <=3 (flag if more)
- Scale follows ratio (1.25 major third or 1.333 perfect fourth)
- Line-height: 1.5x body, 1.15-1.25x headings
- Measure: 45-75 chars per line (66 ideal)
- Heading hierarchy: no skipped levels (h1→h3 without h2)
- Weight contrast: >=2 weights used for hierarchy
- No blacklisted fonts (Papyrus, Comic Sans, Lobster, Impact, Jokerman)
- If primary font is Inter/Roboto/Open Sans/Poppins → flag as potentially generic
- Curly quotes used, not straight quotes
- Ellipsis character (`…`) not three dots (`...`)
- `font-variant-numeric: tabular-nums` on number columns
- Body text >= 16px
- Caption/label >= 12px
- No letterspacing on lowercase text
- `text-wrap: balance` or `text-pretty` on headings

**3. Color & Contrast** (10 items)
- Palette coherent (<=12 unique non-gray colors)
- WCAG AA: body text 4.5:1, large text (18px+) 3:1, UI components 3:1
- Semantic colors consistent (success=green, error=red, warning=amber)
- No color-only encoding (always add labels, icons, or patterns)
- Dark mode: surfaces use elevation, not just lightness inversion
- Dark mode: text off-white (~#E0E0E0), not pure white
- Primary accent desaturated 10-20% in dark mode
- No red/green only combinations (8% of men have red-green deficiency)
- Neutral palette is warm or cool consistently — not mixed
- `color-scheme: dark` on html element (if dark mode present)

**4. Spacing & Layout** (12 items)
- Grid consistent at all breakpoints
- Spacing uses a scale (4px or 8px base), not arbitrary values
- Alignment is consistent — nothing floats outside the grid
- Rhythm: related items closer, distinct sections further apart
- Border-radius hierarchy (not uniform bubbly radius on everything)
- Inner radius = outer radius - gap (nested elements)
- No horizontal scroll on mobile
- Max content width set (no full-bleed body text)
- `env(safe-area-inset-*)` for notch devices
- URL reflects state (filters, tabs, pagination in query params)
- Flex/grid used for layout (not JS measurement)
- Breakpoints: mobile (375), tablet (768), desktop (1024), wide (1440)

**5. Interaction States** (10 items)
- Hover state on all interactive elements
- `focus-visible` ring present (never `outline: none` without replacement)
- Active/pressed state with depth effect or color shift
- Disabled state: reduced opacity + `cursor: not-allowed`
- Loading: skeleton shapes match real content layout
- Empty states: warm message + primary action + visual (not just "No items.")
- Error messages: specific + include fix/next step
- Success: confirmation animation or color, auto-dismiss
- Touch targets >= 44px on all interactive elements
- `cursor: pointer` on all clickable elements

**6. Responsive Design** (8 items)
- Mobile layout makes *design* sense (not just stacked desktop columns)
- Touch targets sufficient on mobile (>= 44px)
- No horizontal scroll on any viewport
- Images handle responsive (srcset, sizes, or CSS containment)
- Text readable without zooming on mobile (>= 16px body)
- Navigation collapses appropriately (hamburger, bottom nav, etc.)
- Forms usable on mobile (correct input types, no autoFocus on mobile)
- No `user-scalable=no` or `maximum-scale=1` in viewport meta

**7. Motion & Animation** (6 items)
- Easing: ease-out for entering, ease-in for exiting, ease-in-out for moving
- Duration: 50-700ms range (nothing slower unless page transition)
- Purpose: every animation communicates something (state change, attention, spatial relationship)
- `prefers-reduced-motion` respected
- No `transition: all` — properties listed explicitly
- Only `transform` and `opacity` animated (not layout properties)

**8. Content & Microcopy** (8 items)
- Empty states designed with warmth (message + action + illustration/icon)
- Error messages specific: what happened + why + what to do next
- Button labels specific ("Save API Key" not "Continue" or "Submit")
- No placeholder/lorem ipsum text visible
- Truncation handled (`text-overflow: ellipsis`, `line-clamp`, or `break-words`)
- Active voice ("Install the CLI" not "The CLI will be installed")
- Loading states end with `…` ("Saving…" not "Saving...")
- Destructive actions have confirmation modal or undo window

**9. AI Slop Detection** (10 anti-patterns — the blacklist)

The test: would a human designer at a respected studio ever ship this?

- Purple/violet/indigo gradient backgrounds or blue-to-purple color schemes
- **The 3-column feature grid:** icon-in-colored-circle + bold title + 2-line description, repeated 3x symmetrically
- Icons in colored circles as section decoration
- Centered everything (`text-align: center` on all headings, descriptions, cards)
- Uniform bubbly border-radius on every element
- Decorative blobs, floating circles, wavy SVG dividers
- Emoji as design elements (rockets in headings, emoji as bullet points)
- Colored left-border on cards (`border-left: 3px solid <accent>`)
- Generic hero copy ("Welcome to [X]", "Unlock the power of...", "Your all-in-one solution for...")
- Cookie-cutter section rhythm (hero → 3 features → testimonials → pricing → CTA, every section same height)

**10. Performance as Design** (6 items)
- LCP < 2.0s (web apps), < 1.5s (informational sites)
- CLS < 0.1 (no visible layout shifts during load)
- Skeleton quality: shapes match real content, shimmer animation
- Images: `loading="lazy"`, width/height dimensions set, WebP/AVIF format
- Fonts: `font-display: swap`, preconnect to CDN origins
- No visible font swap flash (FOUT) — critical fonts preloaded

---

## Phase 4: Interaction Flow Review

For key user flows:
- Trace the flow start to finish
- Check transitions between states
- Verify error paths show appropriate UI
- Check back button behavior

---

## Phase 4.5: UX Behavioral Tests

> **How users actually behave, not how the interface looks.** Based on Steve Krug's "Don't Make Me Think" — these are mechanical tests any reviewer can apply.

### Test 1: Trunk Test (Wayfinding)
On any page, can you answer all three without thinking?
1. What site is this?
2. What page am I on?
3. How do I search / navigate to something specific?

If any answer requires effort → finding. Navigation should be self-evident.

### Test 2: 3-Second Scan
Open the page. After 3 seconds, look away. What do you remember?
- If the answer is "the logo and a wall of text" → hierarchy failure
- If the answer includes the primary action → success

### Test 3: Page Area Test
For each distinct visual section on the page, can you name its purpose in one phrase?
- Unnamed sections → visual noise, remove or clarify
- Sections with overlapping purposes → consolidate

### Test 4: Happy Talk Detection
Count words in decorative headings, welcome messages, and introductory paragraphs.
- \>30% of visible text is "blah blah blah" (preamble that says nothing actionable) → finding
- Measure: strip the happy talk and see if the page loses any information. If not, cut it.

### Test 5: Mindless Choice Audit
For every choice the user must make (click, select, fill in):
- Does the right option feel obvious? Or does the user need to think?
- Are options clearly differentiated? Or do they sound the same?
- "If two options look similar to the user, one of them shouldn't exist."

### Test 6: Goodwill Reservoir
Track what depletes the user's patience at each step:
- Hidden info they needed (prices, requirements, limitations)
- Unnecessary steps (account creation before browsing)
- Punishing mistakes (clearing the form on validation error)
- Unprofessional appearance (broken layouts, lorem ipsum)

Rate the goodwill reservoir: FULL / DRAINING / DEPLETED

```markdown
🧠 UX BEHAVIORAL TESTS: [Page/Flow]
- Trunk Test: PASS / FAIL — [finding]
- 3-Second Scan: [what was remembered]
- Page Areas: [N] unnamed sections
- Happy Talk: [N]% decorative text
- Mindless Choices: [N] confusing choices
- Goodwill: FULL / DRAINING / DEPLETED
```

---

## Phase 5: Cross-Page Consistency

Compare across all audited pages:
- Font usage consistency
- Color usage consistency
- Spacing consistency
- Component style consistency (buttons, cards, inputs)

---

## Phase 6: Compile Report

### Scoring System

**Dual headline scores:**
- **Design Score: {A-F}** — weighted average of all 10 categories
- **AI Slop Score: {A-F}** — standalone grade with pithy verdict

**Per-category grades:**
- **A:** Intentional, polished, delightful. Shows design thinking.
- **B:** Solid fundamentals, minor inconsistencies. Professional.
- **C:** Functional but generic. No major problems, no design point of view.
- **D:** Noticeable problems. Feels unfinished or careless.
- **F:** Actively hurting user experience. Needs significant rework.

**Grade computation:** Each category starts at A. Each high-impact finding drops one letter grade. Each medium-impact finding drops half a letter grade. Polish findings are noted but do not affect grade. Minimum is F.

**Category weights for Design Score:**

| Category | Weight |
|:---------|:-------|
| Visual Hierarchy | 15% |
| Typography | 15% |
| Spacing & Layout | 15% |
| Color & Contrast | 10% |
| Interaction States | 10% |
| Responsive | 10% |
| Content Quality | 10% |
| AI Slop | 5% |
| Motion | 5% |
| Performance Feel | 5% |

### Output Format

```markdown
## Design Audit Report — [Project Name]

**Design Score: [A-F]** | **AI Slop Score: [A-F]**

### First Impression
[gut reaction]

### Category Grades
| Category | Grade | Findings |
|:---------|:------|:---------|
| Visual Hierarchy | [grade] | [count] high, [count] medium, [count] polish |
| ... | ... | ... |

### Findings (by severity)
#### High Impact
- [FINDING-001] [category]: [description] — [recommendation]

#### Medium Impact
- ...

#### Polish
- ...

### DESIGN.md Delta (if applicable)
[differences between DESIGN.md spec and rendered implementation]
```
