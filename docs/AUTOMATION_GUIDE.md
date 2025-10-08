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

## � GitHub Actions CI/CD

### Overview

Automated quality checks and validation run on every pull request and push to `main`. Ensures code quality without manual effort.

### Workflow Configuration

**File**: `.github/workflows/ci.yml`

**Triggers**:
- Pull requests to `main` branch
- Pushes to `main` branch
- Manual workflow dispatch

**Jobs**:

| Job | Purpose | Duration |
|-----|---------|----------|
| **lint** | Markdown, YAML, Shell linting | ~30s |
| **test-scripts** | Python/Shell syntax validation | ~15s |
| **security** | Secret detection | ~20s |
| **summary** | Aggregate results | ~5s |

### Status Badges

Add to your `README.md`:

```markdown
[![CI](https://github.com/YOUR_ORG/YOUR_REPO/workflows/CI/badge.svg)](https://github.com/YOUR_ORG/YOUR_REPO/actions)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
```

### Local CI Simulation

Run same checks locally before pushing:

```bash
# All checks
./scripts/validate-all.sh

# Just pre-commit hooks
pre-commit run --all-files

# Specific check
markdownlint docs/**/*.md
```

### Secrets Management

**Required secrets** (none for basic usage):
- `GITHUB_TOKEN` - Auto-provided by GitHub Actions

**Optional secrets** (for advanced features):
- `SLACK_WEBHOOK` - Notifications
- `DISCORD_WEBHOOK` - Notifications
- `GH_TOKEN` - Enhanced GitHub API access

To add secrets:
```bash
# Via GitHub CLI
gh secret set SLACK_WEBHOOK

# Or via web UI:
# Settings > Secrets and variables > Actions > New repository secret
```

### Workflow Customization

#### Skip CI for Specific Commits

```bash
git commit -m "docs: Update README [skip ci]"
```

#### Run CI on Draft PRs

Edit `.github/workflows/ci.yml`:
```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened, ready_for_review]
```

#### Add Custom Validation

```yaml
- name: Custom validation
  run: |
    # Your custom checks here
    ./scripts/my-custom-check.sh
```

### Performance Optimization

**Current Performance**:
- Total CI time: ~1-2 minutes
- Cached dependencies: ~30s saved per run

**Optimization Tips**:
1. Use caching for dependencies
2. Run independent jobs in parallel
3. Skip unchanged paths
4. Use `continue-on-error` for soft gates

### Troubleshooting CI

#### "Action failed: Lint & Validate"

```bash
# Run locally to see details
pre-commit run --all-files --verbose

# Check specific failing hook
pre-commit run markdownlint --all-files
```

#### "Python module not found"

Check `requirements.txt` is up-to-date:
```bash
pip freeze > scripts/requirements.txt
```

#### "Permission denied" for scripts

```bash
# Fix permissions
find scripts -name "*.sh" -exec chmod +x {} \;

# Commit changes
git add scripts/
git commit -m "fix: Script permissions"
```

### CI Best Practices

1. **Keep CI fast**: <2 minutes total
2. **Run locally first**: `./scripts/validate-all.sh`
3. **Don't skip checks**: Fix issues, don't bypass
4. **Monitor trends**: Watch for increasing CI times
5. **Update dependencies**: Keep actions up-to-date

## �📚 Related Documentation

- [Git Hooks Guide](GIT_HOOKS_GUIDE.md) - Local pre-commit setup
- [Planning System Overview](PLANNING_SYSTEM.md)
- [Workflow Guide](WORKFLOW_GUIDE.md)
- [Sprint Template](SPRINT_TEMPLATE.md)
- [Milestone Template](MILESTONE_TEMPLATE.md)