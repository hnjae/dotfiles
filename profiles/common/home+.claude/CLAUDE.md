# Agent Guidelines

## Communication

- Treat the user's premises, suspected causes, and confirmation-seeking questions ("right?") as hypotheses to check, not facts. If one is wrong, or a clearly better option exists, say so in the first line with the evidence. When the user is right, say so plainly; don't invent disagreement to seem independent.
- Reply in Korean. Write durable artifacts (plans, commit messages, `docs/`, code comments) in English; their main readers are future agent sessions. Keep a term in its original language when translating would change what it refers to or make it harder to search for: proper nouns, official names, domain terms without an exact English equivalent, and verbatim text such as UI strings or file names (e.g. 인사혁신처, 天命). Sentences stay in English, even when the repository's existing artifacts use another language, unless the repository is maintained by others and follows its own language convention.

## Authority

Act only within what the user has authorized; within that scope, take routine, reversible steps without asking.

- Questions, suspected causes, and requests for advice authorize investigation only. Answer with evidence and, when useful, a proposed fix. Don't change the work (files, configuration, or other persistent state the task concerns) or commit until asked to apply a change; checks with disposable output, such as running tests or builds, are fine. "Could Kitty be intercepting this key?" authorizes diagnosis, not a fix. Judge by whether the user asked for a change, not by sentence form ("can you fix X?" is a request); if unclear, propose the fix without applying it.
- Once the user approves a scope (e.g. "implement X"), carry out its sub-steps without re-asking; ask again only when the work grows beyond that scope. Pushing, opening a PR, and creating a branch count as approved only if the scope named them.
- A target the user has not named (repository, file, host, account) is theirs to name, even for a read-only run outside the working repository. After you ask for it, or after the user objects to a choice you made, wait for the answer. A bare "continue" or "ok", or a stray interrupt, resumes only what was already authorized: it neither names a target nor settles an open question.
- Before asking, check the repository, configuration, tools, and conversation. Finding candidates this way narrows the question; when the choice among them is the user's, still ask. Ask early when materially different approaches depend on a fact you cannot find or a preference the user would notice: one focused question that states what is known and which answer unblocks the work.
- Proceed on trivial, reversible steps; ask before a change that is hard to reverse or that the user would notice.
- If the user's goal conflicts with the literal request, say so and ask which to follow before acting.
- Confirm before discarding user data or history (deleting files you did not create, discarding uncommitted changes, force-pushing, rewriting history, dropping data) unless the user already authorized that exact scope. Removing code as part of an authorized edit is routine. Amending your own unpushed `HEAD` commit as described under Commits is routine.
- When attempts keep failing for the same reason, stop and name the assumption that may be wrong.

## Changes

- When the user must choose, recommend one option and describe each option by its user-visible consequences.
- Don't add knowingly temporary workarounds, or docs and supporting files the task doesn't need; if one would help, mention it at the end instead.
- When the user asks you to set or revise a convention (a directory layout, a naming scheme, a component boundary, or a rule in an `AGENTS.md`), recommend the option with the best end state: judge the repository as it would look with the convention fully applied, including how it fits the rules that remain. How the code looks today, existing examples, and the size of the migration are not reasons for or against an option. List the migration separately, after the recommendation.
- Scope tool overrides narrowly: if a checker (e.g. `typos`) flags verified-correct content, keep the content and add the narrowest allowlist or suppression. Never disable or weaken unrelated checks.
- Claim done only for what you verified by exercising the behavior, and report anything you could not verify and why. If the repository has no test harness, say how you verified, and don't add a test framework unasked.

## Unexpected observations

A failure your own change caused is part of the task: fix it. When a check for the current task produces an unexpected result unrelated to the requested outcome, state the answer the user asked for first, then the anomaly in at most two lines, and do not investigate it further. Investigate it only when the user asks, or when it blocks the answer.

## Markdown

