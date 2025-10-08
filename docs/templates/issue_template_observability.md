# TDD: KD Observability & Metrics Test Suite

## 🎯 Overview

Implement comprehensive test suite for Knowledge Delta Observability system (TASK-OBS-003) to ensure structured logging, metrics collection, and secret redaction work correctly across all KD operations.

## 📋 Test Requirements

### Structured Logging Tests
- [ ] **Log Format Validation**
  - JSON structured output format
  - Required fields present (request_id, agent_id, category)
  - Timestamp format and timezone consistency
  - Log level enforcement (INFO/WARNING/ERROR)

- [ ] **KD Operation Logging**
  - `log_kd_read()` function with all parameters
  - `log_kd_write()` function with all parameters
  - `log_kd_error()` function with proper categorization
  - Context correlation via KDLogContext

- [ ] **Log Field Validation**
  - request_id uniqueness and format
  - session_id tracking across operations
  - agent_id inclusion in all logs
  - user_id optional field handling
  - duration_ms timing accuracy

### Secret Redaction Tests
- [ ] **API Key Redaction**
  - OpenAI API keys (sk-xxxx patterns)
  - Bearer tokens in headers
  - Authorization headers
  - Nested object secret detection

- [ ] **Password Pattern Detection**
  - Common password field names
  - URL-encoded credentials
  - JSON embedded secrets
  - Multi-level object traversal

- [ ] **Custom Secret Patterns**
  - Configurable regex patterns
  - Secret pattern precedence
  - False positive prevention
  - Performance with large payloads

### Metrics Collection Tests
- [ ] **Prometheus Metrics**
  - Counter metrics (reads_total, writes_total, errors_total)
  - Histogram metrics (read_time_ms, write_time_ms)
  - Gauge metrics (slice_ratios)
  - Label consistency and cardinality

- [ ] **Metric Registry Management**
  - Singleton pattern for metrics registry
  - No duplicate metric registration
  - Graceful degradation without prometheus-client
  - Custom CollectorRegistry isolation

- [ ] **Metric Value Accuracy**
  - Counter increments for operations
  - Histogram bucket distribution
  - Gauge value updates
  - Label filtering and aggregation

### Error Categorization Tests
- [ ] **Category Classification**
  - kd.read operation errors
  - kd.write operation errors
  - kd.security violations
  - kd.timeout events

- [ ] **Error Context Preservation**
  - Original exception details
  - Request correlation
  - Stack trace handling
  - Error message formatting

### Integration Tests
- [ ] **Memory System Integration**
  - DeltaMemorySystem operation logging
  - KDClient operation tracking
  - Context manager integration
  - End-to-end request tracing

- [ ] **API Endpoint Integration**
  - FastAPI middleware logging
  - HTTP request/response correlation
  - Error response logging
  - Performance impact measurement

## 🏗️ Implementation Structure

```
tests/observability/kd_observability/
├── test_structured_logging.py    # JSON format and field validation
├── test_secret_redaction.py      # API key and password redaction
├── test_metrics_collection.py    # Prometheus metrics functionality
├── test_error_categorization.py  # Error classification and context
├── test_integration_logging.py   # End-to-end logging scenarios
├── test_performance_impact.py    # Logging overhead measurement
├── conftest.py                   # Shared fixtures and utilities
└── utils/
    ├── logging_helpers.py        # Test logging utilities
    ├── metrics_helpers.py        # Metrics validation helpers
    └── secret_generators.py      # Test secret data generation
```

## 🧪 Test Data & Fixtures

Create comprehensive test datasets:
- Various secret patterns (API keys, tokens, passwords)
- KD operation scenarios (success/failure/timeout)
- Performance test payloads (small/medium/large)
- Multi-level nested objects with secrets
- Real-world API request/response examples

## ✅ Acceptance Criteria

- [ ] All logging functions tested with full parameter coverage
- [ ] Secret redaction tested with 20+ pattern types
- [ ] Metrics collection validated with accuracy tests
- [ ] Integration tests with actual KD components
- [ ] Performance impact < 5ms per log operation
- [ ] Zero secrets leaked in any test scenario
- [ ] Test coverage > 95% for observability components

## 🧪 Specific Test Scenarios

### Secret Redaction Scenarios
```python
# Test comprehensive secret detection
test_secrets = {
    "api_key": "sk-1234567890abcdef",
    "bearer": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9",
    "password": "my_secret_password_123",
    "nested": {"auth": {"secret": "hidden_value"}}
}
```

### Metrics Validation
```python
# Verify metric collection accuracy
assert kd_reads_total.labels(status='success').get() == 5
assert kd_write_time_ms.observe.call_count == 3
```

### Log Structure Validation
```python
# Ensure consistent log format
log_entry = {
    "timestamp": "2024-01-01T12:00:00Z",
    "level": "info",
    "category": "kd.read",
    "request_id": "req-123",
    "agent_id": "test-agent",
    "message": "Operation completed"
}
```

## 🔗 Related Issues

- Observability implementation: docs/kd_observability.md
- Secret patterns: IMPLEMENTATION_SUMMARY.md
- Metrics format: Prometheus standard

## 📚 References

- TASK-OBS-003: KD Observability Implementation
- Structured logging: JSON format with required fields
- Secret redaction: Configurable regex patterns
- Metrics: Prometheus client integration

**Priority:** High
**Estimate:** 6-10 story points  
**Category:** Observability Testing
