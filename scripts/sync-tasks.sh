#!/usr/bin/env bash
# Wrapper to run sync-tasks.py with the managed planning virtual environment

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"
SETUP_SCRIPT="$SCRIPT_DIR/setup-venv.sh"

if [[ ! -f "$SETUP_SCRIPT" ]]; then
    echo "Error: setup script not found at $SETUP_SCRIPT" >&2
    exit 1
fi

run_setup() {
    bash "$SETUP_SCRIPT" "$@"
}

if [[ ! -d "$VENV_DIR" ]]; then
    echo "ℹ️  Creating planning virtual environment (first run)..."
    run_setup
fi

PYTHON_BIN="$VENV_DIR/bin/python"
if [[ ! -x "$PYTHON_BIN" ]]; then
    echo "⚠️  Virtual environment at $VENV_DIR looks corrupted. Recreating..." >&2
    run_setup --force
fi

source "$VENV_DIR/bin/activate"

exec "$PYTHON_BIN" "$SCRIPT_DIR/sync-tasks.py" "$@"