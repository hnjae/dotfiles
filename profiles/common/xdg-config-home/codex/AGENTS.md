# Agent Guidelines

## Documentation

- **Architecture** docs live in `docs/architecture/`; **user-facing specs** as per-subject files under `docs/spec/` (its `README.md` is an index, not an aggregate). Specs describe external behavior only — no implementation details.
- Prose is concise and technical. Don't hard-wrap: one paragraph or list item per source line unless Markdown syntax requires otherwise. Use Mermaid for diagrams.

## Land intent before implementation

> [!NOTE]
> `docs/spec` and `docs/architecture`
>
> These documents must describe the project’s intended **end state**, not the current implementation, a temporary milestone, a migration phase, a partial plan, or implementation progress.

For changes that add or alter the declared user-visible product contract or durable architecture intent, commit each applicable intent layer before implementation:

1. **Declared user-visible product contract added or changed?** If the repository has `docs/spec/`, update it and commit before code.
2. **Durable ownership, structure, boundary, identity, lifecycle, or architecture contract added or changed?** If the repository has `docs/architecture/`, update it and commit before code.
3. **New or changed behavior/boundary needing durable regression coverage?** Add focused behavior/boundary coverage before implementation when it can observe behavior, for example ownership, stale rejection, cache identity, or another stable public/internal contract. Verify that the focused test fails for the expected reason, then commit the test.
4. Implement and verify that the focused and relevant tests pass. Amend the implementation into the preceding test commit so the resulting committed revision is green, replace the test-only commit message with a Conventional Commit message that describes the completed behavior, and set required trailers based on authorship of the final amended contents. If no test commit was needed, commit the implementation normally.

Skip intent-documentation commits when the change implements an already documented end state, fixes a bug within existing documented behavior, narrows a non-contract API, refactors a single owner internally, or performs maintenance that does not change runtime behavior or architecture intent. Add focused tests only when they provide durable signal, then implement directly.

## Avoid over-constraining tests

Prefer tests that fail only when a durable contract breaks: accepted commands and options, validation and ownership rules, exit status, stable machine-readable formats, documented ordering, error kinds, schema fields, cache identity, stale rejection, or another behavior or boundary callers depend on. Internal tests may cover durable internal boundaries, but not private implementation details.

Do not add tests whose primary assertion freezes incidental or environment-sensitive details such as exact prose, logs, whitespace, wrapping, colors, large snapshots, private names or paths, source patterns, call paths, unspecified ordering, timing outside a performance contract, timestamps, random values, or third-party rendering. CLI help tests may assert documented command or option visibility without pinning wording or formatting. Skip new tests for documentation, formatting, mechanical changes, behavior already covered by focused tests, or changes whose only practical assertions would be incidental; verify them manually unless parser behavior or another documented contract changes.

## Design bar

Design the correct end-state, not the cheap one.

## Trust verified content

If a tool (e.g. `typos`) flags verified-correct content, preserve the content and apply the narrowest available allowlist or suppression. Do not disable or weaken unrelated checks.

## Git commits

Use Conventional Commits with a scope whenever one clearly applies. Commit on task completion unless the user has said otherwise.

Determine attribution from the final commit contents after any amend. When those contents include changes materially authored by Codex, add this exact trailer to the commit message footer (standard trailer block, after a blank line below the body):

`Co-authored-by: Codex <noreply@openai.com>`

- Never duplicate this trailer if it is already present.
- When the final commit contents contain no changes materially authored by Codex (e.g., Codex only amends another author's commit metadata), omit it unless the user explicitly requests it.
