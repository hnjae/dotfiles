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
3. **New or changed behavior/boundary needing durable regression coverage?** Add and commit focused behavior/boundary coverage before implementation when it can observe behavior, for example ownership, stale rejection, cache identity, or another stable public/internal contract. When practical, commit the focused test in its expected failing state before implementation rather than weakening it to pass. Prefer existing test layers and avoid adding tests that only assert incidental presentation details or private implementation details.
4. Implement and commit.

Skip intent-documentation commits, but not necessarily tests, when the change only implements an already documented end state, fixes a bug within existing documented behavior, narrows private types or non-contract APIs without changing the durable contract, refactors a single owner internally, or performs pure repository maintenance (build, lint, CI, formatter, dependency metadata that does not change runtime behavior or architecture intent). For those changes, add or update focused tests only when they provide durable signal, then implement directly.

Skip new tests when the change is documentation-only, formatting-only, purely mechanical, already covered by existing focused tests that exercise the changed behavior, or when the only practical test would assert incidental strings, private file layout, implementation wording, source patterns, or CLI help text instead of behavior or a durable boundary. Exact help prose is not a test contract unless explicitly specified; do not add tests solely to pin help-message wording, command descriptions, examples, or usage prose. Verify those manually unless the change alters parser behavior such as accepted commands, accepted options, option ownership, validation, exit status, or a documented help structure/visibility contract such as command or option visibility. Relax this sequencing and test-selection discipline only when the user explicitly asks.

## Avoid over-constraining tests

Do not add tests that freeze presentation details, incidental implementation choices, or environment-sensitive output instead of a durable user-visible or architectural contract. In particular, avoid new tests whose primary assertion is exact help prose, documentation wording, log/debug/progress message text, pretty table whitespace, terminal wrapping, box drawing, color codes, large output snapshots, private function/class names, private import paths, incidental file layout, source-code patterns, implementation call paths, incidental ordering not declared by spec, exact timing/performance numbers outside a performance contract, third-party tool rendering, temporary migration states, local absolute paths, timestamps, exact random values unless seeded or specified, or environment-specific resource names. Test import paths or file locations only when they are documented public/API contracts.

Prefer tests that would fail only when a real contract breaks: accepted commands and options, option ownership, validation rules, exit status, stable machine-readable formats, documented ordering, public/internal boundary behavior, durable error kinds/codes, manifest/schema fields, cache identity, stale rejection, ownership, and other behavior a user or caller can depend on. Internal tests are appropriate for durable internal boundaries, not private implementation details. Contract-safe CLI help tests may assert documented command or option visibility without pinning exact prose, wrapping, or formatting. If a change is mainly non-contractual copy, formatting, visual layout, or explanatory UX text, verify it manually and rely on specs/docs plus review rather than adding brittle tests.

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
