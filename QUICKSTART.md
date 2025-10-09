# Quick Start Guide

**Get started with Git Project Planner in 10 minutes**

This guide walks you through integrating Git Project Planner into an existing project, based on real-world experience integrating into [SmartKeys v2](https://github.com/mnemoverse/smartkeys-v2).

---

## Prerequisites

- **Git repository** with GitHub access
- **Python 3.8+** installed
- **GitHub CLI** (`gh`) installed and authenticated
- **Optional**: GitHub Project board (can be created later)

Quick check:
```bash
git --version    # Should show 2.x+
python3 --version # Should show 3.8+
gh --version     # Should show 2.x+
gh auth status   # Should show "Logged in"
```

---

## Option 1: Add as Git Submodule (Recommended)

Best for projects that want to track git-project-planner updates while keeping it separate.

### Step 1: Add Submodule

```bash
# In your project root
git checkout -b feature/integrate-planning-system
git submodule add https://github.com/mnemoverse/git-project-planner.git .planner
cd .planner
```

### Step 2: Configure for Your Project

Create `.planner-config.yml` in your project root:

```yaml
# .planner-config.yml
repository:
  owner: "your-github-org"      # e.g., "mnemoverse"
  name: "your-repo-name"        # e.g., "smartkeys-v2"

paths:
  tasks: "tasks"                # Where task files live
  planning: "planning"          # Where sprint/roadmap files live
  docs: "docs/planning"         # Planning documentation

project:
  number: 11                    # Your GitHub Project number (from URL)

task_prefixes:
  feature: "FEAT"               # Feature task prefix (e.g., FEAT-001)
  planning: "PLAN"              # Planning task prefix
  bugfix: "BUG"                 # Bug fix prefix

sprint:
  duration_days: 7              # Sprint duration
  start_day: "Monday"           # Week start day

workflow:
  auto_sync_issues: true        # Auto-sync with GitHub Issues
  archive_completed: true       # Archive completed sprints
  require_estimates: true       # Require time estimates
```

Copy this config to `.planner/`:
```bash
cp .planner-config.yml .planner/
```

### Step 3: Setup Python Environment

```bash
cd .planner
./scripts/setup-venv.sh
```

This will:
- Create virtual environment in `.planner/scripts/.venv`
- Install required Python packages (PyYAML, frontmatter, click, rich)
- Show activation instructions

### Step 4: Create Directory Structure

If you don't have `tasks/` and `planning/` directories yet:

```bash
cd .. # Back to project root

# Create directories
mkdir -p tasks planning docs/planning

# Copy templates
cp .planner/examples/tasks/EXAMPLE-001-feature-implementation.md tasks/FEAT-001-example.md
cp .planner/examples/planning/sprint-example.md planning/current-sprint.md
cp .planner/examples/planning/roadmap-example.md planning/roadmap.md

# Copy documentation
cp .planner/docs/templates/*.md docs/planning/
```

### Step 5: Test Integration

Run the integration test:

```bash
# Quick validation
.planner/scripts/validate-all.sh

# If you have existing tasks, try syncing (dry-run first)
cd .planner
source scripts/.venv/bin/activate
python scripts/sync-tasks.py --dry-run
```

### Step 6: Commit and Push

```bash
git add .gitmodules .planner .planner-config.yml tasks/ planning/ docs/planning/
git commit -m "feat: Integrate git-project-planner for structured planning"
git push -u origin feature/integrate-planning-system
```

---

## Option 2: Direct Copy

Best for projects that want to customize heavily or don't want submodule complexity.

```bash
# Clone to temp directory
git clone https://github.com/mnemoverse/git-project-planner.git /tmp/planner

# Copy what you need
mkdir -p .planner
cp -r /tmp/planner/scripts .planner/
cp -r /tmp/planner/docs .planner/
cp /tmp/planner/.planner-config.yml .

# Setup
cd .planner
./scripts/setup-venv.sh

# Clean up
rm -rf /tmp/planner
```

---

## Real-World Example: SmartKeys v2 Integration

**Context**: SmartKeys v2 is a macOS keyboard assistant with 59 tasks, active sprints, and GitHub Project #11.

**What we did**:

1. **Created integration branch**:
   ```bash
   git checkout -b feature/integrate-git-project-planner
   ```

2. **Added as submodule**:
   ```bash
   git submodule add ../git-project-planner .planner
   ```

3. **Configured** `.planner-config.yml`:
   ```yaml
   repository:
     owner: "mnemoverse"
     name: "smartkeys-v2"
   
   paths:
     tasks: "tasks"              # Already had SMK-001, SMK-002, etc.
     planning: "planning"        # Already had current-sprint.md
     docs: "docs/planning"       # Existing planning docs
   
   project:
     number: 11                  # GitHub Project board
   
   task_prefixes:
     feature: "SMK"              # SmartKeys tasks
     planning: "PS"              # Planning system tasks
     bugfix: "BUG"
   ```

4. **Tested compatibility**:
   ```bash
   # Created test script
   ./test-planner-integration.sh
   
   # Output showed:
   # ✓ Config exists
   # ✓ Found 59 task files
   # ✓ Task format compatible
   # ✓ Planning directory exists
   ```

5. **Result**: Zero conflicts! Existing structure was 100% compatible.

**Time to integrate**: ~15 minutes

**What worked well**:
- Existing YAML frontmatter matched perfectly
- `tasks/week1/SMK-*.md` structure worked out of the box
- `planning/current-sprint.md` needed no changes
- Scripts read config automatically - no hardcoded paths

**Lessons learned**:
- Having consistent task IDs (SMK-001, SMK-002) made sync easy
- Git submodule keeps planner tools up-to-date
- Config file makes it portable across projects

---

## Next Steps After Integration

### 1. Create Your First Task

```bash
# Copy template
cp .planner/docs/templates/TASK_TEMPLATE.md tasks/FEAT-001-my-first-task.md

# Edit with your details
vim tasks/FEAT-001-my-first-task.md
```

### 2. Sync with GitHub Issues

```bash
cd .planner
source scripts/.venv/bin/activate
python scripts/sync-tasks.py
```

This will:
- Create GitHub Issues for each task file
- Link them to your GitHub Project
- Keep frontmatter in sync

### 3. Start Your First Sprint

```bash
# Edit sprint plan
vim planning/current-sprint.md

# Update progress
.planner/scripts/update-sprint.sh
```

### 4. Setup Pre-commit Hooks (Optional)

```bash
cd .planner
./scripts/setup-hooks.sh
```

Enables automatic validation before commits.

---

## Troubleshooting

### "Python module not found"

```bash
cd .planner
./scripts/setup-venv.sh --force
source scripts/.venv/bin/activate
```

### "GitHub CLI not authenticated"

```bash
gh auth login
gh auth status
```

### "Config file not found"

Make sure `.planner-config.yml` exists in both:
- Project root (for your reference)
- `.planner/` directory (scripts read from here)

```bash
cp .planner-config.yml .planner/
```

### "Submodule not initialized"

```bash
git submodule init
git submodule update
```

---

## Daily Workflow

```bash
# Morning: Check current sprint
cat planning/current-sprint.md

# Work on task
vim tasks/FEAT-042-implement-feature.md

# Update task status
# (Edit frontmatter: status: "In Progress" → "Completed")

# Sync with GitHub
cd .planner && source scripts/.venv/bin/activate
python scripts/sync-tasks.py

# Evening: Update sprint progress
.planner/scripts/update-sprint.sh
```

---

## Getting Help

- **Documentation**: See `.planner/docs/` for detailed guides
- **Examples**: Check `.planner/examples/` for templates
- **Issues**: [github.com/mnemoverse/git-project-planner/issues](https://github.com/mnemoverse/git-project-planner/issues)

---

## What's Next?

- **Week 1**: Use templates, get comfortable with workflow
- **Week 2**: Customize task prefixes and sprint duration
- **Week 3**: Setup automation (pre-commit hooks, CI/CD)
- **Month 2**: Share learnings, contribute improvements

**Welcome to structured, Git-native planning!** 🚀
