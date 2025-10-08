# TDD: KD Graph Operations Test Suite

## 🎯 Overview

Implement comprehensive test suite for Knowledge Delta Graph operations including node management, edge creation, graph traversal, path finding, and analysis functionality to ensure robust graph-based knowledge representation.

## 📋 Test Requirements

### Node Management Tests
- [ ] **Node Creation**
  - Valid node creation with required fields
  - Node ID uniqueness enforcement
  - Node data validation and schema compliance
  - Duplicate node handling
  - Bulk node creation operations

- [ ] **Node Retrieval**
  - Single node retrieval by ID
  - Node existence validation
  - Non-existent node error handling
  - Node data integrity verification
  - Query parameter validation

- [ ] **Node Updates**
  - Partial node data updates
  - Full node data replacement
  - Update validation and constraints
  - Concurrent update handling
  - Update history tracking

- [ ] **Node Deletion**
  - Single node deletion
  - Cascade deletion with connected edges
  - Deletion validation and constraints
  - Orphaned edge cleanup
  - Soft delete vs hard delete

### Edge Management Tests
- [ ] **Edge Creation**
  - Valid edge creation between existing nodes
  - Edge relationship type validation
  - Bidirectional vs unidirectional edges
  - Edge weight and metadata handling
  - Duplicate edge prevention

- [ ] **Edge Retrieval**
  - Edges by source node
  - Edges by target node
  - Edges by relationship type
  - Edge filtering and pagination
  - Edge data integrity

- [ ] **Edge Updates**
  - Edge weight modifications
  - Relationship type changes
  - Edge metadata updates
  - Edge direction changes
  - Update validation

- [ ] **Edge Deletion**
  - Single edge removal
  - Bulk edge deletion
  - Node isolation scenarios
  - Deletion constraints
  - Referential integrity

### Graph Traversal Tests
- [ ] **Neighbor Discovery**
  - Direct neighbors (1-hop)
  - Multi-hop neighbor discovery
  - Filtered neighbor queries
  - Directional traversal (incoming/outgoing)
  - Neighbor ranking and scoring

- [ ] **Path Finding**
  - Shortest path algorithms (Dijkstra, A*)
  - All paths between nodes
  - Path length constraints
  - Weighted path calculations
  - Path optimization criteria

- [ ] **Graph Walking**
  - Depth-first search (DFS)
  - Breadth-first search (BFS)
  - Random walk algorithms
  - Cycle detection
  - Graph connectivity analysis

### Graph Analysis Tests
- [ ] **Centrality Measures**
  - Degree centrality calculation
  - Betweenness centrality
  - Closeness centrality
  - PageRank calculation
  - Eigenvector centrality

- [ ] **Community Detection**
  - Cluster identification
  - Community modularity
  - Hierarchical clustering
  - Graph partitioning
  - Community stability

- [ ] **Graph Metrics**
  - Graph density calculation
  - Average path length
  - Clustering coefficient
  - Graph diameter
  - Connected components

### Neo4j Integration Tests
- [ ] **Database Connection**
  - Connection establishment and pooling
  - Authentication and authorization
  - Connection timeout handling
  - Connection recovery
  - Multi-database support

- [ ] **Cypher Query Execution**
  - Parameterized query execution
  - Query result processing
  - Transaction management
  - Query optimization
  - Query error handling

- [ ] **Data Persistence**
  - Node persistence to Neo4j
  - Edge persistence and indexing
  - Data consistency verification
  - Transaction rollback scenarios
  - Bulk data operations

### Performance Tests
- [ ] **Scalability Testing**
  - Large graph operations (10K+ nodes)
  - High-degree node handling
  - Complex query performance
  - Memory usage optimization
  - Response time benchmarks

- [ ] **Concurrent Operations**
  - Simultaneous read/write operations
  - Lock contention scenarios
  - Transaction isolation
  - Deadlock prevention
  - Resource sharing

### Error Handling Tests
- [ ] **Graph Constraints**
  - Invalid node/edge creation
  - Constraint violation handling
  - Schema validation errors
  - Data type mismatches
  - Size limit enforcement

- [ ] **Database Errors**
  - Connection failure recovery
  - Query execution errors
  - Transaction timeout handling
  - Disk space limitations
  - Memory exhaustion scenarios

## 🏗️ Implementation Structure

```
tests/graph/kd_graph/
├── test_node_management.py       # Node CRUD operations
├── test_edge_management.py       # Edge CRUD operations
├── test_graph_traversal.py       # Path finding and walking
├── test_graph_analysis.py        # Centrality and metrics
├── test_neo4j_integration.py     # Database integration
├── test_performance.py           # Scalability and performance
├── test_error_handling.py        # Error scenarios and recovery
├── test_concurrent_operations.py # Concurrency and locking
├── conftest.py                   # Shared fixtures and utilities
└── utils/
    ├── graph_generators.py       # Test graph generation
    ├── neo4j_helpers.py          # Database test utilities
    └── performance_utils.py      # Performance testing tools
```

