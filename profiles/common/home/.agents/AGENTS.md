# Agent Guidelines

## Communication

- Lead with the answer or the next concrete action, not a preamble. If work remains, end with the single next action rather than a recap, offer, or closing pleasantry.
- Make the first action small and immediately executable. For work with multiple steps, use the fewest numbered, bounded actions that still provide a complete path; do not bury several actions in one step.
- Keep the visible working set small. Aim for at most five items per list or group, ordered by relevance. Group or defer additional items without losing them when completeness matters.
- Do not rely on the reader to remember prior state. Restate the current step or concrete outcome when it is not otherwise visible through the harness task list.
- Make progress and completion explicit in observable terms: name what now works and how to exercise it. Use concrete time units when an estimate is useful; avoid vague effort labels.
- Suppress tangents until the current issue is complete. Resolve incidental questions yourself when possible; if user input remains necessary, ask once at the end.
- State errors matter-of-factly with the location, observed result, cause when known, and next fix. Avoid alarmist phrasing.
- Remove ceremonial openings, repeated summaries, figurative language, and hedges that carry no real uncertainty. When explanation is requested, provide the needed depth under skimmable headings without adding a preamble or closing filler.
- Safety and correctness override brevity. Confirm destructive actions, stop and expose a possibly wrong assumption after repeated failed fixes, and ask one focused question when genuine ambiguity cannot be resolved from available context.

## Engineering execution

- Think before editing. State consequential assumptions, uncertainties, and tradeoffs. If multiple materially different interpretations remain, present them instead of choosing silently. Prefer and name the simpler approach; push back on unnecessary complexity.
- Implement only what the request requires. Do not add speculative features, configurability, abstractions for a single use, or handling for impossible scenarios. If the solution is substantially larger than necessary, simplify it.
- Make surgical changes. Every changed line must trace to the request. Follow existing conventions; do not reformat, refactor, or clean up adjacent code merely because it could be improved.
- Remove imports, variables, functions, and other artifacts made obsolete by the current change. Leave unrelated pre-existing dead code alone and report it separately if relevant.
- Translate work into verifiable success criteria before implementation. For multi-step work, track bounded steps and their checks. Continue until the relevant behavior is exercised and the criteria pass.

## Documentation

- **Architecture** docs live in `docs/architecture/`; **user-facing specs** as per-subject files under `docs/spec/` (its `README.md` is an index, not an aggregate). Specs describe external behavior only — no implementation details.
- Prose is concise and technical. Don't hard-wrap: one paragraph or list item per source line unless Markdown syntax requires otherwise. Use Mermaid for diagrams.
- Architecture rules must state durable outcomes and invariants, not freeze a preferred implementation. Do not prescribe class or controller decomposition, internal graph or port topology, snapshot or revision counts, value representation, signal or notification choreography, dependency-injection style, or test-harness structure unless that mechanism is itself a durable cross-component constraint. If alternative implementations can
  preserve ownership, dependency direction, lifecycle safety, failure semantics, and observable behavior, leave the choice to implementation.

## Land intent before implementation

> [!NOTE]
> `docs/spec` and `docs/architecture`
>
> These documents must describe the project’s intended **end state**, not the current implementation, a temporary milestone, a migration phase, a partial plan, or implementation progress.

For changes that add or alter the declared user-visible product contract or durable architecture intent, write each applicable intent layer before implementation and review it before considering the change complete:

1. **Declared user-visible product contract added or changed?** If the repository has `docs/spec/`, update it before code.
2. **Durable ownership, structure, boundary, identity, lifecycle, or architecture contract added or changed?** If the repository has `docs/architecture/`, update it before code.
3. **New or changed behavior/boundary needing durable regression coverage?** Add focused behavior/boundary coverage before implementation when it can observe behavior, for example ownership, stale rejection, cache identity, or another stable public/internal contract. When practical, verify that the focused test fails for the expected reason; a failing test need not be preserved as a commit.
4. Implement the change and verify that the focused and relevant tests pass.

Choose commit boundaries that keep the change coherent and reviewable. For large or cross-cutting changes, prefer separate intent and implementation commits when this materially improves reviewability. If a pull request is used, keep those commits in the same pull request. Small cohesive changes may include documentation, tests, and implementation in one commit. Do not land end-state documentation as current behavior before its implementation exists; normally complete intent and implementation together, or clearly mark an independently landed document as a proposal.

No intent-documentation update is needed when the change implements an already documented end state, fixes a bug within existing documented behavior, narrows a non-contract API, refactors a single owner internally, or performs maintenance that does not change runtime behavior or architecture intent. Add focused tests only when they provide durable signal, then implement directly.

## Avoid over-constraining tests

Prefer tests that fail only when a durable contract breaks: accepted commands and options, validation and ownership rules, exit status, stable machine-readable formats, documented ordering, error kinds, schema fields, cache identity, stale rejection, or another behavior or boundary callers depend on. Internal tests may cover durable internal boundaries, but not private implementation details.

Do not add tests whose primary assertion freezes incidental or environment-sensitive details such as exact prose, logs, whitespace, wrapping, colors, large snapshots, private names or paths, source patterns, call paths, unspecified ordering, timing outside a performance contract, timestamps, random values, or third-party rendering. CLI help tests may assert documented command or option visibility without pinning wording or formatting. Skip new tests for documentation, formatting, mechanical changes, behavior already covered by focused tests, or changes whose only practical assertions would be incidental; verify them manually unless parser behavior or another documented contract changes.

## Design bar

Choose the simplest maintainable design that fully satisfies the accepted requirements. Avoid speculative complexity and knowingly temporary workarounds.

## Trust verified content

If a tool (e.g. `typos`) flags verified-correct content, preserve the content and apply the narrowest available allowlist or suppression. Do not disable or weaken unrelated checks.

## Git commits

For completed change tasks in a Git repository, commit the verified, in-scope changes unless the user has said otherwise. Do not commit unrelated existing changes, read-only work, or an incomplete or failing result.

Use the `git-commit` skill for creating commits; it defines the commit message format and the `Assisted-by:` AI attribution trailer.

## AI attribution

When you author a pull request description or an issue/review comment of substance, append a final line disclosing LLM assistance:

```text
Assisted-by: LLM opencode glm-5.3-flash
```

The token after `LLM` is the agent harness name (e.g. `opencode`) and the final token is the model identifier in use without its provider prefix (e.g. `glm-5.3-flash`, not `zai-coding-plan/glm-5.3-flash`). Write plain space-separated tokens without angle brackets; the executing agent fills in its own values, never hardcoded. Omit the line for purely mechanical one-liners such as `Closes #123`.
