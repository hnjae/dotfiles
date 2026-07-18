# Audit Mode

Apply this reference only when the user explicitly requests audit or strict mode. It supplements the core workflow and overrides any less strict core rule.

## Contents

1. Completion contract
2. Stable inventory and coverage identities
3. Allocation and reporting ownership
4. Interim and final track reports
5. Candidate schema and caps
6. Final report additions
7. Candidate disposition
8. Integrity validation

## Completion contract

- Require at least three investigation subagents, even when work must run in batches. If the environment cannot start or reuse three, stop before investigation without creating or replacing `report_path`, report the limitation, and request user direction.
- Mark `Review completion: Complete` only when every inventory entry maps to at least one non-excluded coverage assignment or exactly one excluded coverage entry, every non-excluded CU and assigned authoritative document is inspected, and every track has one current final report. Otherwise mark it `Partial`.
- Do not reduce scope silently to fit agent, context, or time limits. When the mapped scope is infeasible, record concrete partial or unavailable boundaries and stop expanding that branch.
- Keep candidate reports concise to preserve main-agent verification capacity.

## Stable inventory and coverage identities

Before spawning subagents:

1. Assign each state root an immutable `RNN` ID in discovery order.
2. Assign each authority candidate an immutable `AD-NNN` ID in discovery order. Record its path, normative-status evidence or verified non-authoritative status, missing-set eligibility evidence, cross-cutting provisions, track assignments, and any later path change without changing the ID.
3. Assign each in-scope first-party component or material entry point, contract, persistence boundary, concurrent path, resource lifecycle, or test boundary an immutable `IN-NNN` inventory ID.
4. Define each non-excluded coverage assignment as one tuple `(RNN, IN-NNN, track)`. Assign every tuple its own immutable `CU-NNN` ID. When the same inventory entry is relevant to two tracks, create two CU IDs.
5. Map every inventory entry to at least one non-excluded CU or exactly one CU with track `Excluded` and a concrete exclusion reason.
6. Never reuse or renumber root, authority, inventory, or coverage IDs. Assign the next unused ID to newly discovered scope.

Every non-excluded CU must end as `Inspected`, `Partially inspected: <inspected and uninspected boundaries plus reason>`, or `Unable to verify: <reason>`. `Inspected` requires examination of the named entry points and boundaries; it does not imply defect-free internals.

## Allocation and reporting ownership

- Cover all six core tracks and assign exactly one reporting owner to each.
- An owner may cover at most two tracks only when each scope is small and the pair is cohesive. Keep their reports, candidate sequences, and coverage records separate.
- Assign every non-excluded CU and relevant authoritative document before delegation. Give each owner its track, authority-map entries, CU IDs, and named entry points and boundaries. Keep excluded CUs under the main agent in the central coverage map and omit them from track checklists.
- Record an allocation rationale, later expansion, follow-up, reallocation, owner failure, and material exclusion.
- If a track crosses independently deployable components or distinct contract, trust, persistence, consistency, concurrency, or lifecycle boundaries, retain one reporting owner and use component-scoped follow-up tasks.
- Reassess feasibility after every material scope expansion. Add feasible scope to the proper owner; otherwise mark it partial or unavailable, set completion to Partial, and stop that expansion.
- If an owner fails or returns no usable update, attempt one retry. If that fails, transfer the entire track once with a recoverable handoff. If the replacement fails, mark unfinished scope unavailable and continue with a missing final report; the main agent must not fabricate the track investigation.

## Interim and final track reports

Use `T<track>-O<sequence>` only for provisional observations in interim reports. An interim report must state:

- Completed, partially inspected, unable-to-verify, and pending CU and AD IDs.
- Provisional observation labels, titles, decisive evidence, and blockers.
- Reserved canonical IDs from any superseded report.
- Next unused observation, candidate, and omission sequences.
- Requested follow-up scope.

The main agent may send `Finalize Track <number>` only after every assigned CU and AD ID has a recorded status and no follow-up or transfer remains. Only then may the reporting owner issue canonical `T<track>-F<sequence>` candidate IDs and return one current final report.

If feasible later verification reopens a finalized track:

- Mark its prior report `Superseded`.
- Keep all canonical IDs permanently reserved.
- Use provisional observation labels for the reopened investigation.
- Repeat the finalization barrier.
- Reuse an ID only when the defective condition and causal mechanism are materially unchanged and only evidence, wording, priority, or scope changed. Otherwise reserve the old ID and issue the next unused ID.

## Candidate schema and caps

Each current final track report must contain:

### Investigation coverage

- Assigned scope and follow-ups.
- Scope actually inspected, including named entry points, boundaries, tests, and documents.
- Search and tracing strategy.
- Material exclusions.

### Candidates

Normally return 2–3 highest-impact candidates and no more than five non-P0 candidates. Return every High- or Medium-confidence P0 regardless of the cap. For each candidate include:

- ID, title, finding type, authority status, priority, confidence, and assumptions. Use P0–P3 for High or Medium confidence and `Unassessed` for Low confidence.
- Impact basis covering consequence severity, affected scope, likelihood, and detectability or recoverability, separating verified facts and assumptions.
- One to four decisive evidence items.
- Observed state, design concern, and exact verification needed for Medium or Low confidence.

A supported non-P0 concern omitted only because of the cap receives no candidate ID. Its track owner assigns the logical omission an immutable non-candidate `T<track>-OM<sequence>` ID, defines it once in a cap-omission register with priority, confidence, title, decisive evidence, comparative reason, and implicated CU IDs or documents, and references that ID from every directly relevant checklist entry. Maintain an independent omission sequence for each track.

