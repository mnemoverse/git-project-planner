# Planning System Scripts

Automation scripts for SmartKeys v2 planning system maintenance.

## 📦 Prerequisites

### Required Tools
- Python 3.8+
- GitHub CLI (`gh`)
- Git
- Bash 4.0+

### Installation
```bash
# Install GitHub CLI (macOS)
brew install gh

# Authenticate with GitHub (only needed once per machine)
gh auth login

# Create/update the shared virtual environment (recommended)
./Scripts/planning/setup-venv.sh

# Optional: pick a specific Python binary or force a rebuild
./Scripts/planning/setup-venv.sh --python "$(which python3.11)" --force

# (Optional) activate the environment for manual experimentation
source Scripts/planning/.venv/bin/activate
```

The setup script installs all dependencies listed in `Scripts/planning/requirements.txt` and can be rerun safely at any time. All planning scripts automatically re-execute inside `Scripts/planning/.venv`, so manual activation is rarely necessary.

## 🔧 Available Scripts

### 1. `update-sprint.sh` - Sprint Progress Tracker

Updates sprint metrics automatically by analyzing task checkboxes.

**Usage:**
```bash
# Interactive mode (prompts for actions)
./Scripts/planning/update-sprint.sh

# Auto-commit mode (commits changes automatically)
./Scripts/planning/update-sprint.sh --auto

# Help
./Scripts/planning/update-sprint.sh --help
```

**Features:**
- Counts completed/pending tasks
- Calculates completion percentage
- Detects blockers
- Archives completed sprints
- Updates `planning/current-sprint.md`

**What it updates:**
```markdown
## Progress
📊 Completed: 5/10 tasks (50%)
⏱️ Hours: 12h / 24h
🔥 Blockers: 0
🚀 Status: On Track
```

### 2. `sync-tasks.py` - Task to GitHub Issue Sync

Maintains 1:1 relationship between task files and GitHub Issues.

**Usage:**
```bash
# Dry run (preview changes)
./Scripts/planning/sync-tasks.sh --dry-run

# Execute sync
./Scripts/planning/sync-tasks.sh

# Direct Python execution (if venv is active)
python3 Scripts/planning/sync-tasks.py
```

**Features:**
- Creates GitHub Issues from task files
- Updates issue labels based on task metadata
- Maps status to `status:*` labels
- Maps priority to `priority:*` labels
- Preserves task file path in issue body

**Label Mapping:**
| Task Status | GitHub Label |
|------------|--------------|
| Ready | status:ready |
| InProgress | status:in-progress |
| Completed | status:done |
| Blocked | status:blocked |

| Task Priority | GitHub Label |
|--------------|--------------|
| Critical, P0 | priority:critical |
| High, P1 | priority:high |
| Medium, P2 | priority:medium |
| Low, P3 | priority:low |

**Note:** `sync-tasks.sh` and `sync-tasks.py` auto-bootstrap `Scripts/planning/.venv` via `setup-venv.sh`. Run `./Scripts/planning/setup-venv.sh --force` if you want to refresh the environment or reinstall dependencies manually.

## 🤖 Environment Variables

### Optional Configuration
```bash
# Repository settings (defaults shown)
export REPO_OWNER="mnemoverse"
export REPO_NAME="smartkeys-v2"

# GitHub token (uses gh auth by default)
export GITHUB_TOKEN="ghp_..."
```

## 📝 Task File Format

Scripts expect task files with this frontmatter:
```yaml
---
task_id: "SMK-001"
title: "Task Title"
status: "Ready"
priority: "High"
estimate: "4h"
assignee: ""
labels: ["component", "type"]
---
```

## 🚨 Troubleshooting

### Common Issues

**1. "gh: command not found"**
```bash
# Install GitHub CLI
brew install gh
gh auth login
```

**2. "No module named 'frontmatter'"**
```bash
# Rebuild the managed virtual environment
./Scripts/planning/setup-venv.sh --force

# (Optional) activate it for manual runs
source Scripts/planning/.venv/bin/activate
```

**3. "Permission denied" errors**
```bash
# Make scripts executable
chmod +x Scripts/planning/*.sh
chmod +x Scripts/planning/*.py
```

**4. "Repository not found"**
```bash
# Check GitHub authentication
gh auth status

# Verify repository access
gh repo view mnemoverse/smartkeys-v2
```

**5. Sprint metrics incorrect**
- Check task checkbox format: `- [ ]` or `- [x]`
- Ensure tasks are in correct sections (Ready/In Progress/Completed)
- Run script with `bash -x` for debug output

## 📊 GitHub Actions Integration

These scripts are integrated with CI/CD:

### Workflows
- `.github/workflows/planning-sync.yml` - Daily automated sync
- `.github/workflows/planning-tests.yml` - Test validation on push

### Schedule
- Daily sync at 9 AM UTC
- On push to `planning/` or `tasks/` directories
- Manual trigger via workflow_dispatch

## 🔐 Security Notes

- Scripts use GitHub CLI for authentication (no hardcoded tokens)
- Dry-run mode available for all destructive operations
- Scripts are idempotent (safe to run multiple times)
- No PII or sensitive data is logged

## 📚 Related Documentation

- [Planning System Overview](../../docs/planning/PLANNING_SYSTEM.md)
- [Automation Guide](../../docs/planning/AUTOMATION_GUIDE.md)
- [Workflow Guide](../../docs/planning/WORKFLOW_GUIDE.md)

## 🐛 Debugging

Enable debug output:
```bash
# Bash scripts
bash -x Scripts/planning/update-sprint.sh

# Python scripts
PYTHONVERBOSE=1 python3 Scripts/planning/sync-tasks.py
```

Check logs:
```bash
# GitHub Actions logs
gh run list --workflow=planning-sync.yml
gh run view <run-id>

# Local git history
git log --oneline planning/
```

## 💡 Tips

1. **Monday Planning:** Archive completed sprint, create new one
2. **Daily Updates:** Run `update-sprint.sh` after task changes
3. **Friday Review:** Update retrospective section manually
4. **Before PR:** Run scripts to ensure consistency

## 🚀 Future Enhancements

- [ ] `generate-report.py` - Sprint velocity reports
- [ ] Burndown chart generation
- [ ] Slack/Discord notifications
- [ ] Time tracking integration