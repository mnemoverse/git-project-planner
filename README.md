# Git Project Planner

[![CI](https://github.com/mnemoverse/git-project-planner/workflows/CI/badge.svg)](https://github.com/mnemoverse/git-project-planner/actions)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](CHANGELOG.md)

**Methodology and tools for Git-based project planning with optional GitHub Projects integration.**

## 🎯 What is this?

**Git Project Planner** is a Git-based planning system that collects best practices from real projects (SmartKeys, Mnemoverse, Gitea API) into a single portable package.

### Who is it for?
- ✅ **Solo developers** — structured planning without overhead
- ✅ **Small teams (2-5 people)** — simple coordination through Git
- ✅ **Hybrid teams (humans + AI)** — unified context for all participants
- ✅ **Open Source projects** — transparent public planning

### Why does it exist?
Solves the main problem: **planning and code desynchronization**.

**Before:**
```
Planning → Jira/Notion/Asana (separate)
Code → GitHub (separate)
Documentation → Confluence (separate)
Decisions → Slack (lost)
```

**After:**
```
Git Repository = Single Source of Truth
    ├── Code (what we build)
    ├── Plans (why we build it)
    ├── Tasks (how we build it)
    └── History (why we decided this way)
```

### How does it work?

**3 levels of use:**

1. **Methodology** (philosophy) — read [VISION.md](VISION.md)
2. **Tools** (scripts, hooks, CI/CD) — copy to your project
3. **Templates** (tasks, sprints, roadmaps) — adapt to your needs

> 💡 **Philosophy**: Everything in Git. Minimal external dependencies. Automate everything possible.

## 🚀 Quick Start

**New here?** → Read **[QUICKSTART.md](QUICKSTART.md)** for a step-by-step guide with real-world examples!

### TL;DR: 3 integration options

#### Option 1: Git Submodule (recommended for active projects)

```bash
cd /path/to/your-project
git submodule add https://github.com/mnemoverse/git-project-planner .planner
cp .planner/.planner-config.yml .
# Edit .planner-config.yml with your repo details
.planner/scripts/setup-venv.sh
```

**Pros**: Stay in sync with updates, clean separation  
**Real example**: [SmartKeys v2 integration](QUICKSTART.md#real-world-example-smartkeys-v2-integration) (15 minutes, 59 tasks)

#### Option 2: Direct Copy (for heavy customization)

```bash
git clone https://github.com/mnemoverse/git-project-planner.git /tmp/planner
cp -r /tmp/planner/{scripts,docs,examples} /path/to/your-project/.planner/
cp /tmp/planner/.planner-config.yml /path/to/your-project/
# Edit and customize
```

**Pros**: Full control, no submodule complexity  
**Cons**: Manual updates

#### Option 3: Fork (for organizations)

```bash
# Fork on GitHub → adapt to your needs
gh repo fork mnemoverse/git-project-planner --clone
```

**Details for all options:** [docs/USAGE_SCENARIOS.md](docs/USAGE_SCENARIOS.md)

---

## 📦 What's inside?

### 1. Methodology and philosophy

- **[VISION.md](VISION.md)** — why this exists, how it works with hybrid teams
- **[docs/PLANNING_SYSTEM.md](docs/PLANNING_SYSTEM.md)** — complete planning system description
- **[docs/WORKFLOW_GUIDE.md](docs/WORKFLOW_GUIDE.md)** — daily processes and commands

### 2. Automation

#### Pre-commit hooks (9 checks)
```bash
./scripts/setup-hooks.sh  # installation

# Automatically checks before commit:
# ✓ Markdown formatting
# ✓ YAML syntax
# ✓ Shell script linting (shellcheck)
# ✓ Secret detection
# ✓ Trailing whitespace
```

#### CI/CD (GitHub Actions)
```yaml
# Automatically runs on PR:
# ✓ Linting all files
# ✓ Task naming validation
# ✓ Link checking
# ✓ Security scanning
```

#### Automation scripts
```bash
./scripts/sync-tasks.sh          # → sync with GitHub Issues
./scripts/update-sprint.sh       # → update sprint progress
./scripts/validate-all.sh        # → run all checks locally
./scripts/link-issues-to-project.sh  # → link to GitHub Project
```

**Details:** [docs/AUTOMATION_GUIDE.md](docs/AUTOMATION_GUIDE.md)

### 3. Templates

```
docs/templates/
├── TASK_TEMPLATE.md        # Task specification
├── SPRINT_TEMPLATE.md      # Sprint plan
├── MILESTONE_TEMPLATE.md   # Milestone
└── ISSUE_TEMPLATE.md       # GitHub Issue
```

### 4. Examples

```
examples/
├── planning/               # Roadmap and sprint examples
└── tasks/                  # Feature/bug/tech debt task examples
```

---

## 🎯 Key Approaches

### 1. Git-Native First
**Principle:** If it can live in Git — it should live in Git.

```
✅ In Git:                   ⚠️ Optional (with links):
• Tasks (tasks/*.md)        • Figma (link in task)
• Sprints (planning/*.md)   • Slack (summary in task)
• Roadmap                   • Zoom (link + transcript)
• Decisions and context     
• Change history            ❌ External only:
                            • Real-time chat
                            • Synchronous meetings
```

### 2. Automation First
**Principle:** Humans shouldn't do what machines can do.

```
Layer 1: Git Hooks           → auto-formatting, validation
Layer 2: CI/CD               → sync, reports, notifications  
Layer 3: Scripts (manual)    → sprint planning, retrospectives
```

### 3. Minimal External Connectors
**Principle:** Use external tools only when they provide unique value.

```
CORE (required):        Git + GitHub
OPTIONAL (sparingly):   Slack, Figma, CI/CD
AVOID:                  Jira, Confluence, Notion, etc.
```

### 4. Structured for AI Agents
**Principle:** AI agents see the same context as humans.

```markdown
<!-- Frontmatter for machine parsing -->
---
task_id: "TASK-001"
status: "in-progress"
priority: "high"
---

# TASK-001: Feature Name

<!-- Markdown for humans -->
## Context
Why this task matters...
```

**Details:** [VISION.md](VISION.md)

---

## 📚 Complete Documentation

| Document                                                 | Purpose               | Read when             |
| -------------------------------------------------------- | --------------------- | --------------------- |
| **[VISION.md](VISION.md)**                               | Philosophy and "why"  | Before starting       |
| **[STRUCTURE.md](STRUCTURE.md)**                         | Repository structure  | Navigating files      |
| **[docs/PLANNING_SYSTEM.md](docs/PLANNING_SYSTEM.md)**   | Complete system guide | Setting up processes  |
| **[docs/WORKFLOW_GUIDE.md](docs/WORKFLOW_GUIDE.md)**     | Daily commands        | Quick reference       |
| **[docs/AUTOMATION_GUIDE.md](docs/AUTOMATION_GUIDE.md)** | Scripts and CI/CD     | Setting up automation |
| **[docs/GITHUB_SETUP.md](docs/GITHUB_SETUP.md)**         | GitHub Projects       | GitHub integration    |
| **[docs/GIT_HOOKS_GUIDE.md](docs/GIT_HOOKS_GUIDE.md)**   | Pre-commit hooks      | Quality setup         |
| **[docs/USAGE_SCENARIOS.md](docs/USAGE_SCENARIOS.md)**   | Usage scenarios       | Choosing approach     |
| **[CONTRIBUTING.md](CONTRIBUTING.md)**                   | How to contribute     | Before PR             |
| **[CHANGELOG.md](CHANGELOG.md)**                         | Version history       | Updates               |

---

## 🛠️ Requirements

**Minimum:**
- Git
- Bash 4.0+

**Optional (for full functionality):**
- Python 3.8+ (for automation scripts)
- GitHub CLI `gh` (for GitHub sync)
- pre-commit framework (for Git hooks)

---

## 🎪 What's unique?

1. **Collected from real projects** — not theory, but working practices
2. **Hybrid teams (humans + AI)** — structure understandable by both humans and AI agents
3. **Complete solution** — methodology + tools + templates
4. **Portable** — copy to any project in 5 minutes
5. **Quality-first** — built-in checks and automation
6. **Git-native** — works offline, syncs through Git

---

## 🤝 License and Contribution

**License:** MIT — use freely in any projects.

**Contributions welcome:**
- Issues with bugs or ideas
- Pull requests with improvements
- Documentation and examples
- Sharing your practices

**[Contributing Guide](CONTRIBUTING.md)** • **[Issues](https://github.com/mnemoverse/git-project-planner/issues)**

---

**Start planning smarter, not harder.** 🚀
