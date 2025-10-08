# Git Project Planner

A comprehensive Git-based project planning system with GitHub integration.

## 🎯 Overview

Git Project Planner is a lightweight, flexible planning system that uses Git as the source of truth while providing optional GitHub Project integration for visualization. Perfect for solo developers, small teams, and **hybrid human-AI teams** who want:

- **Simple**: Markdown files, clear structure, minimal overhead
- **Reliable**: Version-controlled planning with full history
- **Flexible**: Works with any repository, any language
- **Visual**: Optional GitHub Projects Kanban board integration
- **AI-Friendly**: Structured for AI agents to understand full context

> 💡 **Philosophy**: Everything in Git. Minimal external tools. Automate everything possible. See [VISION.md](VISION.md) for the full picture.

## 🚀 Quick Start

### 1. Copy to Your Project

```bash
# Clone or download this repository
git clone https://github.com/mnemoverse/git-project-planner.git

# Copy to your project
cp -r git-project-planner/{docs,scripts,examples} /path/to/your/project/
cd /path/to/your/project
```

### 2. Initialize Planning System

```bash
# Run setup script
./scripts/setup-project.sh

# This creates:
# - planning/ directory with templates
# - tasks/ directory for task specifications
# - .planner-config.yml configuration file
```

### 3. Start Planning

```bash
# Edit your first sprint plan
vim planning/current-sprint.md

# Create your first task
cp docs/templates/TASK_TEMPLATE.md tasks/TASK-001-my-first-task.md
vim tasks/TASK-001-my-first-task.md

# Update sprint progress
./scripts/update-sprint.sh
```

### 4. (Optional) GitHub Integration

```bash
# Sync tasks to GitHub Issues
./scripts/sync-tasks.sh

# Link issues to GitHub Project
./scripts/link-issues-to-project.sh
```

## 📁 What's Included

### Documentation (`docs/`)
- **PLANNING_SYSTEM.md** - Complete system description
- **WORKFLOW_GUIDE.md** - Daily workflow quick reference
- **AUTOMATION_GUIDE.md** - Scripts and CI/CD integration
- **GITHUB_SETUP.md** - GitHub Projects configuration
- **templates/** - Task, sprint, and issue templates

### Scripts (`scripts/`)
- **setup-project.sh** - Initialize planning system
- **sync-tasks.py** - Sync tasks to GitHub Issues
- **update-sprint.sh** - Update sprint progress
- **sync-project-fields.sh** - Sync GitHub Project fields
- **setup-venv.sh** - Python environment setup

### Examples (`examples/`)
- **planning/** - Example roadmap and sprint files
- **tasks/** - Example task specifications
- **categories/** - Examples of task categorization

## 🎪 Features

- ✅ **Git-based planning** - All planning data in version control
- ✅ **Markdown-native** - Easy to read, write, and diff
- ✅ **GitHub integration** - Optional Issues and Projects sync
- ✅ **Sprint tracking** - Weekly sprint planning and retrospectives
- ✅ **Task templates** - Consistent task specifications
- ✅ **Automation scripts** - Reduce manual synchronization work
- ✅ **Flexible structure** - Adapt to your workflow

## 📖 Core Concepts

### Planning Hierarchy

```
Roadmap (3 months)
  └── Milestone (2-4 weeks)
      └── Sprint (1 week)
          └── Task (hours/days)
```

### File Structure

```
your-project/
├── planning/
│   ├── roadmap.md              # High-level vision
│   ├── current-sprint.md       # Active sprint
│   └── completed-sprints/      # Historical record
├── tasks/
│   ├── backlog/               # Unscheduled tasks
│   └── week1/                 # Organized by sprint
└── docs/planning/             # Planning system docs
```

### Workflow

1. **Monday**: Plan sprint, select tasks
2. **Daily**: Work on tasks, update progress
3. **Friday**: Sprint review, create summary

## 🔧 Configuration

Edit `.planner-config.yml` to customize:

```yaml
repository:
  owner: "your-org"
  name: "your-project"
  
project:
  number: 1  # GitHub Project number
  
paths:
  planning: "planning/"
  tasks: "tasks/"
```

## 📚 Documentation

- **[Vision & Philosophy](VISION.md)** - Why this exists and how it should work
- [Complete Planning System Guide](docs/PLANNING_SYSTEM.md)
- [Daily Workflow Reference](docs/WORKFLOW_GUIDE.md)
- [Automation & Scripts](docs/AUTOMATION_GUIDE.md)
- [GitHub Setup](docs/GITHUB_SETUP.md)
- [Structure Overview](STRUCTURE.md)

## 🤝 Contributing

This planning system was extracted from multiple production projects:
- **smartkeys-v2** - Core planning system and scripts
- **mnemoverse-arch** - Extended templates and categorization

Contributions welcome! See issues for planned improvements.

## 📄 License

MIT License - see LICENSE file

## 🎯 Use Cases

- Solo developer project management
- Small team sprint planning (2-5 people)
- **Hybrid human-AI team workflows**
- Open source project organization
- Documentation-first development
- Unified context for business + tech + design teams

## 🚨 Requirements

- Git
- Bash 4.0+ (for scripts)
- Python 3.8+ (for automation scripts)
- GitHub CLI `gh` (optional, for GitHub integration)

## ⚡️ Philosophy

**Simple over complex**: Plain text files over databases
**Visible over hidden**: Git history over black boxes
**Flexible over rigid**: Adapt to your workflow
**Local-first**: Works offline, sync when ready
**Git-native**: Everything in Git, minimal external tools
**Automation-first**: Scripts and hooks do the boring work

> 📖 **Read the full vision**: [VISION.md](VISION.md) explains why we built this and how hybrid teams (humans + AI) can work together in a shared, version-controlled context.

---

**Start planning smarter, not harder.**
