# Delegated Read-Only Review

Use delegation only when higher-priority instructions permit it, the corpus is too large for a reliable single-agent first pass, and related spec and architecture documents can be partitioned into disjoint subject slices. Keep indexes and cross-cutting documents with the primary agent. Prohibit subagent edits, external evidence, authoritative decisions, and final verification.

Assign related spec and architecture documents to the same slice. Give every slice the complete closed evidence boundary and the already loaded review checklist, but do not give it expected findings or conclusions.

Require each slice to return:

- Assigned entries, fully reviewed entries and count, and every partially reviewed or skipped entry with its reason.
- Checklist categories applied.
- Structured facts for every reviewed entry: canonical concepts and aliases; external guarantees; states and transitions; roles and permissions; validations and errors; architecture components and owners; data ownership; dependencies; flows; enforcement points; cross-cutting rules; and cross-references.
- Candidate findings with exact files, headings, supporting evidence, and affected guarantees or enforcement points.
- Unresolved uncertainty and an explicit statement that no other findings were identified within the completed coverage of the slice.

The primary agent must verify every material finding against the source documents, merge every slice's positive facts into the global contract model, normalize aliases, and compare every shared concept, guarantee, state, role, owner, data item, flow, and enforcement rule across slices. The primary agent remains responsible for the complete inventory and coverage ledger, authoritative synthesis and decisions, all edits, cross-subject consistency, final verification, and the final report.
