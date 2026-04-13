# Editorial guide: removing AI from your writing

Rules derived from editing the Foundry article + [blader/humanizer](https://github.com/blader/humanizer). Use as a checklist before publishing.

---

## Structural tells

**Em dashes.** AI uses them constantly. Replace with commas, colons, periods, or rephrase. If you need a pause, a comma usually works. If you need a break, start a new sentence.

- before: "I built the framework first — over several weeks — across multiple projects"
- after: "I built the framework first. Over several weeks, across multiple projects"

**Stacked short sentences.** AI loves choppy cadence to sound punchy. "Agents forget. Specs get too long. Decisions vanish." Merge them into flowing prose: "Agents forget what you told them, specs get too long to retain properly, and decisions vanish."

**Inline-header paragraphs.** Starting a paragraph with a bolded label followed by a period is pattern #15 in the humanizer. "**Persistent context architecture.** The interview splits into..." Just start the paragraph with the content. When you need visual separation for sequential items, use one of three alternatives: (1) actual numbered or bulleted lists, (2) ordinal prose flow ("First, ... Second, ... Third, ..."), or (3) sub-headings. Never open a paragraph with a bolded label that acts as a mini-heading.

**Bold overuse.** Mechanical bolding of key phrases reads like a sales deck. Use bold sparingly, only when something genuinely needs visual emphasis.

**"Not X, it's Y" / "X, not Y" parallelism.** AI uses contrastive phrasing as a crutch for emphasis. Both directions are tells. "This isn't a task list, it's a context map" and "The savings are structural, not situational" are the same construction. Cut the contrast and just say what it is: "Exceed the budget and the agent stops to reassess instead of sprawling." If the positive statement is clear enough on its own, the negation adds nothing.

**Rule of three.** AI forces ideas into groups of three. "Innovation, inspiration, and industry insights." If two items cover it, use two.

---

## Language tells

**AI vocabulary.** These words appear far more often in AI text than human text: additionally, crucial, delve, enhance, fostering, garner, highlight (verb), interplay, intricate, landscape (abstract), pivotal, showcase, tapestry, testament, underscore, vibrant, transformative, comprehensive, leverage.

**Promotional language.** "Excellent", "impressive", "excels", "genuinely", "powerful" when describing your own work. Describe what it does, not how good it is.

**Significance puffing.** "This represents a significant advancement in..." Just say what it does.

**Synonym cycling.** Using three different words for the same thing across three sentences because repetition-penalty code kicks in. Just use the same word.

---

## Tone mistakes

**Underselling for false modesty.** "Whether it works as well as I think it does remains to be seen" damages credibility when you've actually tested the methodology. Be confident about what you know works. Be specific about what hasn't been tested yet.

**Overselling with unverifiable claims.** "95% detail retention" without a source. "Transformative for throughput." If you can't cite it or demonstrate it, don't claim it.

**Clickbait titles.** "I built X. Here's how." / "The problem isn't Y. It's Z." Lead with signal, not hooks. Say what the thing is.

**Generic positive conclusions.** "The future looks bright" / "Exciting times ahead." End with something specific: a concrete next step, an open question, or a call to action with substance.

**Invented time frames.** Do not fabricate how long something took. "I spent weeks modeling..." or "After months of research..." are common AI conventions that assign unverified duration to the author's work. If the time spent is objectively known and verified (e.g., "seven architecture revisions" is countable), state the work itself. If the duration is not known with certainty, omit it. Describe what was done, not how long it took.

---

## Final-pass checklist

1. Search for em dashes. Replace all of them.
2. Search for bold text. Is each instance genuinely necessary?
3. Read the first two words of every paragraph. If multiple paragraphs start with labels ("Persistent context.", "Learning loops.", "Smart routing."), restructure them.
4. Read three consecutive sentences aloud. If they're all the same length, vary them.
5. Search for the AI vocabulary list above. Replace or cut.
6. Check every claim. Can you source it or demonstrate it? If not, soften the language or cut the number.
7. Read the title. Does it say what the thing is, or does it tease? Say what it is.
8. Read the last paragraph. Does it end with something concrete or something vague? Make it concrete.
9. Check for "not X, it's Y" and "X, not Y" constructions. Both directions are AI tells. Rephrase.
10. Ask: "would I actually say this out loud to someone?" If not, rewrite it.
11. Search for time-duration claims ("weeks", "months", "spent days", "after years of"). Can you verify the exact duration? If not, describe the work instead of the time.
