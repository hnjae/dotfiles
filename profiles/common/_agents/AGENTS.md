# Agent Guidelines

## Language

- Write everything a future AI will read in English: files, code comments, commit messages, docs, and the output of programs you write. This rule does not set the language of your replies to the user.
- English is the default, not a hard rule. Keep proper nouns and terms whose nuance English dilutes in their original language (e.g. 국세기본법, 天命). Mixing other languages into an English sentence is fine; an AI parses such a sentence well.
- The reason for the English default is that less capable models have weaker multilingual ability.

## Markdown

- Do not hard-wrap prose. Write one paragraph per line so a later edit shows only the lines it changes.
- Wrap only when the repository declares a width: `.editorconfig` `max_line_length`, `rumdl` MD013 `line-length`, `.mdformat.toml` `wrap`, `.prettierrc` `proseWrap`, or an explicit rule in the repository's `AGENTS.md`. A disabled or absent length means no hard wrapping.

## Secrets

- Never read, print, or copy secret material: `~/.ssh`, `~/.config/sops`, `.env`, `.env.*`, `auth.json`, keyrings, password stores, shell or REPL history, and any credential in the process environment (`env`, `printenv`, `export -p`, `set`). A password typed by mistake ends up in history.
- Never probe a secret either. Whether a variable is set, how long it is, its hash, its first characters, or its decrypted form is the same material: `[ -n "$VAR" ]`, `${#VAR}`, `grep VAR ~/.zshrc`, `env | grep`, and comparing against a guess are all off-limits.
- A `${VAR}` reference in a config file names a requirement, not a question to answer. Report the name and let the user supply the value, or take the option that reads nothing: a keyless endpoint, OAuth login, or asking.
- Every tool result reaches the model provider, so printing a secret once discloses it off the machine even when no file changes. "Just checking" is a disclosure.
- When `cc-safety-net` or the harness blocks a command, treat the block as the user's decision: stop, report what was blocked, and let the user handle the file.
- Do not work around a block by encoding paths, splitting strings, or reaching the same data another way.
- Bash commands may run without a confirmation prompt, so you alone must keep every command away from credentials. Whether to sandbox commands is the user's decision.
- `cc-safety-net` enforces blocks. Its configuration in `~/.cc-safety-net/` (`policy.json`, `rules/rule.json`, and rulebooks) belongs to the user: do not edit, delete, disable, or weaken a rule to get past a block.

## Investigation

- When attempts keep failing for the same reason, stop and name the assumption that may be wrong.
- Cap retries of the same probe at three tries. If all three fail, report the conclusion and the evidence, and ask before trying a fourth variation.
- Vary one input per try and record the observed result. If two tries return the same result, the variable under test is not the cause; stop varying it.
- Before calling an external tool's behavior a bug, check its official documentation and say that you did. An undocumented behavior you have not looked up is not evidence of a bug.
- A non-deterministic result means your measurement is uncontrolled, not that the tool is random. Fix every input, change one, and re-measure.
- When a question is answered, say so and name the next action instead of continuing to gather supporting evidence.

## Planning

- Treat each finding as a constraint. If the investigation calls a design fragile, duplicative, or wrong, make removing it a required step of the plan. Do not move that removal to an optional phase.
- If an optional phase is the only thing preventing a known-bad state, either make it required or keep the bad state out of the implementation.
- A temporary fallback must carry its removal condition in the plan ("temporary: remove when X") and must not ship as the final state.
- Before implementing, re-read the plan against the findings that produced it. If a step contradicts a stated principle, fix the plan; the principle stays.

## Reporting

- Report when a phase ends: what is now known, what is still open, and the single next action.
- Ask before moving from investigation into implementation when the user asked only a question (such as whether something is the cause) or for a plan or a survey. Those requests authorize investigation, not edits or commits.

## Approval

- An approval covers only what the question named. When the change carries a decision the question did not spell out, list it as its own item: default, observable effect, cost of reverting.
- Measure before judging. Quote the number ("pi sees 29 more skills") instead of a direction ("probably a benefit"). A direction with no count is what makes a side effect invisible.
- Split reversible steps from behavior changes. A reversible step may proceed and be reported afterwards; list a change in what the user sees as its own item and get approval before making it.
- Ask before discarding data you did not create: deleting files, `git reset --hard`, `git checkout -- <path>`, `git clean`, or dropping a stash. These cannot be undone.

## Verification

- When you change code that can be run, built, or type-checked, run a real check that exercises the change before reporting it done: the project's tests, type-checker, or build, or the changed command itself. A syntax-only check, or a check command that failed to start, does not count. If no real check can run, say which one you did not run and why instead of reporting the change as done.

## Skills

- This file names skills such as `git-commit`. If your harness has no skill tool, read `~/.agents/skills/<name>/SKILL.md` and follow it.

## Intent docs

A repository opts in to intent docs by having `docs/spec/` or `docs/architecture/`; never create either unless asked. In a repository that has either, invoke the `intent-driven-development` skill before any implementation change. In `docs/` files, write concise technical prose with no hard wraps (one paragraph or list item per source line) and use Mermaid for diagrams.

## Commits

- Commit after each completed task in a multi-step request without waiting for an explicit commit instruction. A task is one item of the breakdown you created for the request, not one user message.
- Commit only in the repository that owns the task's primary change. Leave changes in other repositories uncommitted and report them.
- Stage only the files that belong to the task. Do not sweep in unrelated working-tree changes.
- Write the commit message with the `git-commit` skill.
- When a follow-up change only fixes the commit you just made (formatting, a missed file, a mistake in the same change), amend that commit instead of stacking a new one. Use a separate commit for work that stands on its own. Amend only local commits; if the commit was already pushed, ask before rewriting history.
- Let the repository's git hooks validate the commit. Do not bypass them with `--no-verify`; they are the repository's own checks. Unless the user asks, do not run a full build or test suite only to gate a commit: the hooks are the commit gate. This does not replace the check under Verification.
- If a task cannot pass the hooks on its own, merge it with the next task instead of committing a broken intermediate state. Do not make WIP commits.
- Skip tasks that produce no file changes, such as investigation, planning, or review.
- Do not push or force push unless explicitly asked.
- An explicit user instruction ("do not commit", "commit later") overrides this default.
