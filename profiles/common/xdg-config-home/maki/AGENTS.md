# Agent Guidelines

## Language

- Write everything a future AI will read in English: files, code comments, commit messages, docs, and tool output.
- Interact with the user in Korean.
- English is the default, not a hard rule. Keep proper nouns and terms whose nuance English dilutes in their original language (e.g. 국세기본법, 天命). Mixing other languages into an English sentence is fine; an AI parses such a sentence well.
- The reason for the English default is that less capable models have weaker multilingual ability.

## Secrets

- Never read, print, or copy secret material: `~/.ssh`, `~/.config/sops`, `.env` and `.env.*`, keyrings, password stores, and shell or REPL history. A password typed by mistake ends up in history.
- A block is a decision, not an obstacle: report it and let the user handle the file.
- Do not work around a block by encoding paths, splitting strings, or reaching the same data another way.
- Everything else in bash runs without a prompt, so a command that touches credentials is on you. Sandboxing is the user's call.

## Investigation

- When attempts keep failing for the same reason, stop and name the assumption that may be wrong.
- Cap retries of the same probe at three tries. If all three fail, report the conclusion and the evidence, and ask before trying a fourth variation.
- Vary one input per try and record the observed result. If two tries return the same result, the variable under test is not the cause; stop varying it.
- Before calling an external tool's behavior a bug, check its official documentation and say that you did. An undocumented behavior you have not looked up is not evidence of a bug.
- A non-deterministic result means your measurement is uncontrolled, not that the tool is random. Fix every input, change one, and re-measure.
- When a question is answered, say so and name the next action instead of continuing to gather supporting evidence.

## Reporting

- Report when a phase ends: what is now known, what is still open, and the single next action.
- Ask before moving from investigation into implementation when the user asked only for a plan or a survey.

## Commits

- Commit after each completed task in a multi-step request without waiting for an explicit commit instruction. A task is one item of the breakdown you created for the request, not one user message.
- Commit only in the repository that owns the task's primary change. Leave changes in other repositories uncommitted and report them.
- Stage only the files that belong to the task. Do not sweep in unrelated working-tree changes.
- Let the repository's git hooks validate the commit. Do not bypass them with `--no-verify`, and do not add a full build or test run unless the user asks.
- If a task cannot pass the hooks on its own, merge it with the next task instead of committing a broken intermediate state. Do not make WIP commits.
- Skip tasks that produce no file changes, such as investigation, planning, or review.
- Do not push or force push unless explicitly asked.
- An explicit user instruction ("do not commit", "commit later") overrides this default.