### Coverage checklist

Give every assigned CU and authoritative document these independent fields:

- `Inspection`: `Inspected`, `Partially inspected: <boundaries and reason>`, or `Unable to verify: <reason>`.
- `Candidates`: zero or more canonical candidate IDs.
- `Cap omissions`: zero or more `T<track>-OM<sequence>` IDs resolved through the cap-omission register.
- `Assessment`: `Assessed within inspected scope` or `Not assessed — inspection unavailable`.

`Unable to verify` requires `Not assessed — inspection unavailable`; other inspection states require `Assessed within inspected scope`. A checklist entry may contain both candidate IDs and cap omissions. Never record a High- or Medium-confidence P0 as a cap omission.

When a follow-up promotes a cap omission, remove its omission ID from every checklist row, retain it in the register as resolved, and record one mapping `T<track>-OM<sequence> — promoted as <candidate ID>` in the allocation audit history.

## Final report additions

Add these audit details to the core report.

### Repository state snapshots

For every state root record root ID, path, branch, start and final HEAD, start and final porcelain state, included local changes, decisive-evidence and dirty-content fingerprints, and drift handling. For a non-Git root, use `Not available` for version-control fields and record a scoped file manifest plus content fingerprints. Exclude only the absolute `report_path` from all snapshots.

### Coverage and allocation

Include:

- An authority-map summary with AD IDs, current paths, status evidence, verified absence, missing-set eligibility, path changes, and material provisions.
- An inventory map with IN IDs and the CU or single excluded-CU mapping for every entry.
- An allocation table with stable owner labels, tracks, initial CU IDs and documents, rationale, follow-ups, transfers, and failures.
- One implementation coverage row per CU ID with root, inventory ID, component or boundary, paths or entry points, track, focus, final inspection status, and exclusion or limitation.
- A track aggregation with owner, assigned CU IDs and documents, final status, search strategy, exclusions, cap omissions, and unavailable boundaries.
- The cap-omission register and promotion mappings, material allocation changes, inventory uncertainty, unavailable runtime or organizational evidence, and repository drift.

### Source candidates

Add `Source candidates` to every final finding. Main-agent discoveries receive `M-F<sequence>` IDs and the same candidate schema. A main-agent candidate may arise only during independent verification or boundary tracing.

### Candidate disposition appendix

Add one row for every canonical candidate from a current or superseded final track report and every main-agent candidate. Do not include provisional observation IDs.

Use these dispositions:

- `Accepted`: independently verified and the sole source of one final finding.
- `Merged`: independently verified and combined with at least one other candidate into one final finding.
- `Rejected`: independently examined and unsupported, incorrect, incidental, or duplicative without distinct evidence.
- `Uncertain`: materially important but requiring additional evidence or an unresolved authoritative product or architecture decision and appearing exactly once in open questions.
- `Not promoted`: independently verified but omitted because of lower comparative impact or the main-body limit.
- `Triaged out — not independently verified`: excluded before verification because its stated comparative impact was below the verification threshold.

An accepted candidate must be the only source of its final finding. When a final finding has two or more source candidates, every source candidate must be `Merged`. All other dispositions have no final finding ID.

## Integrity validation

After writing `report_path`, run all checks below, correct repository-verifiable failures, and rerun the complete list. If a check cannot be completed, mark integrity `Not fully validated`, record the exact gap, and do not claim it passed.

1. Every canonical candidate ID is unique as a logical identity and appears in exactly one disposition row. Provisional observation IDs never appear in the appendix.
2. Every `DR-NNN` is unique and sequential in full-definition order. Summary, risk-list, cross-reference, and appendix references resolve.
3. Every final finding's source candidates exist and source exactly one finding. Accepted and Merged dispositions obey the source cardinality rules.
4. Every Uncertain candidate appears exactly once in open questions; no other disposition appears there. Low-confidence and Unassessed items appear in neither main findings nor Top Design Risks.
5. Executive Summary priority counts equal the six main sections. Top Design Risks contains no more than five existing findings with matching IDs, priorities, titles, and supported impact summaries.
6. Every RNN reference resolves to one state-root snapshot and every AD reference resolves to one authority-map identity whose path history is recorded. Reverify every final or uncertain evidence item against the final snapshot and fingerprints.
7. Every IN ID maps to at least one non-excluded CU or exactly one excluded CU. Every CU ID appears in exactly one coverage-map row and represents one root-inventory-track tuple or one excluded entry. Excluded CUs remain central and appear in no track checklist; every current track checklist accounts for every assigned non-excluded CU and document with all four independent fields.
8. Every track-qualified omission ID is unique and resolves to one register entry; every checklist reference resolves; every promotion has one candidate mapping and leaves no current checklist reference; unresolved omissions remain visible as current limitations.
9. Coverage-map, track-report, and aggregation statuses agree. Any unmapped inventory entry, partial or unavailable non-excluded scope, or missing current track report requires `Review completion: Partial`.
10. Preserve every material exclusion, allocation change, owner failure, unresolved cap omission, partial inspection, and unavailable boundary under Coverage and Limitations. Do not present resolved cap omissions as current limitations.
11. Capture repository state once more after validation. If relevant state or fingerprints changed, update the snapshot, reverify affected evidence, and rerun validation once. If drift persists, move affected claims to open questions, mark completion Partial and integrity Not fully validated, then repair structural references without starting an unbounded snapshot loop.

Do not commit `report_path`.
