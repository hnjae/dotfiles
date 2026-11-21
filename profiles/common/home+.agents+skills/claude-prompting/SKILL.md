---
name: claude-prompting
description: Review or rewrite instruction text written for Claude against Anthropic's prompting best practices. Use when asked to review, improve, or rewrite a skill, a CLAUDE.md or AGENTS.md, a subagent or delegation prompt, or a one-off prompt. Not for system prompts of apps built on the Messages API or for API request settings, and not for creating a new skill or running skill evals (that is skill-creator).
---

# Claude Prompting

Review or rewrite text that Claude reads as instructions, applying the rules in [`references/techniques.md`](references/techniques.md). That file distills Anthropic's prompting guides; the rules carry the evidence, so cite them instead of personal taste.

## 1. Establish the job

- **Target and kind.** Identify the text: files (a skill directory, `CLAUDE.md`, `AGENTS.md`) or pasted text (a delegation prompt, a one-off prompt). For a skill, read the whole directory, since rules often live in the files `SKILL.md` points to. A system prompt for an app built on the Messages API, or API request settings, is out of scope: say so and point to the source guide listed in `techniques.md`.
- **Mode.** A request to review, check, or assess is **review**: report findings and edit nothing. A request to fix, improve, rewrite, or apply is **rewrite**. For pasted text, rewrite mode returns the new text in the reply rather than writing a file.
- **Target model.** Take it from the request, the file (such as a `model:` frontmatter field or the harness config that runs it), or the conversation. When it cannot be determined, target Claude Haiku 5.5, the least capable current model, and state that assumption in the report. Guidance tuned for the weakest model keeps a prompt working on stronger ones; the reverse does not hold.

## 2. Load the rules

Read `references/techniques.md` completely. If the target model has a per-model guide whose notes are not summarized there, fetch that guide's markdown copy from the table in `techniques.md` before diagnosing. Apply a model-specific note only to the model it names.

## 3. Diagnose

Check the target against every rule in `techniques.md`. Record each finding with:

- the location (`file:line`, or a quoted fragment for pasted text);
- the rule, by its heading in `techniques.md`;
- why it matters for this target and model;
- the proposed change.

Report only what a rule supports, and skip rules the text already satisfies. Structural concerns that the rules do not cover (pointer wording, progressive disclosure, pruning) belong to the `writing-for-agents` skill when it is available; mention them in one line without expanding.

## 4. Rewrite (rewrite mode only)

Before editing, list every requirement the original carries: each constraint, default, trigger branch, output contract, and stated exception. Then edit:

- Change only what a finding justifies. Keep the author's language, terminology, layout, and frontmatter conventions.
- Softening emphasis changes tone, never scope: a requirement that read `MUST` survives as a plain requirement.
- A skill's `description` is its trigger. Keep every trigger branch and the exclusions; reword only.

After editing, check the list: each requirement either survives in the new text or is named in the report as removed, with the rule that justifies removing it (for example, a carried-over instruction the target model's guide says to delete).

## 5. Report

- State the target model and whether it was assumed.
- **Review:** findings ordered by expected impact on behavior, each with location, rule, and proposed change.
- **Rewrite:** each change with a one-line rationale naming its rule, then the removed requirements (or "none").
- Say what remains unverified. These rules predict behavior; only running the prompt confirms it. For a skill whose triggering or behavior is in question, suggest skill-creator's eval loop.
