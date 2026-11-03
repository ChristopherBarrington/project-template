---
paths:
  - '**/proposal.md'
---

# Planning from a proposal

Applies when asked to plan from a `proposal.md`. The proposal is the user's: read it, never edit it. Your output is a plan, not the analysis, so change no file except `plan.md`.

- Read the proposal and the files and links it names, read-only.
- Before planning, ask the user focused questions, with options and a recommendation, if the answer would change the plan. Each line starting `Question:`, usually inside a `> [!WARNING]` callout, is a point the user is unsure about and wants your advice on: answer it with a recommendation and reasons in the plan, and ask only if you cannot.
- Write one self-contained plan to `plan.md` beside the proposal. Include the approach and reasons, the alternatives rejected, small ordered steps each with the check that shows it worked, how every aim and success criterion is covered, and the risks and assumptions you could not verify.
- Challenge the proposal. Say where it is ambiguous, inconsistent, over-scoped or lacks a success criterion that can be checked, and offer a simpler route where one exists. Do not agree by default.
- If the proposal is fundamentally flawed, say so plainly before anything else, at the top of your reply and again at the top of `plan.md` under a `> [!CAUTION]` callout. Flawed means the design or method cannot answer the question or would mislead: for example confounded groups, no replicates, an underpowered comparison, circular analysis, double use of the data, ignoring batch effects, or an assumption the data clearly violate. State what is wrong, why it matters and what you would do instead. Do not soften this, bury it in a list of risks or plan around it silently. Ask whether to proceed, and continue only once the user has answered.
- Do not add aims. Mention, but do not plan, anything outside the proposal that seems worth doing.
- The user comments in `plan.md`. Give a genuine opinion on each comment, and push back if it looks wrong, costly or inconsistent with earlier decisions, naming its knock-on effects on other steps, files or decisions. If you think a comment is a mistake, state the concern and wait for the user to confirm before applying it.
- Answer each comment as accepted, partly accepted or declined, with the reason, then revise the plan. Summarise what changed since the previous version: the comment, your response and the resulting change. Never change anything silently; if you change something that was not asked for, say so and why.
- End each revision with the open questions and risks, and what the user needs to decide next. Keep raising a concern while it is unresolved, and stop once the user has addressed it or knowingly accepted the risk.
- Say what you know and what you are guessing, and what you have not checked.
- When the user says the plan is agreed, remove review history, comments and discarded options, keeping the decisions, steps, risks and the coverage of the aims, so that an implementing agent needs nothing else.
