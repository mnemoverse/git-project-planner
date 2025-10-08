# Contributing to Git Project Planner

Thanks for your interest! This guide keeps things simple.

## 🚀 Quick Start

```bash
# Clone the repo
git clone https://github.com/mnemoverse/git-project-planner.git
cd git-project-planner

# Setup Git hooks
./scripts/setup-hooks.sh

# Make your changes
# ...

# Validate before committing
./scripts/validate-all.sh

# Commit (hooks run automatically)
git commit -m "feat: Your feature description"
```

## 📋 What We Accept

- **Bug fixes** - Always welcome
- **Documentation improvements** - Very welcome
- **New automation scripts** - Great, but keep them simple
- **Examples** - Real-world usage examples appreciated
- **Feature requests** - Open an issue first to discuss

## ✅ Requirements

Before submitting a PR, ensure:

1. **All checks pass**
   ```bash
   ./scripts/validate-all.sh
   ```

2. **Documentation updated** (if needed)
   - Update relevant `.md` files
   - Add examples if applicable

3. **Scripts are tested**
   - Shell scripts pass shellcheck
   - Python scripts have valid syntax
   - All scripts are executable (`chmod +x`)

4. **Commit messages follow convention**
   ```
   feat: Add new feature
   fix: Bug fix
   docs: Documentation only
   chore: Maintenance
   ```

## 🔍 Code Review Process

1. **Automated checks** run first (CI)
2. **Manual review** by maintainers
3. **Feedback** provided within 48 hours
4. **Merge** after approval

## 🎨 Coding Standards

### Markdown
- Line length: 120 characters max
- Use proper headings hierarchy
- Include examples where helpful

### Shell Scripts
- Use `#!/usr/bin/env bash`
- Include `set -euo pipefail`
- Add comments for complex logic
- Pass shellcheck with no warnings

### Python Scripts
- Python 3.11+ compatible
- Include type hints
- Add docstrings for functions
- Follow PEP 8

### YAML Files
- Use 2-space indentation
- Validate with yamllint
- Include comments for non-obvious config

## 🐛 Bug Reports

Include:
- What you expected
- What actually happened
- Steps to reproduce
- Your environment (OS, shell, Python version)

## 💡 Feature Requests

Before opening an issue:
1. Check if it already exists
2. Explain the **problem** you're solving
3. Describe your proposed solution
4. Consider if it fits the "minimal" philosophy

## 📝 Documentation

When adding features:
- Update README.md if it affects quick start
- Add entry to relevant guide in `docs/`
- Include examples in `examples/` if applicable
- Update STRUCTURE.md if adding files

## 🚫 What We Don't Want

- Complex dependencies (keep it minimal)
- Platform-specific code (without fallbacks)
- Breaking changes (without migration path)
- Untested scripts
- Overly clever code

## ⚡ Philosophy

Remember our core principles:
1. **Git is the source of truth** - No external dependencies required
2. **Minimal is better** - Don't build a "machine de Humbert"
3. **Automate the boring** - Scripts for repetitive tasks only
4. **Documentation first** - If it needs explanation, document it
5. **AI-friendly** - Keep structure clear for AI agents

## 🤝 Community

- Be respectful and constructive
- Help others in issues/discussions
- Share your use cases and examples
- Contribute to documentation

## 📜 License

By contributing, you agree your contributions will be licensed under MIT License.

## 🔗 Resources

- [Git Hooks Guide](docs/GIT_HOOKS_GUIDE.md)
- [Automation Guide](docs/AUTOMATION_GUIDE.md)
- [Workflow Guide](docs/WORKFLOW_GUIDE.md)
- [Planning System](docs/PLANNING_SYSTEM.md)

## ❓ Questions

Open an issue or discussion. We're here to help!
