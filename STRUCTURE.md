# Repository Structure

Clean, minimal structure for Git Project Planner.

## 📁 Directory Layout

```
git-project-planner/
├── README.md                    # Main overview and quick start
├── LICENSE                      # MIT License
├── VISION.md                    # Philosophy for hybrid teams
├── USAGE_SCENARIOS.md           # 5 detailed usage patterns
├── PUBLISH.md                   # Publication instructions
├── .planner-config.yml          # Configuration template
├── .gitignore                   # Standard ignores
│
├── docs/                        # Complete documentation
│   ├── PLANNING_SYSTEM.md      # System guide (860 lines)
│   ├── WORKFLOW_GUIDE.md       # Daily workflow reference
│   ├── AUTOMATION_GUIDE.md     # Scripts and CI/CD
│   ├── GITHUB_SETUP.md         # GitHub Projects setup
│   └── templates/              # 11 templates for tasks/sprints/issues
│
├── scripts/                     # 7 automation scripts
│   ├── setup-project.sh        # Initialize in new project
│   ├── sync-tasks.py/.sh       # Sync to GitHub Issues
│   ├── update-sprint.sh        # Update sprint progress
│   ├── sync-project-fields.sh  # Sync GitHub Project
│   ├── link-issues-to-project.sh
│   ├── setup-venv.sh           # Python environment
│   └── requirements.txt
│
└── examples/                    # Universal examples
    ├── planning/               # Roadmap and sprint examples
    └── tasks/                  # Feature and bug fix examples
```

## 📊 File Counts

- **Core files**: 7 (README, LICENSE, VISION, etc.)
- **Documentation**: 4 main docs + 11 templates
- **Scripts**: 7 executable + 2 support files
- **Examples**: 5 universal examples
- **Total**: ~40 files

## 🎯 Key Files

### Must Read
1. **README.md** - Start here
2. **VISION.md** - Understand the philosophy
3. **docs/PLANNING_SYSTEM.md** - Complete guide

### For Setup
1. **scripts/setup-project.sh** - Initialize
2. **.planner-config.yml** - Configure
3. **examples/** - Copy and adapt

### For Usage
1. **docs/WORKFLOW_GUIDE.md** - Daily workflows
2. **docs/AUTOMATION_GUIDE.md** - Scripts
3. **USAGE_SCENARIOS.md** - Patterns

## 🔧 File Purposes

| File/Directory | Purpose | When to Use |
|----------------|---------|-------------|
| `README.md` | Overview | First time setup |
| `VISION.md` | Philosophy | Understand "why" |
| `docs/` | Complete docs | Deep dive |
| `scripts/` | Automation | Daily usage |
| `examples/` | Templates | Starting new |
| `.planner-config.yml` | Settings | Customization |

## 📝 What Goes Where

### In Your Project (after setup)

```
your-project/
├── planning/                    # Created by setup-project.sh
│   ├── roadmap.md
│   ├── current-sprint.md
│   └── completed-sprints/
├── tasks/                       # Created by setup-project.sh
│   ├── backlog/
│   └── week1/, week2/, ...
├── .planner-config.yml          # Copied from template
└── .planner/                    # If using submodule
    └── [all planner files]
```

### Not Included (You Add)

- Your actual tasks and sprint plans
- Project-specific configuration
- Custom scripts or integrations
- Team conventions

## 🚀 Getting Started

1. **Copy** this repository to your project
2. **Run** `./scripts/setup-project.sh`
3. **Customize** `.planner-config.yml`
4. **Start** planning in `planning/current-sprint.md`

See [README.md](README.md) for detailed instructions.

---

**Version**: 1.0  
**Last Updated**: 2024-10-08  
**License**: MIT
