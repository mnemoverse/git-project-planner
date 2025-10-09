# Planning Workflow Quick Reference

Quick commands and workflows for Git Project Planner development.

---

## 🚀 Start New Sprint

```bash
# 1. Review last sprint
cat planning/completed-sprints/sprint-N.md

# 2. Update current sprint plan
vim planning/current-sprint.md
# - Set sprint goal (one clear sentence)
# - Move tasks from backlog to Ready
# - Clear old blockers
# - Update sprint number and dates

# 3. Sync to GitHub (manual)
# - Create/update Issues for new tasks
# - Update Project board Sprint field
# - Move cards to Ready column

# 4. Or use sync script (if available)
Scripts/planning/sync-sprint.sh
```

### Sprint Plan Checklist
- [ ] Sprint goal defined
- [ ] 3-5 tasks selected
- [ ] Estimates total < 40h
- [ ] Dependencies checked
- [ ] Previous blockers cleared

---

## 💼 Work on Task

### Start Task
```bash
# 1. Check task details
cat tasks/*/TASK-XXX-*.md

# 2. Create feature branch
git checkout main
git pull origin main
git checkout -b feature/smk-xxx-description

# 3. Update tracking
# - Move GitHub card: Ready → In Progress
# - Update current-sprint.md if needed
```

### During Development
```bash
# Regular commits
git add .
git commit -m "feat(TASK-XXX): Clear description"

# Check progress
git log --oneline -5

# Update if blocked
vim planning/current-sprint.md
# Add to Blockers section
```

### Complete Task
```bash
# 1. Final commit and push
git add .
git commit -m "feat(TASK-XXX): Complete implementation"
git push origin feature/smk-xxx-description

# 2. Create PR
gh pr create \
  --title "TASK-XXX: Task title" \
  --body "$(cat <<EOF
## Summary
Brief description of what was done

## Changes
- Change 1
- Change 2

## Testing
How to test this

## Checklist
- [x] Tests pass
- [x] Documentation updated
- [x] No performance regression

Closes #ISSUE_NUMBER
EOF
)"

# 3. After merge
# - Issue auto-closes
# - Card moves to Done
# - Task marked complete in sprint
```

---

## 📊 Check Progress

### Current Sprint Status
```bash
# Quick status
grep -E "^- \[.\]" planning/current-sprint.md

# Detailed view
cat planning/current-sprint.md

# Count completed
grep -c "^- \[x\]" planning/current-sprint.md
```

### Project Board
```bash
# Open in browser
open https://github.com/your-org/your-project/projects/1

# Or via CLI
gh project item-list 1 --owner mnemoverse --limit 20
```

### Generate Report
```bash
# Simple report
echo "=== Sprint Status $(date) ==="
echo "Tasks:"
grep "^- \[" planning/current-sprint.md
echo ""
echo "Blockers:"
grep -A2 "^## Blockers" planning/current-sprint.md

# Full report (if script available)
Scripts/planning/generate-report.py
```

---

## 🔥 Handle Blocker

### Document Blocker
```bash
# 1. Update sprint file
vim planning/current-sprint.md
```

Add to Blockers section:
```markdown
## Blockers
- TASK-XXX: Brief description of blocker
  - Impact: What's blocked
  - Action: What we're doing about it
  - ETA: When we expect resolution
```

### Update GitHub
```bash
# Add comment to issue
gh issue comment XXX --body "🔥 Blocked: [describe blocker]"

# Update project card
# - Set Blocker field = Yes
# - Add blocker label
```

### Work Around
```bash
# Switch to unblocked task
git stash
git checkout main
git checkout -b feature/different-task

# Or create spike/investigation task
vim tasks/backlog/SPIKE-investigate-blocker.md
```

---

## 📝 End Sprint

### Friday Afternoon Routine

```bash
# 1. Create sprint summary
cp planning/current-sprint.md \
   planning/completed-sprints/sprint-N.md

# 2. Edit summary
vim planning/completed-sprints/sprint-N.md
```

Add retrospective section:
```markdown
## Sprint N Summary

### Completed (X/Y)
- ✅ TASK-XXX: Description
- ✅ TASK-YYY: Description

### Not Completed
- ❌ TASK-ZZZ: Reason

### Metrics
- Planned: Y tasks, XXh
- Completed: X tasks, YYh
- Velocity: X tasks/sprint
- Accuracy: YY%

### Learnings
- What went well
- What was challenging
- What to improve

### Next Sprint Focus
- Key priority for next week
```

```bash
# 3. Prep next sprint
vim planning/current-sprint.md
# - Move incomplete tasks to Backlog or next Ready
# - Clear completed tasks
# - Update sprint number
# - Add placeholder goal

# 4. Commit changes
git add planning/
git commit -m "docs: Sprint N summary and next sprint prep"
git push origin main
```

---

## 🎯 Quick Commands

