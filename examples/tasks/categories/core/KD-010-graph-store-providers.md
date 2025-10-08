Title: KD-010 Graph Store Providers — Catalog and Implementation Plan

Type: Planning + Architecture
EPIC: KD-EPIC-unify-providers

Goal
- Define a single task that tracks supported GraphStore providers, selection criteria, and implementation order under the unified `graph_stores/` module.

Scope
- One issue that contains the provider catalog, pros/cons, priority, config shape, and acceptance criteria. Concrete adapter implementations will be sub-items/PRs linked here.

Unified Interface
- Providers MUST implement `graph_stores.interface.GraphStore` compatible with KD expectations:
  - add_node/get_node/update_node/delete_node/node_exists
  - add_edge/get_edge/delete_edge (edge_type must be stored as canonical field)
  - get_neighbors(node_id, edge_type: Optional[str], direction: str = "in|out|both")
  - find_path(start_id, end_id, max_depth, edge_types: Optional[List[str]])
  - get_nodes_by_property(property_name, value, limit)
  - count_nodes/count_edges/get_stats/clear/create_indexes

Providers Catalog (shortlist)
- NetworkX (in-memory) — Dev/Test baseline [PRIORITY: P0]
  - Pros: zero deps, deterministic, fast CI
  - Cons: non-persistent, not for prod

- Neo4j (Bolt) — Self-managed/Cloud Aura [PRIORITY: P1]
  - Pros: mature ecosystem, Cypher, indexes, good tooling
  - Cons: ops overhead self-managed; Aura paid tiers

- Memgraph (Bolt) — Neo4j-compatible semantics [PRIORITY: P1]
  - Pros: fast, open-source, good for prototyping, near-Cypher compatible
  - Cons: smaller ecosystem vs Neo4j

- AWS Neptune (Gremlin/OpenCypher/SPARQL) — Managed [PRIORITY: P1]
  - Pros: managed, scales, Gremlin path queries
  - Cons: API differences; OpenCypher availability varies; vendor lock-in

- Azure Cosmos DB (Gremlin) — Managed [PRIORITY: P2]
  - Pros: managed, Azure-native
  - Cons: Gremlin subset; perf tuning required

- JanusGraph (Gremlin Server) — Self-managed [PRIORITY: P2]
  - Pros: scalable with backend stores; Gremlin
  - Cons: ops complexity

- ArangoDB (HTTP) — Multi-model [PRIORITY: P3]
  - Pros: document+graph; Foxx services
  - Cons: AQL differences; custom adapter work

Out of Scope (for now)
- TigerGraph, Dgraph, OrientDB — revisit post-MVP

Configuration (env-driven examples)
- Common
  - GRAPH_STORE_PROVIDER: networkx | neo4j | memgraph | neptune | cosmos_gremlin | janusgraph | arangodb

- Neo4j/Memgraph
  - NEO4J_URI=bolt://host:7687
  - NEO4J_USER=neo4j
  - NEO4J_PASSWORD=***
  - NEO4J_DATABASE=neo4j

- Neptune (Gremlin)
  - NEPTUNE_ENDPOINT=wss://cluster-xyz.neptune.amazonaws.com:8182/gremlin
  - NEPTUNE_REGION=us-east-1
  - NEPTUNE_IAM=true|false

- Cosmos DB (Gremlin)
  - COSMOS_GREMLIN_ENDPOINT=wss://account.gremlin.cosmos.azure.com:443/
  - COSMOS_DB=graphdb
  - COSMOS_KEY=***

Acceptance Criteria
- A `graph_stores/` module exists with baseline `NetworkXAdapter` (P0) and at least one managed provider (Neo4j or Neptune) wired end-to-end with KD.
- Adapters store and return `edge_type` consistently.
- KD tests pass with NetworkX; smoke tests pass with the managed provider configured via env.

Implementation Order (proposed)
- P0: NetworkXAdapter (already available; move under `graph_stores/`)
- P1: Neo4jAdapter (Bolt) and Memgraph (alias/wrapper)
- P1: NeptuneGremlinAdapter
- P2: CosmosGremlinAdapter
- P2: JanusGraphGremlinAdapter
- P3: ArangoDBAdapter

Test Plan (TDD)
- Shared contract tests: run across adapters (pytest parametrize provider) for:
  - node CRUD, edge CRUD, neighbors (in/out/both), find_path (with edge_types), get_nodes_by_property
  - edge_type normalization checks
  - basic stats
- KD integration tests with provider matrix: NetworkX (mandatory), one managed (nightly)

Example Usage (pseudo)
```python
from mnemoverse_arch.graph_stores.networkx_adapter import NetworkXAdapter

graph = NetworkXAdapter()
await graph.initialize()
await graph.add_node("a", {"type": "delta"})
await graph.add_node("b", {"type": "delta"})
await graph.add_edge("a", "b", edge_type="transforms_to", data={"weight": 0.8})
path = await graph.find_path("a", "b", max_depth=3, edge_types=["transforms_to"])
```

Tracking
- Link PRs:
  - PR-1: Create `graph_stores/` skeleton + move NetworkXAdapter
  - PR-2: Neo4jAdapter wiring under `graph_stores/`
  - PR-3: NeptuneGremlinAdapter
  - PR-4: CosmosGremlinAdapter


