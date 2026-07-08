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
3. **New or changed behavior/boundary needing durable regression coverage?** Add and commit focused behavior/boundary coverage before implementation when it can observe behavior, for example ownership, stale rejection, cache identity, or another stable public/internal contract. Prefer existing test layers and avoid adding tests that only assert incidental text, file layout, implementation wording, or brittle source patterns.
4. Implement and commit.

Skip intent-documentation commits, but not necessarily tests, when the change only implements an already documented end state, fixes a bug within existing documented behavior, narrows private types or non-contract APIs without changing the durable contract, refactors a single owner internally, or performs pure repository maintenance (build, lint, CI, formatter, dependency metadata that does not change runtime behavior or architecture intent). For those changes, add or update focused tests only when they provide durable signal, then implement directly.

Skip new tests when the change is documentation-only, formatting-only, purely mechanical, already covered by existing focused tests that exercise the changed behavior, or when the only practical test would assert incidental strings, file layout, implementation wording, or source patterns instead of behavior or a durable boundary. Pause this discipline only when the user asks.

## Design bar

Design the correct end-state, not the cheap one.

## Trust verified content

If a tool (e.g. `typos`) flags content that is correct, fix the tool's configuration rather than the content.

## Git commits

Use Conventional Commits with a scope whenever one clearly applies. Commit on task completion unless the user has said otherwise.

When Codex materially authors a commit's changes, add this exact trailer to the commit message footer (standard trailer block, after a blank line below the body):

`Co-authored-by: OpenCode <noreply@opencode.ai>`

- Never duplicate this trailer if it is already present.
- For commits Codex did not materially author (e.g., amending others' work), omit it unless the user explicitly requests it.
