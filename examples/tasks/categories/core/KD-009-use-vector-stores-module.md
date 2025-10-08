Title: KD-009 Replace KD-internal vector store usage with vector_stores module

Type: Refactor

Rationale
- KD defines/assumes its own VectorStore interface. The repository already has a full `vector_stores/` module with providers and interfaces. KD should depend on it instead of duplicating.

Goals / Scope
- Update `KnowledgeDeltaFactory` to create vector stores via `vector_stores.factory.VectorStoresFactory`.
- Change KD to type against `vector_stores.interface.VectorStoreInterface`.
- Ensure `find_similar_deltas` and `store_delta` use the unified interface (`insert`, `search`, `update`, `delete`).

Acceptance Criteria
1) KD compiles with `vector_stores` interfaces and passes existing KD search tests.
2) Vector store provider is configurable via env or config and can be mocked via the module’s own mock provider in tests.

Proposed Changes
- Factory wiring; minor method signature adjustments; remove KD-local stubs.

Test Plan (TDD)
- Configure a Mock vector store; run KD search tests end-to-end.


