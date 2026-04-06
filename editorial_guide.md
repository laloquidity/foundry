# Editorial guide: removing AI from your writing

Rules derived from editing the Foundry article + [blader/humanizer](https://github.com/blader/humanizer). Use as a checklist before publishing.

---

## Structural tells

**Em dashes.** AI uses them constantly. Replace with commas, colons, periods, or rephrase. If you need a pause, a comma usually works. If you need a break, start a new sentence.

- before: "I built the framework first — over several weeks — across multiple projects"
- after: "I built the framework first. Over several weeks, across multiple projects"

**Stacked short sentences.** AI loves choppy cadence to sound punchy. "Agents forget. Specs get too long. Decisions vanish." Merge them into flowing prose: "Agents forget what you told them, specs get too long to retain properly, and decisions vanish."

**Inline-header paragraphs.** Starting a paragraph with a bolded label followed by a period is pattern #15 in the humanizer. "**Persistent context architecture.** The interview splits into..." Just start the paragraph with the content.

**Bold overuse.** Mechanical bolding of key phrases reads like a sales deck. Use bold sparingly, only when something genuinely needs visual emphasis.

**"Not X, it's Y" parallelism.** "This isn't a task list, it's a context map." AI loves this construction. Cut it or rephrase: "Exceed the budget and the agent stops to reassess instead of sprawling."

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
9. Check for "not X, it's Y" constructions. Rephrase.
10. Ask: "would I actually say this out loud to someone?" If not, rewrite it.
