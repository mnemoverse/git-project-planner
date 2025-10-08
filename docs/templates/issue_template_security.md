# TDD: KD Security & ACL Middleware Test Suite

## 🎯 Overview

Implement comprehensive test suite for Knowledge Delta Security & ACL middleware (TASK-SEC-001) to ensure multi-tenant security features work correctly across all security profiles.

## 📋 Test Requirements

### Core Security Tests
- [ ] **Agent ID Validation**
  - Valid agent ID formats (alphanumeric, hyphens, underscores)
  - Invalid agent ID rejection (special chars, too long, empty)
  - Missing agent ID error handling
  - Agent ID normalization

- [ ] **ACL (Access Control List) Tests**
  - Allowlist functionality (default allow, explicit list)
  - Denylist functionality (explicit blocks)
  - Default allow/deny policy enforcement
  - ACL rule precedence (denylist > allowlist)

- [ ] **Rate Limiting Tests**
  - Per-agent rate limits (read vs write operations)
  - Burst control for short-term spikes
  - Rate limit reset after time window
  - Retry-After header in 429 responses
  - Cross-agent isolation (one agent doesn't affect another)

### Security Profile Tests
- [ ] **Permissive Profile (Development)**
  - ACL disabled behavior
  - Rate limiting disabled
  - Agent ID optional scenarios
  - High limits for dev workflow

- [ ] **Standard Profile (Staging)**
  - ACL enabled with default allow
  - Moderate rate limiting
  - Agent ID required enforcement
  - Balanced security testing

- [ ] **Strict Profile (Production)**
  - ACL enabled with default deny
  - Aggressive rate limiting
  - Agent ID + User ID requirements
  - Maximum security validation

### API Integration Tests
- [ ] **Request Schema Validation**
  - All endpoints require agent_id in body/query
  - Field length limits (content, context, metadata)
  - JSON size limits for complex objects
  - Schema validation error messages

- [ ] **Response Code Testing**
  - 400 Bad Request for validation errors
  - 403 Forbidden for ACL violations
  - 429 Too Many Requests for rate limits
  - Proper error response format

- [ ] **Header Handling**
  - X-Request-ID tracking
  - Authorization bearer token processing
  - Retry-After calculation and format

### Security Logging Tests
- [ ] **Audit Trail Verification**
  - Security events logged at INFO level
  - Violations logged at WARNING level
  - Field redaction for sensitive data
  - Request correlation via request_id

- [ ] **Log Content Validation**
  - No secrets in log output
  - Proper categorization (kd.security)
  - Agent ID and operation tracking
  - Timestamp and severity consistency

## 🏗️ Implementation Structure

```
tests/security/kd_security/
├── test_agent_validation.py      # Agent ID format and validation
├── test_acl_enforcement.py       # Access control list functionality  
├── test_rate_limiting.py         # Rate limiting per agent
├── test_security_profiles.py     # Profile-specific behavior
├── test_api_integration.py       # Request/response validation
├── test_security_logging.py      # Audit and logging verification
├── conftest.py                   # Shared fixtures and utilities
└── utils/
    ├── security_helpers.py       # Test helper functions
    └── mock_agents.py            # Test agent configurations
```

## 🧪 Test Data & Fixtures

Create reusable test fixtures:
- Valid/invalid agent ID patterns
- ACL configuration scenarios
- Rate limiting test scenarios
- Security profile configurations
- Mock request/response objects

## ✅ Acceptance Criteria

- [ ] All security features covered with unit tests
- [ ] Integration tests for API endpoint security
- [ ] Performance tests for rate limiting accuracy
- [ ] Error scenario testing (edge cases)
- [ ] Documentation examples validated
- [ ] CI/CD pipeline integration
- [ ] Test coverage > 95% for security components

## 🔗 Related Issues

- Security implementation: docs/security/KD_SECURITY_IMPLEMENTATION.md
- Test environment: tests/security/ directory

## 📚 References

- TASK-SEC-001: KD Security & ACL Implementation
- Security profiles: permissive/standard/strict
- Rate limiting patterns: per-agent with burst control
- ACL patterns: allowlist/denylist with precedence

**Priority:** High
**Estimate:** 5-8 story points  
**Category:** Security Testing
