#!/usr/bin/env bash
# Create or update the local virtual environment for planning scripts
#
# Usage:
#   ./setup-venv.sh              # Create/update venv with default Python
#   ./setup-venv.sh --force      # Recreate venv from scratch
#   ./setup-venv.sh --python python3.11  # Use specific Python version
#
# When called from other scripts, it will be silent unless there's an error.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"
REQUIREMENTS_FILE="$SCRIPT_DIR/requirements.txt"
PYTHON_BIN=${PYTHON_BIN:-python3}
FORCE_RECREATE=false

# Detect if we're being called from another script (silent mode)
SILENT_MODE=false
if [[ "${BASH_SOURCE[0]}" != "${0}" ]] || [[ -n "${CALLED_FROM_SCRIPT:-}" ]]; then
  SILENT_MODE=true
fi

log() {
  if [[ "$SILENT_MODE" == "false" ]]; then
    echo "$@"
  fi
}

error() {
  echo "Error: $@" >&2
}

usage() {
  cat <<EOF
Usage: $(basename "$0") [options]

Create or update Python virtual environment for git-project-planner scripts.

Options:
  -p, --python PATH   Python executable to use (default: python3)
  -f, --force         Recreate the virtual environment from scratch
  -q, --quiet         Suppress output (silent mode)
  -h, --help          Show this help message

Environment variables:
  PYTHON_BIN          Override Python executable (same as --python)
  CALLED_FROM_SCRIPT  Set to enable silent mode automatically

Examples:
  $(basename "$0")                    # Quick setup with defaults
  $(basename "$0") --python python3.11  # Use specific Python version
  $(basename "$0") --force            # Force recreate if broken

The virtual environment will be created at:
  $VENV_DIR

Dependencies installed from:
  $REQUIREMENTS_FILE
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--python)
      shift
      [[ $# -gt 0 ]] || { error "Missing value for --python"; exit 1; }
      PYTHON_BIN="$1"
      ;;
    -f|--force)
      FORCE_RECREATE=true
      ;;
    -q|--quiet)
      SILENT_MODE=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      error "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
  shift
done

# Validate Python exists
if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  error "Python executable '$PYTHON_BIN' not found."
  error "Install Python 3.8+ or specify a different one with --python"
  exit 1
fi

# Check Python version (3.8+)
PYTHON_VERSION=$("$PYTHON_BIN" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
if [[ $(echo "$PYTHON_VERSION" | awk -F. '{print ($1 * 100) + $2}') -lt 308 ]]; then
  error "Python 3.8+ required, found $PYTHON_VERSION"
  exit 1
fi

log "Using Python $PYTHON_VERSION at $PYTHON_BIN"

if [[ ! -f "$REQUIREMENTS_FILE" ]]; then
  error "requirements file not found at $REQUIREMENTS_FILE"
  exit 1
fi

if [[ -d "$VENV_DIR" ]] && $FORCE_RECREATE; then
  log "Removing existing virtual environment at $VENV_DIR"
  rm -rf "$VENV_DIR"
fi

if [[ ! -d "$VENV_DIR" ]]; then
  log "Creating virtual environment at $VENV_DIR"
  "$PYTHON_BIN" -m venv "$VENV_DIR"
else
  log "Virtual environment already exists at $VENV_DIR"
fi

# Determine platform-specific activate script path
if [[ "$(uname -s)" == "Darwin" || "$(uname -s)" == "Linux" ]]; then
  ACTIVATE_SCRIPT="$VENV_DIR/bin/activate"
  PIP_BIN="$VENV_DIR/bin/pip"
  PYTHON_VENV="$VENV_DIR/bin/python"
else
  # Windows
  ACTIVATE_SCRIPT="$VENV_DIR\\Scripts\\activate"
  PIP_BIN="$VENV_DIR\\Scripts\\pip"
  PYTHON_VENV="$VENV_DIR\\Scripts\\python"
fi

if [[ ! -f "$ACTIVATE_SCRIPT" ]]; then
  error "activate script not found at $ACTIVATE_SCRIPT"
  error "Virtual environment creation may have failed"
  exit 1
fi

log "Installing dependencies from $REQUIREMENTS_FILE"
if [[ "$SILENT_MODE" == "true" ]]; then
  "$PIP_BIN" install --upgrade pip >/dev/null 2>&1
  "$PIP_BIN" install -r "$REQUIREMENTS_FILE" >/dev/null 2>&1
else
  "$PIP_BIN" install --upgrade pip
  "$PIP_BIN" install -r "$REQUIREMENTS_FILE"
fi

# Verify installation
REQUIRED_PACKAGES=(
  "yaml:PyYAML"
  "frontmatter:python-frontmatter"
  "click:click"
  "rich:rich"
)
MISSING_PACKAGES=()

for package_spec in "${REQUIRED_PACKAGES[@]}"; do
  IFS=':' read -r import_name package_name <<< "$package_spec"
  if ! "$PYTHON_VENV" -c "import $import_name" 2>/dev/null; then
    MISSING_PACKAGES+=("$package_name")
  fi
done

if [[ ${#MISSING_PACKAGES[@]} -gt 0 ]]; then
  error "Failed to install required packages: ${MISSING_PACKAGES[*]}"
  error "Try running with --force to recreate the environment"
  exit 1
fi

log ""
log "✅ Virtual environment ready!"
log ""
if [[ -f "$VENV_DIR/bin/activate" ]]; then
  log "To activate run:"
  log "  source $VENV_DIR/bin/activate"
else
  log "To activate run:"
  log "  $VENV_DIR\\Scripts\\activate"
fi
log ""
log "To use scripts without activating:"
log "  $VENV_DIR/bin/python scripts/sync-tasks.py"

exit 0
