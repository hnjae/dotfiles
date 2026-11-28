# Agent Guidelines

## Language

- Write everything a future AI will read in English: files, code comments, commit messages, docs, and logs and output another program or agent consumes. This rule does not set the language of your replies to the user.
- English is the default, not a hard rule. Keep proper nouns and terms whose nuance English dilutes in their original language (e.g. 국세기본법, 天命). Mixing other languages into an English sentence is fine; an AI parses such a sentence well.
- The reason for the English default is that less capable models have weaker multilingual ability.

## Prose

- When writing instructions, docs, or comments, a sentence earns its place by changing what the reader does or believes: a rule, a requirement, a fact they would otherwise get wrong, a decision they would otherwise make differently. Delete a clause and re-read; if the text still says the same thing to do, leave it deleted.
- Put mechanism in the document whose subject is that mechanism (e.g. `docs/architecture`, an API reference, a comment at the site) or in the commit message. In a rule or a procedure, the action and the condition that changes it are the whole content.
- Keep a measured finding however long it runs: a dated observation or a failure mode seen in practice changes decisions.

## Markdown

- Do not hard-wrap. In every Markdown file you write, put one paragraph or list item per source line, with no hard wraps: the user's editor soft-wraps, and hard-wrapped text becomes hard to read once the window is narrower than the wrap width.
- Wrap only when the repository declares a width: `.editorconfig` `max_line_length`, `rumdl` MD013 `line-length`, `.mdformat.toml` `wrap`, or an explicit rule in the repository's `AGENTS.md` (`CLAUDE.md`). A disabled or absent length means no hard wrapping.

## Docs

READMEs, guides, and `docs/` hold only what a reader cannot get from the code, `--help`, a spec, or another doc.

- Keep: the purpose and boundaries, the rationale and rejected alternatives, contracts callers depend on, one-time manual steps (bootstrap) the code cannot perform, and gotchas that are costly to rediscover.
- Drop: option, flag, mount, port, or dependency lists, what a module does line by line, diagrams of code flow, and generic steps (deploy, rollback, status checks).
- State a fact once and link to it elsewhere. Before deleting a section, search for code comments that point at it.

## Secrets

- Never read, print, or copy secret material: `~/.ssh`, `~/.config/sops`, `.env`, `.env.*`, `auth.json`, keyrings, password stores, shell or REPL history, and any credential in the process environment (`env`, `printenv`, `export -p`, `set`). A password typed by mistake ends up in history. Templates such as `.env.example` and `.env.sample` are not secret material.
- Never print anything that reveals part of a secret either: a prefix or suffix, a hash, its decrypted form, or comparisons against guesses. `grep VAR ~/.zshrc` and `env | grep` print the value itself. Checking only whether it is set or how long it is (`[ -n "$VAR" ]`, `${#VAR}`) is fine, but not under xtrace (`set -x`, `bash -x`), which prints expanded arguments such as the value inside `[ -n "$VAR" ]`.
- Exception: when the user explicitly asks you to read or check a specific secret file or value, you may do so for that request only. A `cc-safety-net` or harness block still wins: report it instead of working around it.
- A `${VAR}` reference in a config file names a requirement, not a question to answer. Report the name and let the user supply the value, or take the option that reads nothing: a keyless endpoint, OAuth login, or asking.
- Every tool result reaches the model provider, so printing a secret once discloses it off the machine even when no file changes. "Just checking" is a disclosure.
- If secret material reaches your context, by mistake or at the user's request, tell the user in your next reply: name the file or command and the kind of secret it exposed (API key, password, token), without repeating the value. The secret has already reached the model provider, so the user may need to rotate it.
- When `cc-safety-net` or the harness blocks a command, treat the block as the user's decision: stop, report what was blocked, and let the user handle the file.
- Do not work around a block by encoding paths, splitting strings, or reaching the same data another way.
- Shell commands may run without a confirmation prompt, so you alone must keep every command away from credentials. Whether to sandbox commands is the user's decision.
- `cc-safety-net` enforces blocks. Its configuration in `~/.cc-safety-net/` (`policy.json`, `rules/rule.json`, and rulebooks) belongs to the user: do not edit, delete, disable, or weaken a rule to get past a block.

## Investigation