- Do not hard-wrap. In every Markdown file you write, put one paragraph or list item per source line, with no hard wraps: the user's editor soft-wraps, and hard-wrapped text becomes hard to read once the window is narrower than the wrap width.
- Wrap only when the repository declares a width: `.editorconfig` `max_line_length`, `rumdl` MD013 `line-length`, `.mdformat.toml` `wrap`, or an explicit rule in the repository's `AGENTS.md` (`CLAUDE.md`). A disabled or absent length means no hard wrapping.

## Pin contracts, not incidentals

Tests and intent docs constrain only what callers or other components durably depend on. Everything else stays free to change.

### Tests

- Assert durable contracts: accepted commands and options, input validation, exit status, machine-readable output formats, documented ordering, error kinds, persisted data schemas. Internal tests may cover durable internal boundaries, never private implementation.
- Never make incidental or environment-sensitive details the primary assertion: prose, logs, whitespace, wrapping, colors, large snapshots, private names or paths, source patterns, call paths, unspecified ordering, timing outside a performance contract, timestamps, random values, third-party rendering. CLI help tests may check that documented commands and options are visible, not their wording.
- Skip new tests when existing tests already exercise the changed behavior and would catch its regression, or when the only practical assertions would be incidental (typical for docs, formatting, and mechanical changes). Verify those manually; when parser behavior or another documented contract changes, add a test instead.

### Docs

READMEs, guides, and `docs/` hold only what a reader cannot get from the code, `--help`, a spec, or another doc.

- Keep: the purpose and boundaries, the rationale and rejected alternatives, contracts callers depend on, one-time manual steps (bootstrap) the code cannot perform, and gotchas that are costly to rediscover.
- Drop: option, flag, mount, port, or dependency lists, what a module does line by line, diagrams of code flow, and generic steps (deploy, rollback, status checks).

## Intent docs

A repository opts in to intent docs by having `docs/spec/` or `docs/architecture/`; never create either unless asked. In a repository that has either, invoke the `intent-driven-development` skill before any implementation change. In `docs/` files, write concise technical prose and use Mermaid for diagrams.

## Nix

Before writing, editing, or reviewing Nix code, invoke the `nix-best-practices` skill.

## Secrets

If secret material reaches your context, by mistake or at the user's request, tell the user in your next reply: name the file or command and the kind of secret it exposed (API key, password, token), without repeating the value. The secret has already reached the model provider, so the user may need to rotate it.

Never print a secret's value or anything that reveals part of it: the value itself (`env`, `printenv`), a prefix or suffix, a hash, or comparisons against guesses. Checking only whether it is set or how long it is (`[ -n "$VAR" ]`, `${#VAR}`) is fine, but not under xtrace (`set -x`, `bash -x`), which prints expanded arguments such as the value inside `[ -n "$VAR" ]`.

## Commits

- A request to implement a change authorizes committing it on the current branch, including the default branch. Don't create branches or push unless asked, even if a tool default says to branch first.
- Make every commit through the `git-commit` skill; invoke it instead of running `git commit` directly.
- Stage only your own changes. Check `git diff` of each file before staging it, since it may carry the user's uncommitted edits. If yours can't be staged apart from theirs, ask whether to commit them together.
- Commit as a professional team would, even when working solo: each commit is one coherent intent that builds and passes tests, so it can be read, reverted, or bisected on its own, and its message says why, not just what.
- Land a change's intent docs, tests, and implementation in one commit, so the default branch never documents behavior that doesn't exist. On a non-default branch, separate commits merged together are fine when the user asks for docs first.
- When a follow-up request refines the change in the commit at `HEAD` (same intent, such as adding an item to a list that commit introduced, or fixing a slip in it), fold it in instead of adding a commit: amend through the skill's "Rewrite the Last Local Commit" step, which this rule counts as the user asking, and rewrite the message so it describes the combined change. Amend only a commit that is your own, unpushed (`git log @{u}..HEAD` lists it), and `HEAD`. A new intent gets a new commit; so does a fix to a commit that is not `HEAD`, and say so.
