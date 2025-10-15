# Repository Structure

Clean, minimal structure for Git Project Planner.

## 📁 Directory Layout

```
git-project-planner/
├── README.md                    # Main overview and quick start
├── LICENSE                      # MIT License
├── VISION.md                    # Philosophy for hybrid teams
├── STRUCTURE.md                 # This file - repository structure
├── CONTRIBUTING.md              # Contribution guidelines
├── CHANGELOG.md                 # Release notes and version history
├── .planner-config.yml          # Configuration template
├── .gitignore                   # Multi-language ignores
├── .pre-commit-config.yaml      # Git hooks configuration
├── .markdownlint.json           # Markdown linting rules
├── .secrets.baseline            # Secret detection baseline
│
├── .github/                     # CI/CD automation
│   └── workflows/
│       └── ci.yml              # Automated quality checks
│
├── docs/                        # Complete documentation
│   ├── PLANNING_SYSTEM.md      # System guide
│   ├── WORKFLOW_GUIDE.md       # Daily workflow reference
│   ├── AUTOMATION_GUIDE.md     # Scripts and CI/CD guide
│   ├── GITHUB_SETUP.md         # GitHub Projects setup
│   ├── GIT_HOOKS_GUIDE.md      # Pre-commit hooks guide
│   ├── USAGE_SCENARIOS.md      # Detailed usage patterns
│   └── templates/              # Task, sprint, and issue templates
│
├── scripts/                     # Automation scripts
│   ├── setup-project.sh        # Initialize in new project
│   ├── setup-hooks.sh          # Install Git hooks
│   ├── setup-venv.sh           # Python environment
│   ├── validate-all.sh         # Run all quality checks
│   ├── sync-tasks.py/.sh       # Sync to GitHub Issues
│   ├── update-sprint.sh        # Update sprint progress
│   ├── sync-project-fields.sh  # Sync GitHub Project
│   ├── link-issues-to-project.sh
│   └── requirements.txt        # Python dependencies
│
├── benchmarks/                  # Performance benchmarks
│   ├── README.md               # Benchmark documentation
│   ├── run-benchmarks.sh       # Main benchmark runner
│   ├── generate-report.sh      # Report generator
│   ├── benchmark_*.py          # Individual benchmarks
│   ├── benchmark_utils.py      # Benchmark utilities
│   ├── baseline_*.json         # Baseline performance data
│   ├── fixtures/               # Test data
│   └── results/                # Results (gitignored)
│
└── examples/                    # Universal examples
    ├── planning/               # Roadmap and sprint examples
    └── tasks/                  # Feature and bug fix examples
```

## 📊 File Counts

- **Core files**: 9 (README, LICENSE, VISION, CONTRIBUTING, CHANGELOG, etc.)
- **Configuration**: 4 files (.pre-commit-config.yaml, .markdownlint.json, .secrets.baseline, .planner-config.yml)
- **CI/CD**: 2 workflow files (.github/workflows/ci.yml, benchmark.yml)
- **Documentation**: 6 main docs + 11 templates
- **Scripts**: 10 executable + 1 support file (requirements.txt)
- **Benchmarks**: 6 benchmark scripts + 3 baseline files + documentation
- **Examples**: 5 universal examples
- **Total**: ~60 files

## 🎯 Key Files

### Must Read
1. **README.md** - Start here
2. **VISION.md** - Understand the philosophy
3. **docs/PLANNING_SYSTEM.md** - Complete guide
4. **CHANGELOG.md** - Version history and release notes

### For Setup
1. **scripts/setup-project.sh** - Initialize planning system
2. **scripts/setup-hooks.sh** - Install Git hooks (quality checks)
3. **.planner-config.yml** - Configure for your project
4. **examples/** - Copy and adapt

### For Development
1. **CONTRIBUTING.md** - Contribution guidelines
2. **docs/GIT_HOOKS_GUIDE.md** - Pre-commit hooks usage
3. **docs/AUTOMATION_GUIDE.md** - CI/CD and scripts
4. **scripts/validate-all.sh** - Run all checks locally

### For Usage
1. **docs/WORKFLOW_GUIDE.md** - Daily workflows
2. **docs/USAGE_SCENARIOS.md** - Usage patterns
3. **docs/GITHUB_SETUP.md** - GitHub Projects integration

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