- When attempts keep failing for the same reason, stop and name the assumption that may be wrong.
- Cap retries of the same probe at three tries. If all three fail, report the conclusion and the evidence, and ask before trying a fourth variation.
- Vary one input per try and record the observed result. If two values of an input give the same result, look for the cause elsewhere first; the input may still matter outside the values you tried.
- Before calling an external tool's behavior a bug, check its official documentation and say that you did. An undocumented behavior you have not looked up is not evidence of a bug.
- When identical runs give different results, first suspect an uncontrolled input: fix every input you can, change one, and re-measure. If the result still varies, the system may be genuinely non-deterministic (network, concurrency, model sampling); report that instead of retrying.
- When a question is answered, say so and name the next action instead of continuing to gather supporting evidence.

## Claims

- Write a statement as fact only when a tool result or a file you read in this session shows it. For a mutable external system, name the check and the date in the same sentence.
- Label every other claim about the current state of files, repositories, services, hosts, versions, or prices where it appears: `from training data`, `inferred from <source>`, or `not checked`. Training data cannot establish the current state of an external repository, service, or host.
- An absence in what you read is not an absence in the system: a README naming no `stable` branch does not establish that the repository has none. Fetch the branch list or report only what you read.
- When a claim turns out to be unverified, name that claim and the evidence that corrects it. Do not restate the corrected conclusion as though the original sentence had been checked.

## Planning

- For a change beyond a single obvious edit, send an approach message before the first edit: what already exists, the options and their cost, the one you recommend, the policy choices left open, and how you will verify it. Wait for agreement when the request does not name the approach.
- Do not start a build or fetch that runs for minutes before the approach is agreed. A cancelled run is a signal about the approach: stop and ask instead of retrying a variant.
- Treat each finding that blocks the user's goal as a constraint. If the investigation shows that a design the task touches is fragile, duplicative, or wrong in a way that blocks the goal, make removing it a required step of the plan. Do not move that removal to an optional phase. Report other such findings without acting on them.
- If an optional phase is the only thing preventing a known-bad state, either make it required or keep the bad state out of the implementation.
- A temporary fallback must carry its removal condition in the plan ("temporary: remove when X") and must not ship as the final state.
- Before implementing, re-read the plan against the findings that produced it. If a step contradicts a stated principle, fix the plan; the principle stays.

## Reporting

- Ask before moving from investigation into implementation when the user asked only a question (such as whether something is the cause) or for a plan or a survey. Those requests authorize investigation, not edits or commits.

## Approval

- An approval covers only what the question named. When the change carries a decision the question did not spell out, list it as its own item: default, observable effect, cost of reverting.
- Measure before judging. Quote the number ("pi sees 29 more skills") instead of a direction ("probably a benefit"). A direction with no count is what makes a side effect invisible.
- Split reversible steps from behavior changes. A reversible step within the agreed approach may proceed and be reported afterwards; a change in behavior the user sees that the request did not name gets its own item and approval before you make it.
- Ask before discarding data you did not create: deleting files, `git reset --hard`, `git checkout -- <path>`, `git clean`, or dropping a stash. These cannot be undone.
- Ask before outward-facing actions: opening PRs or issues, posting comments, sending messages. They publish content that may be cached or indexed even if deleted later.

## Changes

- Make only the changes the request asks for or clearly needs; every changed line should trace to the request.
- Do not add unrequested features, refactors, abstractions, configurability, or handling for impossible cases. If one would help, mention it at the end instead of making it.
- Follow the existing conventions; do not reformat or tidy adjacent code.
- if a checker (e.g. `typos`) flags verified-correct content, keep the content and add the narrowest allowlist or suppression. Never disable or weaken unrelated checks.

## Verification

- When you change code that can be run, built, or type-checked, run a real check that exercises the change before reporting it done: the project's tests, type-checker, or build, or the changed command itself. A syntax-only check, or a check command that failed to start, does not count. If no real check can run, say which one you did not run and why instead of reporting the change as done.

## Skills

- If your harness has no skill tool, read `~/.agents/skills/<name>/SKILL.md` and follow it.

## Nix

Before writing, editing, or reviewing Nix code, invoke the `nix-best-practices` skill.

## Intent docs

A repository opts in to intent docs by having `docs/spec/` or `docs/architecture/`; never create either unless asked. In a repository that has either, invoke the `intent-driven-development` skill before any implementation change. In `docs/` files, write concise technical prose and use Mermaid for diagrams.

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
