# Review Checklist

Read this checklist completely after inventorying both document sets. Apply every category before editing and repeat the relevant checks after editing.

## 1. Check internal consistency and completeness

Look for:

- Conflicting definitions of the same concept or term.
- Inconsistent states, transitions, permissions, roles, validation, limits, or errors.
- Requirements where satisfying one violates another.
- Ambiguous wording with multiple materially different interpretations.
- Missing edge cases or acceptance criteria that the surrounding contract already implies.
- Requirements without a clear final expected behavior.
- Current-state, temporary, migration-only, TODO, milestone, or progress-tracking language.

## 2. Check duplication, redundancy, and divergence

Look for:

- The same requirement, behavior, invariant, or flow repeated within or across document sets.
- Near-duplicate sections with different wording or drifted details.
- Architecture restating product requirements without defining structural enforcement.
- Spec restating implementation strategy instead of observable guarantees.
- Repeated examples or notes that obscure the canonical source.
- Long restatements that can become a link or a short contextual reference.

Keep one canonical statement in the correct document. Merge unique useful details, remove stale restatements, and normalize terminology. When both sets need related content, separate the external guarantee from the structural enforcement contract.

## 3. Check the spec–architecture boundary

Move or rewrite:

- Classes, modules, database tables, libraries, algorithms, internal workflows, storage mechanics, infrastructure choices, and deployment mechanics found in spec unless they are themselves an externally promised constraint.
- API contracts, user-visible behavior, permissions, states, errors, limits, validation, and guarantees found only in architecture.
- Externally observable requirements that must be promoted from architecture to spec.
- Structural guidance, ownership, dependencies, persistence, transactions, consistency, and failure handling that must move from spec to architecture.
- Current-state or migration content that must be removed, or may become final behavior or a final design rule only when other allowed text uniquely supports that outcome.

## 4. Check architecture coverage and implementability

Look for:

- Spec guarantees that depend on a durable ownership, cross-component, persistence, security, concurrency, recovery, or operational boundary but have no architectural enforcement point or cross-cutting strategy established by the allowed documents.
- Architecture that contradicts spec or silently assumes additional product behavior.
- Incomplete end-to-end flows and unclear component responsibilities.
- Unowned data, state transitions, validation, permissions, or invariants.
- Persistence, transaction, consistency, concurrency, idempotency, or ordering gaps.
- Failure-handling, recovery, security, authorization, observability, or operational gaps; report the gap instead of inventing a mechanism when no unique rule follows from the documents.
- Unclear dependency direction or responsibility separation.
- Architecture rules too vague to guide implementation without inspecting source code.

Treat the need for durable enforcement and the choice of enforcement design as separate conclusions. A spec guarantee can prove that architecture is missing without establishing a new owner, boundary, component, persistence model, or mechanism. Report that gap unless the allowed documents uniquely establish the design.

## 5. Check traceability

For each material requirement, state, permission, validation, error, edge case, and acceptance criterion in spec, determine whether enforcement depends on a durable architectural boundary. A spec item may require no special architectural statement when ordinary local implementation can enforce it without durable ownership, cross-component flow, persistence, security, concurrency, recovery, or operational implications. Record that classification in the working model rather than creating architecture solely for one-to-one traceability.

When architectural coverage is required, one general enforcement rule may cover multiple spec clauses. Prefer that shared rule over restating each external requirement.

For each architecture section, find either:

- A material spec guarantee it enforces.
- A legitimate cross-cutting concern such as security, persistence, consistency, reliability, observability, recovery, or operations.

Remove, rewrite, or question architecture that maps to neither. Retain a cross-cutting concern only when the allowed documents establish it or it is logically entailed by an established guarantee. Prefer subject names, stable links, and shared terminology over introducing a heavy traceability-ID system unless the existing documents already require one.

## 6. Check architecture detail level

Look for:

- Nonessential class, function, helper, file, or directory names.
- Pseudocode and algorithmic steps that unnecessarily constrain implementation.
- Unjustified framework, vendor, caching, indexing, batching, polling, retry-timing, or worker choices.
- Repeated low-level instructions and code walkthroughs.
- Descriptions of current call paths instead of durable responsibilities and invariants.

Prefer contract-oriented statements. For example:

- Prefer “The domain boundary must validate every state transition before persistence” over a description of a current helper call.
- Prefer “Persistence adapters own storage-specific mapping and must not expose storage schema details across the domain boundary” over a file-and-function walkthrough.
- Retain a concrete mechanism only when interoperability, security, consistency, operations, or another durable architectural constraint depends on it.
