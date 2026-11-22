---
name: intent-driven-development
description: Keep `docs/spec/` and `docs/architecture/` as the source of intent while making an implementation change (also called spec-driven development). Use for any implementation change (feature, bug fix, refactor, maintenance) in a repository that has either directory — read the intent docs first, update them when the contract changes, write a failing contract test when the change needs regression coverage, then implement. Not for creating `docs/spec/` or `docs/architecture/` in a repository that lacks them (only when the user asks), and not for a comprehensive review of both trees (that is intent-docs-review, which runs only when the user invokes it; suggest it instead of starting it).
---

# Intent-Driven Development

Intent docs carry intent across sessions: future agent sessions and the user read them instead of reconstructing intent from code. A repository opts in by having `docs/spec/` or `docs/architecture/`. Never create either unless asked: creating one opts the repository into this workflow for every later change, and that choice belongs to its owner.

## What each tree holds

- `docs/spec/`: user-facing specs, one file per subject. Its `README.md` indexes them and does not aggregate them. Specs describe external behavior only.
- `docs/architecture/`: durable invariants — ownership, dependency direction, lifecycle safety, failure semantics, observable behavior. Leave mechanisms (class or module decomposition, internal data flow, value representation, event wiring, dependency-injection style, test-harness structure) to implementation unless the mechanism is itself a cross-component constraint. Intent docs constrain only what callers or other components durably depend on; everything else stays free to change.
- Both describe the intended end state, never current implementation, progress, milestones, migration phases, or partial plans, because readers treat these docs as the definition of intended behavior and would read progress or plans as intent.
- Write concise technical prose. No hard wraps in `docs/` files: one paragraph or list item per source line. Use Mermaid for diagrams.

Placing a fact: what the product must guarantee externally (user and API behavior, states, errors, limits) is spec. The durable structural contract that enforces a guarantee (ownership, dependency direction, ordering, failure handling) is architecture. When a fact is both, spec states the guarantee and architecture states what enforces it. If neither, it belongs in code, not in docs.

## Workflow

Apply the steps in order. Steps 1 and 4 always apply; steps 2 and 3 apply only as their conditions say.

1. **Read first.** Read the relevant `docs/spec/` and `docs/architecture/` files. They define intended behavior: when code and docs disagree, the docs win unless the request changes them. If the disagreement is outside the request's scope, report it instead of resolving it.
2. **Update the docs.** If the user-visible contract changes, update `docs/spec/`. If ownership, boundary, identity, or lifecycle intent changes, update `docs/architecture/`. Skip this step when implementing an already documented end state, fixing a bug within documented behavior, narrowing a non-contract API, refactoring within a single owner, or doing maintenance that changes neither runtime behavior nor architecture intent. If the change belongs in a tree the repository lacks, report that instead of creating the tree.
3. **Test first.** If the change needs regression coverage, write a focused contract test before the implementation, and when practical confirm it fails for the expected reason. Assert durable contracts only, never incidental details such as prose, logs, whitespace, or private names. Skip the new test when existing tests already exercise the changed behavior and would catch its regression, or when the only practical assertions would be incidental.
4. **Implement and re-review.** Implement, confirm the focused and relevant tests pass, then re-read the intent docs against the result. Fix drift this change introduced; report the rest.

Land the docs, tests, and implementation of one change together, so the default branch never documents behavior that does not exist.
