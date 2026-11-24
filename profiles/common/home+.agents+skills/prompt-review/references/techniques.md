# Prompting techniques

Distilled from Anthropic's guides, synced 2026-11-21. Fetch a markdown copy when a rule needs its full wording or a section is summarized here only as a pointer:

- [Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices.md): all general rules below.
- [Prompting Claude Haiku 5.5](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-haiku-5-5.md): the Haiku 5.5 notes.

Out of scope, so pointer only (all in the best-practices guide): thinking and `effort` configuration, `budget_tokens`, migrating away from prefilled responses, structured outputs, append-only conversation history, the frontend aesthetics block, and the vision crop tool. The guide also publishes blocks meant to be copied word for word: "Payments, account numbers, and financial records" and "Medication dosing". When a target agent handles payments, account numbers, customer records, or medicine doses, point to the block instead of paraphrasing it.

## Clarity

### Be explicit about the outcome

Check: would a capable colleague with no context on the task follow the prompt without asking questions? Look for unstated output format, unstated constraints, and behavior beyond the literal task that the author expects but never asks for. Current models follow instructions precisely and do not infer extra scope from a vague prompt.

Fix: name the format, constraints, and any above-minimum effort wanted ("Include as many relevant features as possible"). Use numbered steps when order or completeness matters.

### Give the reason

Check: a bare rule with no motivation, especially a prohibition.

Fix: add the reason. Claude generalizes from it to cases the rule does not name. "NEVER use ellipses" becomes "The response is read aloud by a text-to-speech engine, so never use ellipses; it cannot pronounce them."

### State format targets positively

Check: style or format rules phrased as prohibitions ("Do not use markdown").

Fix: state the target ("Write in flowing prose paragraphs"), or name an XML wrapper for the output (`<prose_paragraphs>`). Keep prohibitions that are hard constraints (safety, scope, authority, irreversible actions); give each a reason and, where possible, the positive behavior beside it.

### Match the prompt's style to the output

Check: the prompt's own formatting differs from the output it asks for, such as a markdown-heavy prompt that asks for plain prose.

Fix: write the prompt in the style of the desired output; removing markdown from the prompt reduces markdown in the output.

### Remove preambles

Check: replies that open with "Here is…" or "Based on…" where the output is consumed directly.

Fix: "Respond directly without preamble." The guide recommends this instruction, not a prefill.

### Keep reasoning out of the response

Check: instructions to write reasoning or thinking in the reply, such as in `<thinking>` tags or as a visible chain of thought.

Fix: remove them. Some current models decline such requests (`reasoning_extraction` refusals), and models with thinking reason internally anyway. Ask for the final answer in a defined place (`<answer>` tags, a fixed section) instead.

### Prefer general reasoning guidance over scripted reasoning

Check: a hand-written step-by-step plan for how to *think* about a problem.

Fix: replace it with general guidance ("think thoroughly about X"); the model's own reasoning often exceeds a prescribed plan. Procedural steps, where the order of *actions* matters, stay as steps. Worked examples that show problem, method, and answer remain useful.

## Structure

### Use examples well

Check: examples that are absent where format or tone matters, too similar to each other, unrepresentative of real inputs, or unmarked so they blur into instructions.

Fix: make them relevant, diverse across edge cases, and wrapped in `<example>` tags (several inside `<examples>`). Three to five works best.

### Separate content types with XML tags

Check: instructions, context, examples, and variable inputs interleaved without boundaries.

Fix: wrap each type in a consistently named tag (`<instructions>`, `<context>`, `<input>`), nesting where the content is hierarchical (`<documents>` holding `<document index="n">`).

### Put long material first

Check: long documents or data (20k+ tokens) placed after the question or instructions.

Fix: put the material at the top and the query at the end; this improved response quality by up to 30 percent in Anthropic's tests. Wrap each document in `<document>` with `<source>` and `<document_content>` subtags. For long-document tasks, ask for relevant quotes first, then the answer based on them.

