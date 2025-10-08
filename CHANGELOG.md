# Changelog

All notable changes to Git Project Planner will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Pre-commit hooks configuration for automatic quality checks
- GitHub Actions CI/CD pipeline (lint, test, security)
- Comprehensive Git hooks documentation (`docs/GIT_HOOKS_GUIDE.md`)
- Automated setup script for Git hooks (`scripts/setup-hooks.sh`)
- Local validation script (`scripts/validate-all.sh`)
- Contributing guidelines (`CONTRIBUTING.md`)
- Multi-language `.gitignore` coverage
- Markdown linting configuration (`.markdownlint.json`)
- Secret detection baseline (`.secrets.baseline`)
- CI status badges in README

### Changed
- Expanded `docs/AUTOMATION_GUIDE.md` with CI/CD section
- Updated `README.md` with quality checks section
- Improved `.gitignore` for Python, Node.js, IDE files
- Updated `STRUCTURE.md` to reflect current repository state

### Removed
- `PUBLISH.md` (internal documentation, not for public use)
- `scripts/README.md` (outdated SmartKeys-specific content)
- `scripts/ROLLBACK_PLAN.md` (outdated SmartKeys-specific content)

### Fixed
- Moved `USAGE_SCENARIOS.md` to `docs/` directory

## [1.0.0] - 2025-10-08

### Added
- Initial release of Git Project Planner
- Complete planning system documentation
- GitHub Projects integration scripts
- Sprint tracking and task management
- Example templates for tasks, sprints, issues
- Python and shell automation scripts
- Configuration templates
- MIT License

### Documentation
- `README.md` - Quick start guide
- `VISION.md` - Project philosophy for hybrid teams
- `docs/PLANNING_SYSTEM.md` - Complete system guide
- `docs/WORKFLOW_GUIDE.md` - Daily workflow reference
- `docs/AUTOMATION_GUIDE.md` - Scripts documentation
- `docs/GITHUB_SETUP.md` - GitHub Projects setup
- 11 templates in `docs/templates/`

### Scripts
- `setup-project.sh` - Initialize planning system
- `setup-venv.sh` - Python environment setup
- `sync-tasks.py/sh` - Sync tasks to GitHub Issues
- `update-sprint.sh` - Update sprint progress
- `sync-project-fields.sh` - Sync GitHub Project fields
- `link-issues-to-project.sh` - Link issues to project

### Examples
- Planning roadmap and sprint examples
- Task specification examples
- Category organization examples

---

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.0.0 | 2025-10-08 | Initial public release |
| Unreleased | Current | Quality infrastructure improvements |

---

## Upgrade Guide

### From 1.0.0 to Current

1. **Update your local copy:**
   ```bash
   git pull origin main
   ```

2. **Install new Git hooks:**
   ```bash
   ./scripts/setup-hooks.sh
   ```

3. **Update dependencies (optional):**
   ```bash
   pip install --upgrade -r scripts/requirements.txt
   ```

4. **Run validation:**
   ```bash
   ./scripts/validate-all.sh
   ```

---

## Breaking Changes

### Unreleased
- None

### 1.0.0
- Initial release (no previous versions)

---

## Deprecations

### Current
- None planned

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:
- How to report bugs
- How to suggest enhancements
- Development workflow
- Code style requirements

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
