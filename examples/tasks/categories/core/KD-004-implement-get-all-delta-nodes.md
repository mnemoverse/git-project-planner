Title: KD-004 Implement PatternDetector._get_all_delta_nodes via GraphStore

Type: Bugfix

Rationale
- Pattern detection currently returns no results because `_get_all_delta_nodes()` is stubbed to return an empty list. This blocks breakthroughs/clusters/evolution pattern detection.

Goals / Scope
- Implement `_get_all_delta_nodes()` to use `graph.get_nodes_by_property('type', 'delta', limit=...)` with a sane limit (e.g., 10k for MVP).

Acceptance Criteria
1) PatternDetector methods operate on real delta nodes and produce results on small fixtures.
2) Unit test ensures `_get_all_delta_nodes()` returns >=1 node after storing deltas.

Proposed Changes
- Replace the stub with a GraphStore call and return the results directly.

Risks / Mitigations
- Large graphs: add a default limit and document it; future work to add pagination/streaming.