## 🧪 Test Data & Scenarios

### Test Graph Structures
```python
# Simple graph for basic tests
simple_graph = {
    "nodes": [
        {"id": "A", "type": "concept", "title": "Machine Learning"},
        {"id": "B", "type": "concept", "title": "Neural Networks"},
        {"id": "C", "type": "concept", "title": "Deep Learning"}
    ],
    "edges": [
        {"from": "A", "to": "B", "relationship": "includes"},
        {"from": "B", "to": "C", "relationship": "enables"}
    ]
}

# Complex graph for advanced tests
complex_graph = generate_random_graph(
    nodes=1000,
    edges=5000,
    node_types=["concept", "skill", "project"],
    relationships=["depends_on", "related_to", "implements"]
)
```

### Performance Test Scenarios
```python
performance_scenarios = [
    {
        "name": "small_graph",
        "nodes": 100,
        "edges": 300,
        "max_query_time": 50  # ms
    },
    {
        "name": "medium_graph", 
        "nodes": 1000,
        "edges": 3000,
        "max_query_time": 200  # ms
    },
    {
        "name": "large_graph",
        "nodes": 10000,
        "edges": 30000,
        "max_query_time": 1000  # ms
    }
]
```

### Graph Analysis Test Cases
```python
centrality_test_cases = [
    {
        "graph": star_graph(5),  # Central hub with 4 spokes
        "expected_center": "hub_node",
        "measure": "degree_centrality"
    },
    {
        "graph": path_graph(10),  # Linear chain
        "expected_center": "node_5",  # Middle node
        "measure": "betweenness_centrality"
    }
]
```

## ✅ Acceptance Criteria

- [ ] All graph operations tested with comprehensive scenarios
- [ ] Neo4j integration verified with real database
- [ ] Performance benchmarks established for different graph sizes
- [ ] Error handling covers all database and constraint scenarios
- [ ] Concurrent operations tested for race conditions
- [ ] Graph algorithms validated for correctness
- [ ] Test coverage > 90% for graph components

## 🧪 Specific Test Scenarios

### Node Creation Test
```python
@pytest.mark.asyncio
async def test_node_creation_success():
    graph = KDGraph(neo4j_config)
    
    node_data = {
        "id": "test_node_001",
        "type": "concept",
        "title": "Test Concept",
        "metadata": {"category": "testing"}
    }
    
    result = await graph.create_node(node_data)
    
    assert result.success == True
    assert result.node_id == "test_node_001"
    
    # Verify persistence
    retrieved = await graph.get_node("test_node_001")
    assert retrieved.title == "Test Concept"
```

### Path Finding Test
```python
@pytest.mark.asyncio
async def test_shortest_path_algorithm():
    graph = await create_test_graph()
    
    path = await graph.find_shortest_path(
        source="node_A",
        target="node_Z",
        max_hops=5
    )
    
    assert len(path) <= 5
    assert path[0] == "node_A"
    assert path[-1] == "node_Z"
    assert all(await graph.edge_exists(path[i], path[i+1]) 
               for i in range(len(path)-1))
```

### Performance Test
```python
@pytest.mark.performance
async def test_large_graph_query_performance():
    graph = await create_large_test_graph(nodes=10000)
    
    start_time = time.time()
    neighbors = await graph.get_neighbors("central_node", max_distance=2)
    query_time = (time.time() - start_time) * 1000  # ms
    
    assert query_time < 1000  # Must complete within 1 second
    assert len(neighbors) > 0
```

### Concurrency Test
```python
@pytest.mark.asyncio
async def test_concurrent_node_creation():
    graph = KDGraph(neo4j_config)
    
    # Create 100 nodes concurrently
    tasks = [
        graph.create_node({"id": f"node_{i}", "type": "test"})
        for i in range(100)
    ]
    
    results = await asyncio.gather(*tasks, return_exceptions=True)
    
    # All should succeed without conflicts
    successes = [r for r in results if not isinstance(r, Exception)]
    assert len(successes) == 100
```

### Graph Analysis Test
```python
def test_centrality_calculation():
    graph = create_star_graph(center="hub", spokes=["A", "B", "C", "D"])
    
    centrality = graph.calculate_degree_centrality()
    
    assert centrality["hub"] > centrality["A"]  # Hub has highest centrality
    assert centrality["A"] == centrality["B"]   # Spokes have equal centrality
```

## 🔗 Related Issues

- Graph implementation: src/mnemoverse_arch/memory/knowledge_delta/graph/
- Neo4j adapter: Database integration components
- API endpoints: Graph endpoint testing

## 📚 References

- Neo4j graph database documentation
- Graph algorithms: NetworkX and igraph
- Cypher query language specification
- Graph theory and analysis methods

**Priority:** High  
**Estimate:** 10-15 story points  
**Category:** Graph Database Testing
