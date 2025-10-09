# Sprint Template

Copy this template to `planning/current-sprint.md` for active sprint or to `planning/completed-sprints/sprint-XX.md` for historical record.

---

# Sprint [Number]: [Start Date] - [End Date]

## Sprint Goal
🎯 [One clear sentence describing what this sprint will achieve]

## Capacity
- **Available Hours**: [X hours] (Y days × Z hours/day)
- **Committed**: [X hours] (should be ~80% of available)
- **Buffer**: [X hours] (for unknowns/blockers)

## Tasks

### In Progress
- [ ] **TASK-ID**: [Task title] ([Xh estimate], [% complete])
  - Assignee: [Name or @github]
  - Started: [Date]
  - Notes: [Any relevant status]

### Ready
- [ ] **TASK-ID**: [Task title] ([Xh estimate])
  - Priority: 🔥 Critical | ⚡ High | ⬆️ Medium | ⬇️ Low
  - Dependencies: [None or list]
  - GitHub Issue: #[Number]

### Completed
- [x] **TASK-ID**: [Task title] ([Xh estimated] → [Yh actual])
  - Completed: [Date]
  - PR: #[Number]

### Backlog (stretch goals)
- [ ] **TASK-ID**: [Task title] ([Xh estimate])
  - Will do if time permits

## Progress

### Summary
📊 **Completed**: X/Y tasks (Z%)
⏱️ **Hours**: Xh completed / Yh committed
📈 **Velocity**: X story points (or hours)
🎯 **Goal Status**: On Track | At Risk | Blocked

### Daily Tracking
| Day | Completed | Notes |
|-----|-----------|-------|
| Monday | Setup, TASK-001 started | Sprint planning done |
| Tuesday | TASK-001 50% | Encountered issue with X |
| Wednesday | TASK-001 done, TASK-002 started | Unblocked by Y |
| Thursday | TASK-002 done | Ahead of schedule |
| Friday | TASK-003 50%, retrospective | Good progress |

## Blockers

### Active Blockers
- **TASK-ID**: [Brief description of what's blocking]
  - **Impact**: [What can't proceed]
  - **Action**: [What we're doing about it]
  - **ETA**: [When we expect resolution]
  - **Owner**: [Who's working on unblocking]

### Resolved Blockers
- ~~**TASK-ID**: [What was blocking]~~ ✅ Resolved [Date]
  - Resolution: [How it was resolved]

## Notes

### Important Context
- [Any relevant information about the sprint]
- [Technical decisions made]
- [Scope changes]

### Links
- 🎯 [GitHub Project Board](link)
- 📊 [Metrics Dashboard](link)
- 💬 [Discussion Thread](link)

## Next Actions

### For Current Sprint
1. [Immediate next action]
2. [Following action]
3. [End of sprint action]

### For Next Sprint
- [ ] [Task to carry over]
- [ ] [New priority identified]
- [ ] [Technical debt to address]

---

## Sprint Retrospective
*Complete at end of sprint*

### Completed Work
Summary of what was delivered:

- ✅ **TASK-001**: [What was achieved]
- ✅ **TASK-002**: [What was achieved]
- ❌ **TASK-003**: [Why not completed]

### Metrics
| Metric | Planned | Actual | Variance |
|--------|---------|---------|----------|
| Tasks | Y | X | -Z |
| Hours | Y | X | -Z |
| Velocity | Y | X | -Z |

### What Went Well
- [Positive point 1]
- [Positive point 2]
- [Positive point 3]

### What Could Improve
- [Improvement area 1]
- [Improvement area 2]

### Action Items
- [ ] [Specific action to improve next sprint]
- [ ] [Process change to try]
- [ ] [Tool or technique to implement]

### Learnings
- **Technical**: [What we learned technically]
- **Process**: [What we learned about our process]
- **Team**: [What we learned about working together]

---

## Example: Filled Sprint

# Sprint 2: Oct 8-14, 2024

## Sprint Goal
🎯 Complete keyboard event correction pipeline with integration tests

## Capacity
- **Available Hours**: 40 hours (5 days × 8 hours/day)
- **Committed**: 32 hours (80% capacity)
- **Buffer**: 8 hours (for unknowns)

## Tasks

### In Progress
- [ ] **TASK-013**: Wire correction pipeline (8h, 60% complete)
  - Assignee: @eduard
  - Started: Oct 8
  - Notes: Word buffer complete, boundary detection WIP

### Ready
- [ ] **TASK-014**: Integration tests (4h)
  - Priority: ⚡ High
  - Dependencies: TASK-013
  - GitHub Issue: #124

### Completed
- [x] **TASK-012**: Application coordinator (8h → 10h)
  - Completed: Oct 8
  - PR: #122
- [x] **PS-001**: Planning documentation (2h → 3h)
  - Completed: Oct 9
  - PR: #123

### Backlog (stretch goals)
- [ ] **TASK-015**: Performance benchmarks (4h)

## Progress

### Summary
📊 **Completed**: 2/4 tasks (50%)
⏱️ **Hours**: 13h completed / 32h committed
📈 **Velocity**: 13 hours
🎯 **Goal Status**: On Track

### Daily Tracking
| Day | Completed | Notes |
|-----|-----------|-------|
| Monday | TASK-012 done, TASK-013 started | Good momentum |
| Tuesday | TASK-013 40%, PS-001 done | Documentation complete |
| Wednesday | TASK-013 60% | Boundary detection tricky |
| Thursday | - | - |
| Friday | - | - |

## Blockers

### Active Blockers
None currently

### Resolved Blockers
- ~~**TASK-013**: Unclear CorrectionEngine API~~ ✅ Resolved Oct 9
  - Resolution: Reviewed TASK-005 implementation

## Notes

### Important Context
- Simplified MVP approach - defer full word buffering to next sprint
- Swift 6 concurrency working well with @unchecked Sendable
- AsyncEventCoordinator integration successful

### Links
- 🎯 [GitHub Project](https://github.com/your-org/your-project/projects/1)
- 📊 [Pipeline Benchmarks](../research/RESEARCH-001-summary.md)

## Next Actions

### For Current Sprint
1. Complete word boundary detection
2. Wire CorrectionEngine integration
3. Write integration tests

### For Next Sprint
- [ ] TASK-015: Performance benchmarks
- [ ] Full word buffering implementation
- [ ] Multi-language testing

---

## Usage Instructions

1. **Start of Sprint**
   - Copy template to `planning/current-sprint.md`
   - Fill in sprint number, dates, goal
   - Add tasks from backlog
   - Calculate capacity

2. **During Sprint**
   - Update task progress daily
   - Move tasks between sections
   - Document blockers immediately
   - Track completion in daily section

3. **End of Sprint**
   - Copy to `planning/completed-sprints/sprint-XX.md`
   - Complete retrospective section
   - Calculate final metrics
   - Extract learnings and actions

4. **Tips**
   - Keep updates brief but informative
   - Link to Issues/PRs for detail
   - Update percentages realistically
   - Document decisions and changes