# Planning Directory

This directory contains all planning artifacts for SmartKeys v2 development.

## Structure

- `current-sprint.md` - Active sprint planning and tracking
- `roadmap.md` - Product roadmap with milestones and quarterly goals
- `completed-sprints/` - Archive of completed sprint files
- `milestones/` - Detailed milestone planning documents (optional)

## Quick Commands

View current sprint status:
```bash
cat current-sprint.md | grep "^- \["
```

Check sprint progress:
```bash
grep "📊" current-sprint.md
```

## Workflow

1. **Monday**: Update `current-sprint.md` with week's tasks
2. **Daily**: Update task status in `current-sprint.md`
3. **Friday**: Complete sprint retrospective, move to `completed-sprints/`

## Guidelines

- Keep sprint files focused (5-10 tasks max)
- Update status in real-time
- Document blockers immediately
- Complete retrospectives for learning

See [`docs/planning/PLANNING_SYSTEM.md`](../docs/planning/PLANNING_SYSTEM.md) for complete documentation.