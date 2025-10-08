#!/bin/bash
# Setup Git Project Planner in a new repository
set -e

echo "🚀 Git Project Planner Setup"
echo "=============================="
echo ""

# Configuration
PLANNING_DIR="planning"
TASKS_DIR="tasks"
CONFIG_FILE=".planner-config.yml"

# Parse arguments
REPO_OWNER=""
REPO_NAME=""
PROJECT_NUM=1

while [[ $# -gt 0 ]]; do
  case $1 in
    --repo)
      IFS='/' read -r REPO_OWNER REPO_NAME <<< "$2"
      shift 2
      ;;
    --project-number)
      PROJECT_NUM="$2"
      shift 2
      ;;
    --help)
      echo "Usage: $0 [options]"
      echo ""
      echo "Options:"
      echo "  --repo owner/name         Set repository owner and name"
      echo "  --project-number N        Set GitHub Project number (default: 1)"
      echo "  --help                    Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Detect repository from git remote if not provided
if [[ -z "$REPO_OWNER" ]] || [[ -z "$REPO_NAME" ]]; then
  echo "📡 Detecting repository from git remote..."
  GIT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
  
  if [[ $GIT_REMOTE =~ github\.com[:/]([^/]+)/([^/\.]+) ]]; then
    REPO_OWNER="${BASH_REMATCH[1]}"
    REPO_NAME="${BASH_REMATCH[2]}"
    echo "   Found: $REPO_OWNER/$REPO_NAME"
  else
    echo "⚠️  Could not detect repository. Using placeholders."
    REPO_OWNER="your-org"
    REPO_NAME="your-project"
  fi
fi

echo ""
echo "📋 Configuration:"
echo "   Repository: $REPO_OWNER/$REPO_NAME"
echo "   Project: #$PROJECT_NUM"
echo ""

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p "$PLANNING_DIR/completed-sprints"
mkdir -p "$TASKS_DIR/backlog"
echo "   ✅ $PLANNING_DIR/"
echo "   ✅ $TASKS_DIR/"

# Create config file
echo ""
echo "⚙️  Creating configuration file..."
if [[ ! -f "$CONFIG_FILE" ]]; then
  cat > "$CONFIG_FILE" << CONFIGEOF
# Git Project Planner Configuration

repository:
  owner: "$REPO_OWNER"
  name: "$REPO_NAME"

project:
  number: $PROJECT_NUM
  enabled: true

paths:
  planning: "$PLANNING_DIR/"
  tasks: "$TASKS_DIR/"

sprint:
  duration_days: 7
  start_day: 1

labels:
  status_prefix: "status:"
  priority_prefix: "priority:"
CONFIGEOF
  echo "   ✅ $CONFIG_FILE created"
else
  echo "   ⚠️  $CONFIG_FILE already exists, skipping"
fi

# Copy templates
echo ""
echo "📄 Setting up templates..."
if [[ -d "docs/templates" ]]; then
  cp docs/templates/SPRINT_TEMPLATE.md "$PLANNING_DIR/current-sprint.md" 2>/dev/null || true
  cp docs/templates/MILESTONE_TEMPLATE.md "$PLANNING_DIR/roadmap.md" 2>/dev/null || true
  echo "   ✅ Templates copied"
else
  echo "   ⚠️  docs/templates not found, skipping"
fi

# Create initial README
echo ""
echo "📝 Creating planning README..."
cat > "$PLANNING_DIR/README.md" << 'READMEEOF'
# Planning Directory

This directory contains sprint plans, roadmap, and historical records.

## Files

- `roadmap.md` - High-level project roadmap and milestones
- `current-sprint.md` - Active sprint plan (update daily)
- `completed-sprints/` - Historical sprint summaries

## Workflow

1. **Monday**: Plan sprint, update `current-sprint.md`
2. **Daily**: Update task progress
3. **Friday**: Create sprint summary in `completed-sprints/`

See [docs/WORKFLOW_GUIDE.md](../docs/WORKFLOW_GUIDE.md) for details.
READMEEOF
echo "   ✅ $PLANNING_DIR/README.md created"

# Create tasks README
cat > "$TASKS_DIR/README.md" << 'TASKSEOF'
# Tasks Directory

Task specifications and detailed requirements.

## Structure

- `backlog/` - Unscheduled tasks
- `week1/`, `week2/` - Tasks organized by sprint

## Creating Tasks

Use the template:
```bash
cp ../docs/templates/TASK_TEMPLATE.md tasks/backlog/TASK-XXX-description.md
```

See [docs/PLANNING_SYSTEM.md](../docs/PLANNING_SYSTEM.md) for task format.
TASKSEOF
echo "   ✅ $TASKS_DIR/README.md created"

# Summary
echo ""
echo "✨ Setup complete!"
echo ""
echo "📚 Next steps:"
echo "   1. Edit $PLANNING_DIR/roadmap.md - set your project vision"
echo "   2. Edit $PLANNING_DIR/current-sprint.md - plan your first sprint"
echo "   3. Create tasks in $TASKS_DIR/"
echo "   4. (Optional) Run ./scripts/sync-tasks.sh to sync to GitHub"
echo ""
echo "📖 Documentation: docs/PLANNING_SYSTEM.md"
echo ""
