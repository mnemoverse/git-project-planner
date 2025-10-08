#!/usr/bin/env bash
set -euo pipefail

# Validate all files locally before commit/push
# This script runs the same checks as CI

echo "🔍 Running validation checks..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

failed=0

# Function to report check status
check_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
        ((failed++))
    fi
}

# 1. Check YAML files
echo "📄 Validating YAML files..."
if command -v yamllint &> /dev/null; then
    yamllint .planner-config.yml .github/workflows/*.yml 2>/dev/null || true
    check_status $? "YAML validation"
else
    echo -e "${YELLOW}⚠️  yamllint not installed, skipping${NC}"
fi

# 2. Check Markdown files
echo "📝 Validating Markdown files..."
if command -v markdownlint &> /dev/null; then
    markdownlint docs/*.md examples/**/*.md README.md *.md 2>/dev/null || true
    check_status $? "Markdown linting"
else
    echo -e "${YELLOW}⚠️  markdownlint not installed, skipping${NC}"
fi

# 3. Check shell scripts
echo "🐚 Validating shell scripts..."
if command -v shellcheck &> /dev/null; then
    find scripts -name "*.sh" -exec shellcheck -x {} \; 2>/dev/null || true
    check_status $? "Shell script linting"
else
    echo -e "${YELLOW}⚠️  shellcheck not installed, skipping${NC}"
fi

# 4. Check Python scripts syntax
echo "🐍 Validating Python scripts..."
python_failed=0
for file in scripts/*.py; do
    if [ -f "$file" ]; then
        if ! python3 -m py_compile "$file" 2>/dev/null; then
            python_failed=1
        fi
    fi
done
check_status $python_failed "Python syntax"

# 5. Verify scripts are executable
echo "🔐 Checking script permissions..."
perm_failed=0
while IFS= read -r -d '' file; do
    if [ ! -x "$file" ]; then
        echo "  Missing executable: $file"
        perm_failed=1
    fi
done < <(find scripts -name "*.sh" -print0)
check_status $perm_failed "Script permissions"

# 6. Check for large files
echo "📦 Checking file sizes..."
large_files=$(find . -type f -size +500k ! -path "./.git/*" ! -path "./node_modules/*" 2>/dev/null || true)
if [ -n "$large_files" ]; then
    echo -e "${RED}❌ Large files found:${NC}"
    echo "$large_files"
    ((failed++))
else
    echo -e "${GREEN}✅ No large files${NC}"
fi

# 7. Check task naming convention
echo "📋 Validating task naming..."
task_failed=0
while IFS= read -r -d '' file; do
    basename=$(basename "$file")
    if [[ ! "$basename" =~ ^TASK-[0-9]+-.*\.md$ ]]; then
        echo "  Invalid task name: $basename"
        task_failed=1
    fi
done < <(find examples/tasks -name "*.md" -print0 2>/dev/null || true)
check_status $task_failed "Task naming convention"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ $failed check(s) failed${NC}"
    echo ""
    echo "💡 Tips:"
    echo "   - Install missing tools: pip install yamllint markdownlint-cli"
    echo "   - Run 'pre-commit run --all-files' to auto-fix some issues"
    echo "   - Check individual tool output above for details"
    exit 1
fi
