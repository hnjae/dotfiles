# Agent Guidelines

## Documentation

- **Architecture** docs live in `docs/architecture/`; **user-facing specs** as per-subject files under `docs/spec/` (its `README.md` is an index, not an aggregate). Specs describe external behavior only — no implementation details.
- Prose is concise and technical. Don't hard-wrap: one paragraph or list item per source line unless Markdown syntax requires otherwise. Use Mermaid for diagrams.

## Land intent before implementation

> [!NOTE]
> `docs/spec` and `docs/architecture`
>
> These documents must describe the project’s intended **end state**, not the current implementation, a temporary milestone, a migration phase, a partial plan, or implementation progress.

For feature work or behavior/structure changes, commit each applicable layer of declared intent — before the code:

1. Update docs:
    1. **User-visible behavior changed?** If the repository has `docs/spec/`, update it.
    2. **Structure changed?** If the repository has `docs/architecture/`, update it.
    3. Commit.
2. **Behavior to verify?** Add a failing test when practical. Commit.
3. Implement. Commit.

Each step is its own commit; skip the ones that don't apply. Pure repository maintenance (build, lint, CI, formatter, dependency metadata) has no intent layer — go straight to implementation. Pause this discipline only when the user asks.

## Design bar

Design the correct end-state, not the cheap one.

## Trust verified content

If a tool (e.g. `typos`) flags content that is correct, fix the tool's configuration rather than the content.

## Git commits

Use Conventional Commits with a scope whenever one clearly applies. Commit on task completion unless the user has said otherwise.

When Codex materially authors a commit's changes, add this exact trailer to the commit message footer (standard trailer block, after a blank line below the body):

`Co-authored-by: Codex <noreply@openai.com>`

- Never duplicate this trailer if it is already present.
- For commits Codex did not materially author (e.g., amending others' work), omit it unless the user explicitly requests it.
