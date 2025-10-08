#!/usr/bin/env bash
set -euo pipefail

# Setup Git hooks for git-project-planner
# This script installs pre-commit hooks automatically

echo "🔧 Setting up Git hooks..."

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not found. Please install Python 3."
    exit 1
fi

# Check if pip is available
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is required but not found. Please install pip."
    exit 1
fi

# Install pre-commit if not already installed
if ! command -v pre-commit &> /dev/null; then
    echo "📦 Installing pre-commit..."
    pip3 install --user pre-commit
    
    # Add to PATH if needed
    if ! command -v pre-commit &> /dev/null; then
        echo "⚠️  pre-commit installed but not in PATH. Add to your ~/.zshrc or ~/.bashrc:"
        echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
        exit 1
    fi
fi

# Install pre-commit hooks
echo "🔗 Installing pre-commit hooks..."
pre-commit install

# Run pre-commit on all files to check setup
echo "✅ Testing pre-commit setup..."
if pre-commit run --all-files; then
    echo "✅ Git hooks setup complete!"
else
    echo "⚠️  Some pre-commit checks failed. This is normal for first-time setup."
    echo "    Run 'pre-commit run --all-files' to see what needs fixing."
fi

echo ""
echo "📝 What's configured:"
echo "   - Trailing whitespace removal"
echo "   - End-of-file fixer"
echo "   - YAML validation"
echo "   - Large files check"
echo "   - Markdown linting"
echo "   - Shell script linting"
echo "   - Secret detection"
echo ""
echo "💡 To skip hooks temporarily: git commit --no-verify"
