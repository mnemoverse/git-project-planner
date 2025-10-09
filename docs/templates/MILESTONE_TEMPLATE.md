# Milestone Template

Copy this template to create new milestones in `planning/roadmap.md`.

---

## Milestone X: [Name]

### Overview
**Period**: [Start Date] - [End Date] (X weeks)
**Goal**: [One sentence describing what this milestone achieves]
**Status**: 🔄 Planning | 🚀 In Progress | ✅ Complete | ⚠️ At Risk | 🔴 Blocked

### Key Results
Define 3-5 measurable outcomes that indicate success:

- [ ] **KR1**: [Specific measurable result]
  - Success Metric: [How we measure]
  - Current: [X%]
- [ ] **KR2**: [Specific measurable result]
  - Success Metric: [How we measure]
  - Current: [X%]
- [ ] **KR3**: [Specific measurable result]
  - Success Metric: [How we measure]
  - Current: [X%]

### Sprints
Break down into 1-week sprints:

| Sprint | Dates | Focus | Status | Progress |
|--------|-------|-------|--------|----------|
| Sprint X | [MMM DD-DD] | [Main goal] | Planning | 0% |
| Sprint Y | [MMM DD-DD] | [Main goal] | Planning | 0% |
| Sprint Z | [MMM DD-DD] | [Main goal] | Planning | 0% |

### Task Breakdown
High-level task grouping:

#### Epic: [Component/Feature Name]
- [ ] Task 1 (Xh) - Sprint X
- [ ] Task 2 (Xh) - Sprint X
- [ ] Task 3 (Xh) - Sprint Y

#### Epic: [Component/Feature Name]
- [ ] Task 4 (Xh) - Sprint Y
- [ ] Task 5 (Xh) - Sprint Z
- [ ] Task 6 (Xh) - Sprint Z

### Dependencies
External dependencies and prerequisites:

| Dependency | Type | Owner | Status | Notes |
|------------|------|-------|--------|-------|
| [Dependency 1] | Technical | [Team/Person] | Resolved | [Notes] |
| [Dependency 2] | Resource | [Team/Person] | Pending | [Notes] |

### Risks
Identified risks and mitigation strategies:

| Risk | Probability | Impact | Mitigation | Status |
|------|------------|---------|------------|--------|
| [Risk description] | High/Medium/Low | High/Medium/Low | [Strategy] | Monitoring |

### Success Metrics
How we measure milestone success:

- **Performance**: [Metric and target]
- **Quality**: [Metric and target]
- **Adoption**: [Metric and target]
- **Technical**: [Metric and target]

### Resources
Links and references:

- 📄 [Design Doc](link)
- 💻 [Technical Spec](link)
- 🎯 [Project Board](link)
- 💬 [Discussion Thread](link)

### Notes
Additional context, decisions, changes:

- [Date]: [Note about important decision or change]
- [Date]: [Note about scope adjustment]

---

## Example: Filled Template

### Milestone 1: Core Pipeline

### Overview
**Period**: Oct 1 - Oct 15, 2024 (2 weeks)
**Goal**: Complete end-to-end keyboard event correction pipeline
**Status**: 🚀 In Progress

### Key Results
- [x] **KR1**: AsyncEventCoordinator integrated
  - Success Metric: p95 < 3ms latency
  - Current: 100% (2.8ms achieved)
- [ ] **KR2**: Correction pipeline working E2E
  - Success Metric: Type "ghbdtn" → corrects to "привет"
  - Current: 60% (events captured, correction pending)
- [ ] **KR3**: Integration tests passing
  - Success Metric: >90% test coverage
  - Current: 40% (unit tests only)

### Sprints
| Sprint | Dates | Focus | Status | Progress |
|--------|-------|-------|--------|----------|
| Sprint 1 | Oct 1-7 | Foundation + Async | Complete | 100% |
| Sprint 2 | Oct 8-14 | Pipeline + Tests | In Progress | 40% |

### Task Breakdown
#### Epic: Event Pipeline
- [x] TASK-012: Application coordinator (8h) - Sprint 1
- [x] RESEARCH-001: Async patterns (16h) - Sprint 1
- [ ] TASK-013: Wire correction pipeline (8h) - Sprint 2
- [ ] TASK-014: Integration tests (4h) - Sprint 2

### Dependencies
| Dependency | Type | Owner | Status | Notes |
|------------|------|-------|--------|-------|
| CGEventTap permissions | Technical | macOS | Resolved | Manual grant required |
| Swift 6 concurrency | Technical | Platform | Resolved | Using @unchecked Sendable |

### Risks
| Risk | Probability | Impact | Mitigation | Status |
|------|------------|---------|------------|--------|
| Swift 6 migration issues | Medium | High | Incremental adoption | Mitigated |
| Performance regression | Low | High | Continuous benchmarking | Monitoring |

### Success Metrics
- **Performance**: p95 < 8ms for full pipeline
- **Quality**: Zero crashes in 1000 corrections
- **Coverage**: >80% test coverage
- **Technical**: Memory < 200MB base

### Resources
- 📄 [Architecture Doc](../architecture/ARCHITECTURE.md)
- 💻 [RESEARCH-001](../research/RESEARCH-001-summary.md)
- 🎯 [GitHub Project](https://github.com/your-org/your-project/projects/1)

### Notes
- Oct 2: Switched from Pattern A to Pattern B based on research
- Oct 3: Simplified MVP - defer word buffering to Sprint 3

---

## Usage Instructions

1. **When to create milestone**
   - Major feature or integration (2-4 weeks)
   - Significant technical achievement
   - User-visible functionality

2. **How to track progress**
   - Update KR percentages weekly
   - Update sprint status daily
   - Review risks weekly

3. **Where to store**
   - Active milestones: `planning/roadmap.md`
   - Completed milestones: Archive section in roadmap
   - Templates: This file

4. **Review cadence**
   - Planning: Before milestone starts
   - Progress: Weekly during sprint planning
   - Retrospective: After milestone complete