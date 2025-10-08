#!/usr/bin/env bash
# Create or update the local virtual environment for planning scripts

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"
REQUIREMENTS_FILE="$SCRIPT_DIR/requirements.txt"
PYTHON_BIN=${PYTHON_BIN:-python3}
FORCE_RECREATE=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [options]

Options:
  -p, --python PATH   Python executable to use (default: python3)
  -f, --force         Recreate the virtual environment from scratch
  -h, --help          Show this help message

Environment variables:
  PYTHON_BIN          Override Python executable (same as --python)

The virtual environment will be created under $VENV_DIR
and dependencies installed from $REQUIREMENTS_FILE.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--python)
      shift
      [[ $# -gt 0 ]] || { echo "Missing value for --python" >&2; exit 1; }
      PYTHON_BIN="$1"
      ;;
    -f|--force)
      FORCE_RECREATE=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
  shift
done

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "Error: Python executable '$PYTHON_BIN' not found." >&2
  exit 1
fi

if [[ ! -f "$REQUIREMENTS_FILE" ]]; then
  echo "Error: requirements file not found at $REQUIREMENTS_FILE" >&2
  exit 1
fi

if [[ -d "$VENV_DIR" ]] && $FORCE_RECREATE; then
  echo "Removing existing virtual environment at $VENV_DIR"
  rm -rf "$VENV_DIR"
fi

if [[ ! -d "$VENV_DIR" ]]; then
  echo "Creating virtual environment at $VENV_DIR"
  "$PYTHON_BIN" -m venv "$VENV_DIR"
else
  echo "Virtual environment already exists at $VENV_DIR"
fi

# Determine platform-specific activate script path
if [[ "$(uname -s)" == "Darwin" || "$(uname -s)" == "Linux" ]]; then
  ACTIVATE_SCRIPT="$VENV_DIR/bin/activate"
  PIP_BIN="$VENV_DIR/bin/pip"
else
  ACTIVATE_SCRIPT="$VENV_DIR\\Scripts\\activate"
  PIP_BIN="$VENV_DIR\\Scripts\\pip"
fi

if [[ ! -f "$ACTIVATE_SCRIPT" ]]; then
  echo "Error: activate script not found at $ACTIVATE_SCRIPT" >&2
  exit 1
fi

echo "Installing dependencies from $REQUIREMENTS_FILE"
"$PIP_BIN" install --upgrade pip
"$PIP_BIN" install -r "$REQUIREMENTS_FILE"

echo "Virtual environment ready. To use it run:"
if [[ -f "$VENV_DIR/bin/activate" ]]; then
  echo "  source $VENV_DIR/bin/activate"
else
  echo "  $VENV_DIR\\Scripts\\activate"
fi
