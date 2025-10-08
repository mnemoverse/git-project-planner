# Git Hooks Guide

Automated quality checks for git-project-planner using Git hooks and pre-commit framework.

## 🎯 What Are Git Hooks?

Git hooks are scripts that run automatically at specific Git lifecycle events (before commit, before push, etc.). They help catch issues early and maintain code quality without manual checks.

## 🚀 Quick Setup

### Installation

```bash
# Run the setup script (recommended)
./scripts/setup-hooks.sh

# Or manually
pip install pre-commit
pre-commit install
```

### First Run

```bash
# Test on all files
pre-commit run --all-files

# Auto-fix issues where possible
pre-commit run --all-files --show-diff-on-failure
```

## ✅ Configured Checks

Our pre-commit hooks run these checks automatically:

| Check | What It Does | Auto-Fix |
|-------|--------------|----------|
| **trailing-whitespace** | Removes extra spaces at line ends | ✅ Yes |
| **end-of-file-fixer** | Ensures files end with newline | ✅ Yes |
| **check-yaml** | Validates YAML syntax | ❌ No |
| **check-added-large-files** | Blocks files >500KB | ❌ No |
| **check-merge-conflict** | Detects merge conflict markers | ❌ No |
| **mixed-line-ending** | Fixes to LF (Unix style) | ✅ Yes |
| **markdownlint** | Lints Markdown files | ✅ Partial |
| **shellcheck** | Lints shell scripts | ❌ No |
| **detect-secrets** | Finds API keys/tokens | ❌ No |

## 📝 Daily Usage

### Normal Workflow

```bash
# Just commit as usual
git add .
git commit -m "feat: Add new feature"

# Hooks run automatically
# If checks fail, commit is blocked
```

### Skipping Hooks (Emergency Only)

```bash
# Skip ALL hooks (use sparingly!)
git commit --no-verify -m "hotfix: Critical fix"

# Or use environment variable
SKIP=markdownlint git commit -m "WIP: Draft documentation"
```

### Fixing Issues

```bash
# Let pre-commit auto-fix what it can
pre-commit run --all-files

# Check what changed
git diff

# Commit the fixes
git add .
git commit -m "chore: Apply pre-commit fixes"
```

## 🔧 Configuration Files

### `.pre-commit-config.yaml`

Main configuration file. To update hooks:

```bash
# Update to latest versions
pre-commit autoupdate

# Install updated hooks
pre-commit install
```

### `.markdownlint.json`

Markdown linting rules:
- Max line length: 120 characters
- HTML allowed (for badges, etc.)
- No heading requirements

### `.secrets.baseline`

Known false positives for secret detection. To regenerate:

```bash
detect-secrets scan > .secrets.baseline
```

## 🐛 Troubleshooting

### "Command not found: pre-commit"

```bash
# Install pre-commit
pip install --user pre-commit

# Add to PATH if needed
export PATH="$HOME/.local/bin:$PATH"
```

### "Hook failed" but can't see why

```bash
# Run with verbose output
pre-commit run --all-files --verbose

# Or run specific hook
pre-commit run markdownlint --all-files
```

### Hooks too slow

```bash
# Skip specific slow hooks
SKIP=detect-secrets git commit -m "Quick fix"

# Or disable temporarily
pre-commit uninstall

# Re-enable later
pre-commit install
```

### Large files blocked

```bash
# Check file sizes
find . -type f -size +500k ! -path "./.git/*"

# Either reduce size or add exception
# Edit .pre-commit-config.yaml:
# - id: check-added-large-files
#   args: [--maxkb=1000]  # Increase limit
```

## 🎓 Advanced Usage

### Custom Hooks

Add project-specific checks to `.pre-commit-config.yaml`:

```yaml
- repo: local
  hooks:
    - id: validate-task-names
      name: Check task naming convention
      entry: ./scripts/validate-task-names.sh
      language: script
      files: tasks/.*\.md$
```

### Pre-Push Hooks

Run heavier checks before pushing:

```bash
# Create .git/hooks/pre-push
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
./scripts/validate-all.sh
EOF

chmod +x .git/hooks/pre-push
```

### CI Integration

Our GitHub Actions workflow runs the same checks:

```yaml
# .github/workflows/ci.yml
- name: Run pre-commit checks
  run: pre-commit run --all-files
```

## 💡 Best Practices

1. **Run hooks before committing**: `pre-commit run --all-files`
2. **Don't skip hooks without reason**: Creates debt
3. **Update hooks regularly**: `pre-commit autoupdate`
4. **Add exceptions carefully**: Document why in commit message
5. **Keep hooks fast**: Heavy checks go in CI, not hooks

## 🔗 Related

- [AUTOMATION_GUIDE.md](AUTOMATION_GUIDE.md) - CI/CD documentation
- [WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md) - Daily workflows
- [pre-commit.com](https://pre-commit.com) - Framework documentation

## 📊 Performance

Typical hook execution times:
- **Fast** (<1s): trailing-whitespace, end-of-file-fixer, check-yaml
- **Medium** (1-3s): markdownlint, shellcheck
- **Slow** (3-10s): detect-secrets (scans all files)

Total time for clean commit: **2-5 seconds**

---

**Questions?** Check [CONTRIBUTING.md](../CONTRIBUTING.md) or open an issue.
