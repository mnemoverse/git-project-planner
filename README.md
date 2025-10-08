# Git Project Planner

[![CI](https://github.com/mnemoverse/git-project-planner/workflows/CI/badge.svg)](https://github.com/mnemoverse/git-project-planner/actions)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](CHANGELOG.md)

A comprehensive Git-based project planning system with GitHub integration.

## 🎯 Overview

Git Project Planner is a lightweight, flexible planning system that uses Git as the source of truth while providing optional GitHub Project integration for visualization. Perfect for solo developers, small teams, and **hybrid human-AI teams** who want:

- **Simple**: Markdown files, clear structure, minimal overhead
- **Reliable**: Version-controlled planning with full history
- **Flexible**: Works with any repository, any language
- **Visual**: Optional GitHub Projects Kanban board integration
- **AI-Friendly**: Structured for AI agents to understand full context
- **Quality-First**: Pre-commit hooks and CI/CD ensure consistency

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
- **GIT_HOOKS_GUIDE.md** - Pre-commit hooks and quality checks
- **USAGE_SCENARIOS.md** - Detailed usage patterns
- **templates/** - Task, sprint, and issue templates

### Scripts (`scripts/`)
- **setup-project.sh** - Initialize planning system
- **setup-hooks.sh** - Install Git hooks
- **sync-tasks.py** - Sync tasks to GitHub Issues
- **update-sprint.sh** - Update sprint progress
- **validate-all.sh** - Run all quality checks locally
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
- ✅ **Quality checks** - Pre-commit hooks and CI/CD

## ✨ Quality & Automation

### Pre-commit Hooks

Automatic checks before every commit:
- Markdown linting
- YAML validation
- Shell script linting
- Secret detection
- Trailing whitespace removal

```bash
# Setup (one-time)
./scripts/setup-hooks.sh

# Hooks run automatically on commit
git commit -m "feat: Add new feature"
```

See [Git Hooks Guide](docs/GIT_HOOKS_GUIDE.md) for details.

### Continuous Integration

Automated validation on every PR:
- ✅ Lint all markdown, YAML, shell scripts
- ✅ Validate task naming conventions
- ✅ Check for broken links
- ✅ Test script syntax
- ✅ Security scans

See [Automation Guide](docs/AUTOMATION_GUIDE.md#-github-actions-cicd) for configuration.

### Local Validation

```bash
# Run all checks locally
./scripts/validate-all.sh

# Or use pre-commit directly
pre-commit run --all-files
```

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

Contributions welcome! This is an open-source project built for the community.

**Ways to contribute:**
- Report issues or bugs
- Suggest new features or improvements
- Submit pull requests
- Share your usage patterns
- Improve documentation

See [Issues](https://github.com/mnemoverse/git-project-planner/issues) for planned improvements and discussions.

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

## 📝 Documentation

- [Structure Overview](STRUCTURE.md) - Repository organization
- [Contributing Guidelines](CONTRIBUTING.md) - How to contribute
- [Changelog](CHANGELOG.md) - Version history and release notes
- [Complete Documentation](docs/) - All guides and templates

---

**Start planning smarter, not harder.**