### Task Management
```bash
# Find task file
fd TASK-013
find tasks -name "*013*"

# View task
cat tasks/*/TASK-013-*.md

# List all tasks
find tasks -name "*.md" -type f | sort

# List backlog
ls tasks/backlog/

# Search tasks
grep -r "correction" tasks/
```

### Git Workflow
```bash
# Start feature
git checkout -b feature/smk-xxx

# Update feature branch
git checkout main
git pull origin main
git checkout feature/smk-xxx
git rebase main

# Clean up after merge
git checkout main
git pull origin main
git branch -d feature/smk-xxx
```

### GitHub CLI
```bash
# List my issues
gh issue list --assignee @me

# List sprint issues
gh issue list --label "sprint-2"

# View issue
gh issue view 123

# Create issue
gh issue create --title "Title" --body "Body"

# List PRs
gh pr list

# Check PR status
gh pr checks

# Merge PR
gh pr merge --squash
```

---

## 📋 Templates

### New Task Quick Template
```markdown
---
task_id: "TASK-XXX"
title: "Clear title"
priority: "High|Medium|Low"
estimate: "Xh"
---

# TASK-XXX: Title

## Objective
One sentence goal

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2

## DoD
- [ ] Code complete
- [ ] Tests pass
- [ ] PR merged
```

### PR Description Template
```markdown
## Summary
What this PR does

## Changes
- Specific change 1
- Specific change 2

## Testing
How to test

## Screenshots (if UI)
Before/After

Closes #XXX
```

### Blocker Template
```markdown
## Blocker: [Title]
- **Task**: TASK-XXX
- **Issue**: What's blocking
- **Impact**: What can't proceed
- **Action**: What we're doing
- **ETA**: Expected resolution
- **Workaround**: Alternative if any
```

---

## 🚨 Common Issues

### Task Not Synced
```bash
# Check if issue exists
gh issue list --search "TASK-XXX"

# Create if missing
gh issue create --title "TASK-XXX: Title" \
                --body "See tasks/.../TASK-XXX.md"

# Link to project
gh project item-add 1 --owner mnemoverse --url [issue-url]
```

### Merge Conflicts
```bash
# Update and rebase
git checkout main
git pull origin main
git checkout feature/xxx
git rebase main
# Resolve conflicts
git add .
git rebase --continue
git push --force-with-lease
```

### Find Blocked Tasks
```bash
# In sprint file
grep -B2 "Blocker" planning/current-sprint.md

# In GitHub
gh issue list --label "blocked"

# In Project
gh project item-list 1 --owner mnemoverse | grep "Blocked"
```

---

## 📞 Getting Help

1. **Check documentation**
   - Main guide: `docs/planning/PLANNING_SYSTEM.md`
   - Templates: `docs/planning/*_TEMPLATE.md`

2. **Check examples**
   - Previous sprints: `planning/completed-sprints/`
   - Completed tasks: `git log --grep="TASK-"`

3. **Debug commands**
   ```bash
   # System status
   ls planning/
   gh project list --owner mnemoverse

   # Recent activity
   git log --oneline -10
   gh issue list --state all --limit 10
   ```

4. **File issue**
   ```bash
   gh issue create --label "planning-system" \
                   --title "Planning: [Issue]"
   ```

---

## 🔄 Daily Checklist

### Morning (5 min)
- [ ] Check current task
- [ ] Review blockers
- [ ] Plan day's work

```bash
# Quick morning check
echo "=== $(date +'%A, %B %d') ==="
grep "In Progress" planning/current-sprint.md
grep "Blocker" planning/current-sprint.md
```

### Evening (5 min)
- [ ] Commit work
- [ ] Update task status
- [ ] Note any blockers

```bash
# End of day
git add .
git commit -m "wip: Description"
git push origin feature/current
```

### Friday (30 min)
- [ ] Complete sprint summary
- [ ] Update task statuses
- [ ] Plan next sprint
- [ ] Clean up branches

---

## 🎪 Tips & Tricks

### Aliases for Common Commands
```bash
# Add to ~/.zshrc or ~/.bashrc
alias sprint='cat planning/current-sprint.md'
alias tasks='find tasks -name "*.md" | sort'
alias blocked='grep -n "Blocker" planning/current-sprint.md'
alias todo='grep "^- \[ \]" planning/current-sprint.md'
alias done='grep "^- \[x\]" planning/current-sprint.md'
```

### Quick Status Badge
```bash
# Add to terminal prompt or MOTD
echo "📊 Sprint Progress: $(grep -c "^- \[x\]" planning/current-sprint.md)/$(grep -c "^- \[" planning/current-sprint.md) tasks"
```

### Batch Operations
```bash
# Create multiple issues at once
for task in tasks/backlog/*.md; do
  title=$(grep "title:" $task | cut -d'"' -f2)
  gh issue create --title "$title" --body "See $task"
done

# Update all PRs
gh pr list --json number --jq '.[].number' | while read pr; do
  gh pr edit $pr --add-label "sprint-2"
done
```

---

*Quick Reference v1.0 | Last Updated: October 2024*