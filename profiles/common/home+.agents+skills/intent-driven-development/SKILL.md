---
name: intent-driven-development
description: Keep `docs/spec/` and `docs/architecture/` as the source of intent while making an implementation change (also called spec-driven development). Use for any implementation change (feature, bug fix, refactor, maintenance) in a repository that has either directory — read the intent docs first, update them when the contract changes, write a failing contract test, then implement. Not for creating `docs/spec/` or `docs/architecture/` in a repository that lacks them (only when the user asks), and not for a comprehensive review of both trees (use docs-review).
---

# Intent-Driven Development

Intent docs carry intent across sessions: future agent sessions and the user read them instead of reconstructing intent from code. A repository opts in by having `docs/spec/` or `docs/architecture/`. Never create either unless asked.

## What each tree holds

- `docs/spec/`: user-facing specs, one file per subject. Its `README.md` indexes them and does not aggregate them. Specs describe external behavior only.
- `docs/architecture/`: durable invariants — ownership, dependency direction, lifecycle safety, failure semantics, observable behavior. Leave mechanisms (class or module decomposition, internal data flow, value representation, event wiring, dependency-injection style, test-harness structure) to implementation unless the mechanism is itself a cross-component constraint.
- Both describe the intended end state, never current implementation, progress, milestones, migration phases, or partial plans.
- Write concise technical prose. No hard wraps in `docs/` files: one paragraph or list item per source line. Use Mermaid for diagrams.

Placing a fact: if it is user-facing, it is spec. If it constrains how components relate regardless of implementation, it is architecture. If neither, it belongs in code, not in docs.

## Workflow

Apply the steps that fit, in order.

1. **Read first.** Read the relevant `docs/spec/` and `docs/architecture/` files. They define intended behavior: when code and docs disagree, the docs win unless the request changes them. If the disagreement is outside the request's scope, report it instead of resolving it.
2. **Update the docs.** If the user-visible contract changes, update `docs/spec/`. If ownership, boundary, identity, or lifecycle intent changes, update `docs/architecture/`. Skip this step when implementing an already documented end state, fixing a bug within documented behavior, narrowing a non-contract API, refactoring within a single owner, or doing maintenance that changes neither runtime behavior nor architecture intent.
3. **Test first.** If the change needs regression coverage, write a focused contract test before the implementation, and when practical confirm it fails for the expected reason. Assert durable contracts only, never incidental details such as prose, logs, whitespace, or private names. Skip the new test when existing tests already exercise the changed behavior and would catch its regression, or when the only practical assertions would be incidental.
4. **Implement and re-review.** Implement, confirm the focused and relevant tests pass, then re-read the intent docs against the result. Fix drift this change introduced; report the rest.

Land the docs, tests, and implementation of one change together, so the default branch never documents behavior that does not exist.
