# TDD: KD API Endpoints Test Suite

## 🎯 Overview

Implement comprehensive test suite for Knowledge Delta REST API endpoints to ensure all CRUD operations, graph functionality, and memory management work correctly with proper error handling and security integration.

## 📋 Test Requirements

### Core API Endpoints
- [ ] **Health & Status**
  - `GET /health` - System health check
  - `GET /stats` - Memory and graph statistics
  - Response time and format validation
  - Service dependency checks

- [ ] **Memory Operations**
  - `POST /memory` - Add new memory entries
  - `POST /search` - Search existing memories
  - `GET /insights` - Detect knowledge insights (alias)
  - Request/response schema validation
  - Pagination and filtering

- [ ] **Graph Operations**
  - `POST /graph/nodes` - Create knowledge nodes
  - `GET /graph/nodes/{node_id}` - Retrieve nodes
  - `POST /graph/edges` - Create relationships
  - `GET /graph/neighbors/{node_id}` - Get connected nodes
  - `GET /graph/path` - Find paths between nodes
  - `GET /evolution` - Trace knowledge evolution (alias)

### Request/Response Validation
- [ ] **Schema Compliance**
  - Pydantic model validation for all endpoints
  - Required field enforcement (agent_id, content)
  - Optional field handling (user_id, metadata)
  - Data type validation and coercion

- [ ] **Content Validation**
  - Field length limits (content: 10KB, context: 5KB)
  - JSON size limits for metadata
  - Special character handling
  - Unicode and encoding validation

- [ ] **Response Format**
  - Consistent JSON structure across endpoints
  - Error response format standardization
  - HTTP status code compliance
  - Header consistency (Content-Type, X-Request-ID)

### Error Handling Tests
- [ ] **Client Errors (4xx)**
  - 400 Bad Request - Invalid schema, missing fields
  - 401 Unauthorized - Missing/invalid authentication
  - 403 Forbidden - ACL violations
  - 404 Not Found - Non-existent resources
  - 409 Conflict - Duplicate resource creation
  - 422 Unprocessable Entity - Validation errors
  - 429 Too Many Requests - Rate limiting

- [ ] **Server Errors (5xx)**
  - 500 Internal Server Error - Unexpected exceptions
  - 502 Bad Gateway - Downstream service failures
  - 503 Service Unavailable - Overload scenarios
  - 504 Gateway Timeout - Long-running operations

- [ ] **Error Message Quality**
  - Descriptive error messages with field names
  - Error codes for programmatic handling
  - No sensitive information leakage
  - Consistent error response structure

### Authentication & Authorization
- [ ] **Agent ID Requirements**
  - All endpoints require valid agent_id
  - Agent ID format validation
  - Missing agent_id error handling
  - Invalid agent_id rejection

- [ ] **Bearer Token Authentication**
  - Authorization header processing
  - Token format validation
  - Invalid token rejection
  - Token expiration handling

- [ ] **Multi-tenant Isolation**
  - Agent data isolation verification
  - Cross-agent access prevention
  - Resource ownership validation
  - Audit trail for access attempts

### Performance Tests
- [ ] **Response Time Limits**
  - Health endpoint < 50ms
  - Memory operations < 500ms
  - Graph operations < 1000ms
  - Search operations < 2000ms

- [ ] **Throughput Testing**
  - Concurrent request handling
  - Rate limiting accuracy
  - Memory usage under load
  - Connection pool management

- [ ] **Bulk Operations**
  - Large payload handling
  - Batch memory creation
  - Bulk graph operations
  - Pagination efficiency

### Integration Tests
- [ ] **Database Integration**
  - Neo4j graph operations
  - Vector database queries
  - Transaction handling
  - Connection pooling

- [ ] **Security Middleware Integration**
  - Rate limiting enforcement
  - ACL policy application
  - Security logging verification
  - Request/response modification

- [ ] **Observability Integration**
  - Request logging with correlation IDs
  - Metrics collection for all endpoints
  - Error categorization and tracking
  - Performance monitoring

## 🏗️ Implementation Structure

```
tests/api/kd_api/
├── test_health_endpoints.py      # Health and status endpoints
├── test_memory_endpoints.py      # Memory CRUD operations
├── test_graph_endpoints.py       # Graph operations and traversal
├── test_search_endpoints.py      # Search and insights endpoints
├── test_request_validation.py    # Schema and input validation
├── test_error_handling.py        # Error scenarios and responses
├── test_authentication.py        # Auth and authorization
├── test_performance.py           # Load and performance testing
├── test_integration.py           # Cross-component integration
├── conftest.py                   # Shared fixtures and utilities
└── utils/
    ├── api_helpers.py            # HTTP client utilities
    ├── test_data.py              # Test data generators
    └── assertions.py             # Custom assertion helpers
```

## 🧪 Test Data & Scenarios

### Memory Test Data
```python
valid_memory = {
    "agent_id": "test-agent-001",
    "content": "User completed Python tutorial",
    "context": "Learning session on web development",
    "user_id": "user123",
    "metadata": {"difficulty": "beginner", "duration": 3600}
}

invalid_memory = {
    "agent_id": "",  # Invalid: empty agent ID
    "content": "x" * 20000,  # Invalid: exceeds length limit
    "metadata": {"key": "x" * 10000}  # Invalid: metadata too large
}
```

### Graph Test Data
```python
test_node = {
    "agent_id": "test-agent-001",
    "node_id": "concept_python_basics",
    "data": {
        "type": "concept",
        "title": "Python Basics",
        "category": "programming"
    }
}

test_edge = {
    "agent_id": "test-agent-001",
    "from_node": "concept_python_basics",
    "to_node": "concept_web_development",
    "relationship": "prerequisite_for"
}
```

## ✅ Acceptance Criteria

- [ ] All API endpoints tested with comprehensive scenarios
- [ ] Error handling covers all 4xx and 5xx status codes
- [ ] Security integration verified with actual middleware
- [ ] Performance requirements met under load testing
- [ ] Integration tests with real database connections
- [ ] Documentation examples validated through tests
- [ ] Test coverage > 90% for API layer

## 🧪 Specific Test Scenarios

### Happy Path Tests
```python
# Memory creation and retrieval
response = client.post("/memory", json=valid_memory)
assert response.status_code == 201
memory_id = response.json()["id"]

response = client.get(f"/memory/{memory_id}?agent_id=test-agent-001")
assert response.status_code == 200
```

### Error Scenario Tests
```python
# Missing agent_id
response = client.post("/memory", json={"content": "test"})
assert response.status_code == 400
assert "agent_id" in response.json()["detail"]

# Rate limiting
for _ in range(100):  # Exceed rate limit
    client.post("/memory", json=valid_memory)
response = client.post("/memory", json=valid_memory)
assert response.status_code == 429
```

### Security Tests
```python
# Cross-agent access prevention
response = client.get("/memory/123?agent_id=other-agent")
assert response.status_code == 403
```

## 🔗 Related Issues

- API implementation: src/mnemoverse_arch/memory/knowledge_delta/api/
- Security middleware: Security Test Suite issue
- Observability: Observability Test Suite issue

## 📚 References

- FastAPI documentation and best practices
- REST API design principles
- HTTP status code standards
- OpenAPI specification compliance

**Priority:** High
**Estimate:** 8-12 story points  
**Category:** API Testing