### Set a role when the prompt defines an agent

Check: a subagent or delegation prompt with no statement of who the agent is or what it specializes in.

Fix: add one sentence of role; even that focuses behavior and tone.

## Emphasis and triggering

### Calibrate emphasis

Check: `CRITICAL`, `IMPORTANT`, `MUST`, all caps, or repeated warnings around ordinary instructions, often carried over from prompts written for older models that undertriggered.

Fix: use plain imperative wording ("Use this tool when…"). Current models respond strongly to the system prompt and overtrigger on aggressive language. The instruction keeps its scope; only the volume drops.

### Remove anti-laziness carry-overs

Check: blanket defaults ("Default to using X"), tie-breakers toward action ("If in doubt, use X"), or exhortations to be thorough and use tools aggressively.

Fix: replace blanket defaults with a targeted condition ("Use X when it would improve your understanding of the problem"), and delete over-prompting. Current models are proactive enough that these cause overtriggering and over-exploration.

### Make the authority to act explicit

Check: wording whose intent to act is ambiguous. "Can you suggest changes" yields suggestions only; an agent prompt that never says whether to act or advise leaves the default to chance.

Fix: phrase requests as the action wanted ("Change this function to…"). For agents, state the default: implement unless told otherwise (the guide's `<default_to_action>` block) or advise until explicitly asked (`<do_not_act_before_instructions>`).

## Agentic behavior

Apply these when the target directs an agent that uses tools; each fixes an observed failure, so add one only when the target lacks it and the failure applies.

### Guard scope against overengineering

Fix for coding agents that add unrequested features, files, abstractions, comments, or defensive code: state that only requested or clearly necessary changes are made, that one-off operations get no helpers, and that validation happens only at system boundaries. The guide's "Overeagerness" sample covers scope, documentation, defensive coding, and abstractions.

### Confirm before irreversible actions

Fix for agents with destructive or outward-facing tools: encourage local, reversible actions; require confirmation for destructive, hard-to-reverse, or externally visible ones (deleting, force-pushing, posting, messaging); forbid bypassing safety checks or discarding unfamiliar files as a shortcut.

### Ground claims in what was read

Fix for agents answering about code or documents: never make claims about a file that has not been opened; read referenced files before answering.

### Prefer general solutions over passing tests

Fix for coding agents: implement the general logic rather than hard-coding test values, and report a test that looks wrong instead of working around it.

### Clean up scratch files

Fix when leftover helper files are unwanted: ask the agent to remove temporary files, scripts, and helpers at the end of the task.

### Bound subagent use

Fix when delegation is overused: delegate when work can run in parallel, needs isolated context, or forms independent workstreams; work directly for simple tasks, sequential steps, single-file edits, or work that needs shared context.

### Batch independent tool calls

Fix when parallelism matters: make independent tool calls together and dependent ones in sequence, never guessing a parameter that depends on an earlier result.

### Structure research

Fix for research agents: define what a successful answer is, ask for verification across sources, and for complex topics ask for competing hypotheses with tracked confidence in a notes file.

### Carry state across long tasks

Fix for multi-window or long-running agents: keep structured state (such as `tests.json`) and freeform progress notes, use git as the log, tell the agent whether its context is compacted so it does not wrap up early, and say how a fresh window should start ("Review progress.txt, tests.json, and the git log").

### Ask for verification against criteria

Fix when the agent reports work done without checking: "Before you finish, verify your result against [criteria]." This is model-dependent: see the model notes, where Haiku 5.5 needs it and Opus 5 should not get it.

### Ask for progress updates when visibility matters

Fix when the agent skips summaries between tool calls: ask for a short summary after work that used tools. Some models write fewer updates by default (see the model notes).

## Model notes

When the target model is unknown, apply the Haiku 5.5 notes. Where the notes conflict, follow the target model's note: Haiku 5.5 benefits from an explicit verification instruction that Opus 5 should not get, so with an unknown target an existing one stays.

### Claude Haiku 5.5 (default)

Existing prompts generally work on Haiku 5.5 unchanged. Each addition below fixes an observed symptom: insert it only when the target has the named shape and the symptom has been reported, or the target is plainly exposed to it. Otherwise list it in the report as a symptom to watch for, not as an edit. Deletions (reasoning in the response, thinking steering) apply whenever the line is present.

- **Early stopping in long agent prompts.** With a long coding-agent system prompt at `low` effort, it sometimes stops early and hands the task back. When that is seen, add: "Keep working until everything the user asked for is done, and only stop to ask when you can't go on without the user or before a risky step. When the work the user asked for is done and checked, stop and report. Don't add new features, docs, or refactors that weren't asked for. If you think one would help, mention it at the end instead of doing it."
- **Unverified code changes.** At `low` and `medium` effort, it sometimes reports a code change as done without running a check. For a coding agent showing this, add an instruction to run a real check that exercises the change (tests, type-checker, build, or the changed command), noting that a syntax-only check or a check that failed to start does not count, and to say which check was skipped and why when none can run. The Haiku guide's "Tell coding agents to verify their changes" section has the tested paragraph.
- **Search.** When the agent has a search tool, give it the current date. If it still skips searches for facts that change, which happens most with long prompts, also add (skip this for a short prompt): "Your training data ends well before today's date. Records, office holders, prices, versions, rules, and anything 'latest' may have changed since then, so search for those before you answer, even when you feel sure. Facts that can't change need no search." Avoid blanket rules such as "search for any present-day factual question"; in testing they caused searches on half the prompts that needed none, without more correct answers.
- **Reasoning in the response.** Prompts, skills, and tool descriptions that ask it to write its reasoning in the reply can be refused (`reasoning_extraction`). Remove them (see "Keep reasoning out of the response").
- **Thinking.** Instructions to answer without thinking do not reduce thinking; delete them and note that thinking is controlled by the `effort` API setting.

### Other models

- **Claude Opus 5:** longer default responses, and effort does not reliably shorten them; prompt explicitly for conciseness. It verifies its own work well, so delete verification instructions carried over from older prompts rather than rewriting them. It delegates to subagents readily; add subagent bounds.
- **Claude Opus 4.5 and 4.6:** overtrigger on aggressive language, overengineer, overuse subagents, and may take risky actions without guidance; the emphasis, scope, subagent, and confirmation rules apply strongly. With thinking disabled, Opus 4.5 is sensitive to the word "think"; use "consider" or "evaluate".
- **Claude Fable 5.1:** formats less than earlier models, so anti-markdown blocks can suppress structure the content needs; remove them. It writes fewer progress updates in agentic work; ask for them explicitly and delete instructions to keep them brief.
- **Claude Fable 5.2:** instructions to answer without deliberating do not stop thinking at `medium` effort and above; delete them. On other models, thinking frequency is promptable (the best-practices guide's "Leverage thinking" section has a sample), so keep such lines for a known target that is neither Fable 5.2 nor Haiku 5.5.
- **All others listed below:** this file holds no model-specific notes for them; fetch their guide when tuning for them.

### Per-model guides

Markdown copies, fetched when the target model's notes are needed beyond this file:

| Model | Guide |
| --- | --- |
| Claude Fable 5.2, Mythos 5.2 | <https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-2.md> |
| Claude Fable 5.1, Mythos 5.1 | <https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1.md> |
| Claude Fable 5, Mythos 5 | <https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5.md> |
| Claude Sonnet 5.5 | <https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-sonnet-5-5.md> |
| Claude Sonnet 5 | <https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-sonnet-5.md> |
| Claude Opus 5.5 | <https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5-5.md> |
| Claude Opus 5 | <https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5.md> |
| Claude Opus 4.8 | <https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-4-8.md> |
| Claude Haiku 5.5 | <https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-haiku-5-5.md> |
