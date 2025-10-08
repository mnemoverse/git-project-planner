# Planning System Automation Guide

## Overview

The SmartKeys v2 planning system includes several automation tools to reduce manual work and maintain consistency.

## 🤖 Automated Components

### 1. Sprint Progress Updates

**Script**: `Scripts/planning/update-sprint.sh`

Updates sprint progress metrics automatically by:
- Counting completed/pending tasks
- Calculating completion percentage
- Detecting blockers
- Updating progress section in `current-sprint.md`

**Usage**:
```bash
# Manual update with prompts
./Scripts/planning/update-sprint.sh

# Auto-commit changes
./Scripts/planning/update-sprint.sh --auto
```

**Features**:
- ✅ Automatic task counting
- ✅ Progress percentage calculation
- ✅ Blocker detection
- ✅ Sprint completion detection
- ✅ Archive prompts for completed sprints
- ✅ Git commit reminders

### 2. Task-to-Issue Synchronization

**Script**: `Scripts/planning/sync-tasks.sh`

Maintains 1:1 relationship between task files and GitHub Issues:
- Creates GitHub Issues from task files
- Updates issue labels based on task status
- Preserves task metadata in issue body

**Usage**:
```bash
# Dry run (preview changes)
./Scripts/planning/sync-tasks.sh --dry-run

# Execute sync
./Scripts/planning/sync-tasks.sh
```

**Label Mapping**:
- Status → `status:*` labels (ready, in-progress, done, etc.)
- Priority → `priority:*` labels (critical, high, medium, low)
- Component → `component:*` labels (based on path)
- Sprint → `sprint:*` labels (based on week folders)

### 3. GitHub Actions Workflow

**File**: `.github/workflows/planning-sync.yml`

Runs automatically on:
- Daily schedule (9 AM UTC)
- Push to `planning/` or `tasks/` directories
- Manual trigger (workflow_dispatch)

**Features**:
- 📊 Sprint metrics in workflow summary
- 🔄 Task status validation
- 📅 Monday sprint planning reminders
- 💬 PR impact comments
- 🏷️ Automatic commit for scheduled runs

## 📝 Daily Workflow

### Morning Routine (Manual)
```bash
# Review current sprint
cat planning/current-sprint.md

# Update task statuses in files
vim tasks/week2/SMK-XXX-*.md

# Update sprint progress
./Scripts/planning/update-sprint.sh

# Commit changes
git add -A
git commit -m "chore: Update sprint progress"
git push
```

### End of Day (Manual)
```bash
# Quick progress check
./Scripts/planning/update-sprint.sh

# Review blockers
grep "## Blockers" planning/current-sprint.md -A 5

# Update daily notes
vim planning/current-sprint.md
```

### Monday Sprint Planning
```bash
# If sprint complete, archive it
./Scripts/planning/update-sprint.sh
# Answer 'y' to archive prompt

# Create new sprint file
cp docs/planning/SPRINT_TEMPLATE.md planning/current-sprint.md
vim planning/current-sprint.md

# Sync tasks to GitHub Issues
./Scripts/planning/sync-tasks.sh
```

### Friday Retrospective
```bash
# Update retrospective section
vim planning/current-sprint.md

# Calculate actual hours
grep "→.*actual" planning/current-sprint.md

# Commit week's work
git add -A
git commit -m "chore: Sprint retrospective and week summary"
git push
```

## 🔧 Setup Requirements

### Local Environment
```bash
# Python dependencies (in virtual environment)
python3 -m venv .planning-venv
source .planning-venv/bin/activate
pip install python-frontmatter pyyaml click

# GitHub CLI
brew install gh
gh auth login
```

### GitHub Repository Settings

1. **Labels** (created automatically by sync script):
   - Status labels: `status:backlog`, `status:ready`, etc.
   - Priority labels: `priority:critical`, `priority:high`, etc.
   - Component labels: `component:planning`, `component:core`, etc.
   - Sprint labels: `sprint:1`, `sprint:2`, etc.

2. **GitHub Actions**:
   - Ensure Actions are enabled
   - Grant write permissions for workflows

## 🚀 Advanced Automation

### Custom Git Hooks

Create `.git/hooks/pre-commit` for automatic sprint updates:
```bash
#!/bin/bash
# Auto-update sprint on commit
if git diff --cached --name-only | grep -q "tasks/.*\.md"; then
    ./Scripts/planning/update-sprint.sh --auto
    git add planning/current-sprint.md
fi
```

### Slack/Discord Integration

Add to GitHub Actions workflow:
```yaml
- name: Send sprint summary
  if: github.event.schedule
  run: |
    curl -X POST ${{ secrets.SLACK_WEBHOOK }} \
      -H 'Content-Type: application/json' \
      -d "{\"text\":\"Sprint Progress: ${{ steps.metrics.outputs.percentage }}%\"}"
```

### VS Code Tasks

Add to `.vscode/tasks.json`:
```json
{
  "label": "Update Sprint",
  "type": "shell",
  "command": "./Scripts/planning/update-sprint.sh",
  "group": "build",
  "presentation": {
    "reveal": "always",
    "panel": "new"
  }
}
```

## 📊 Metrics and Reporting

### Sprint Velocity Tracking
```bash
# Calculate velocity from completed sprints
for f in planning/completed-sprints/*.md; do
    echo "$f: $(grep -c "^- \[x\]" "$f") tasks"
done
```

### Burndown Chart Data
```bash
# Extract daily progress
git log --format="" --name-only planning/current-sprint.md | \
    xargs -I {} git show {}:planning/current-sprint.md | \
    grep "📊 Completed"
```

## 🐛 Troubleshooting

### Common Issues

1. **"gh: command not found"**
   ```bash
   brew install gh
   gh auth login
   ```

2. **"No module named frontmatter"**
   ```bash
   source .planning-venv/bin/activate
   pip install python-frontmatter
   ```

3. **"Permission denied" for scripts**
   ```bash
   chmod +x Scripts/planning/*.sh
   chmod +x Scripts/planning/*.py
   ```

4. **Sprint metrics incorrect**
   - Check task checkbox format: `- [ ]` or `- [x]`
   - Ensure no extra spaces in checkboxes
   - Verify tasks are in correct sections

## 🔮 Future Enhancements

- [ ] Automatic PR creation for sprint archives
- [ ] Burndown chart generation
- [ ] Team capacity planning
- [ ] Integration with time tracking tools
- [ ] Automated standup reports
- [ ] Sprint health scoring
- [ ] Predictive completion dates

## 📚 Related Documentation

- [Planning System Overview](PLANNING_SYSTEM.md)
- [Workflow Guide](WORKFLOW_GUIDE.md)
- [Sprint Template](SPRINT_TEMPLATE.md)
- [Milestone Template](MILESTONE_TEMPLATE.md)