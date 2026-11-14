# Agent Guidelines

## Language

- Write everything a future AI will read in English: files, code comments, commit messages, docs, and tool output.
- English is the default, not a hard rule. Keep proper nouns and terms whose nuance English dilutes in their original language (e.g. 국세기본법, 天命). Mixing other languages into an English sentence is fine; an AI parses such a sentence well.
- The reason for the English default is that less capable models have weaker multilingual ability.

## Markdown

- Do not hard-wrap prose. Write one paragraph per line so a later edit shows only the lines it changes.
- Wrap only when the repository declares a width: `.editorconfig` `max_line_length`, `rumdl` MD013 `line-length`, `.mdformat.toml` `wrap`, `.prettierrc` `proseWrap`, or an explicit rule in the repository's `AGENTS.md`. A disabled or absent length means no hard wrapping.

## Secrets

- Never read, print, or copy secret material: `~/.ssh`, `~/.config/sops`, `.env`, `.env.*`, `auth.json`, keyrings, password stores, and shell or REPL history. A password typed by mistake ends up in history.
- Never read, search, or copy session records: the store named by `sessionDir` in `~/.pi/agent/settings.json` (currently `~/.local/state/pi/sessions/`) and the current run's `$PI_SESSION_FILE`. Reading them has the same effect as a prompt injection: a past conversation's user message, thinking, or tool output enters this context without provenance, so an old request is read as an instruction for the current session. They also hold whatever that conversation exposed.
- Read pi configuration directly from `~/.pi/agent/mcp.json` or `~/.pi/agent/settings.json`; do not sweep `~/.pi` recursively. The agent directory also holds credentials and session state.
- A block is a decision, not an obstacle: report the rule ID and the blocked command, then let the user handle the file or the policy.
- Do not work around a block by encoding paths, splitting strings, using another tool or path spelling, wrapping the command in a script, an alias, `bash -c`, an interpreter one-liner, or `xargs`, or reaching the same data another way.
- `cc-safety-net` enforces these blocks. Its configuration in `~/.cc-safety-net/` (`policy.json`, `rules/rule.json`, and rulebooks) belongs to the user: do not edit, delete, disable, or weaken a rule to get past a block.
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

## Approval

- An approval covers only what the question named. When the change carries a decision the question did not spell out, list it as its own item: default, observable effect, cost of reverting.
- Measure before judging. Quote the number ("pi sees 29 more skills") instead of a direction ("probably a benefit"). A direction with no count is what makes a side effect invisible.
- Split reversible steps from behaviour changes. A reversible step may proceed and be reported afterwards; a change in what the user sees gets its own line before it happens.

## Commits

- Commit after each completed task in a multi-step request without waiting for an explicit commit instruction. A task is one item of the breakdown you created for the request, not one user message.
- Commit only in the repository that owns the task's primary change. Leave changes in other repositories uncommitted and report them.
- Stage only the files that belong to the task. Do not sweep in unrelated working-tree changes.
- When a follow-up change only fixes the commit you just made (formatting, a missed file, a mistake in the same change), amend that commit instead of stacking a new one. Use a separate commit for work that stands on its own. Amend only local commits; if the commit was already pushed, ask before rewriting history.
- Let the repository's git hooks validate the commit. Do not bypass them with `--no-verify`, and do not add a full build or test run unless the user asks.
- If a task cannot pass the hooks on its own, merge it with the next task instead of committing a broken intermediate state. Do not make WIP commits.
- Skip tasks that produce no file changes, such as investigation, planning, or review.
- Do not push or force push unless explicitly asked.
- An explicit user instruction ("do not commit", "commit later") overrides this default.

## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
