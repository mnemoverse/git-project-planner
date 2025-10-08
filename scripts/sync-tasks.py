#!/usr/bin/env python3
"""
Sync task files with GitHub Issues
Maintains 1:1 relationship between task files and issues
"""

import json
import os
import subprocess
import sys
from pathlib import Path
from typing import Dict, List, Optional


BOOTSTRAP_FLAG = "SK_PLANNING_BOOTSTRAP"


def _auto_setup(force: bool = False) -> bool:
    script_dir = Path(__file__).resolve().parent
    setup_script = script_dir / "setup-venv.sh"

    if not setup_script.exists():
        print(
            "⚠️  setup-venv.sh not found. Install dependencies manually or restore the script.",
            file=sys.stderr,
        )
        return False

    cmd = ["bash", str(setup_script)]
    if force:
        cmd.append("--force")

    try:
        subprocess.run(cmd, check=True)
        return True
    except (
        subprocess.CalledProcessError
    ) as exc:  # pragma: no cover - setup failures surface to user
        print(
            f"⚠️  Failed to bootstrap planning virtualenv (exit code {exc.returncode}).",
            file=sys.stderr,
        )
        return False


def _ensure_local_venv(_allow_bootstrap: bool = True) -> None:
    """Re-exec the script inside the local virtual environment if available."""

    script_dir = Path(__file__).resolve().parent
    venv_dir = script_dir / ".venv"

    def python_path_from_venv() -> Path:
        if os.name == "nt":
            return venv_dir / "Scripts" / "python.exe"
        return venv_dir / "bin" / "python"

    if not venv_dir.exists():
        if _allow_bootstrap and os.environ.get(BOOTSTRAP_FLAG) != "created":
            if _auto_setup():
                os.environ[BOOTSTRAP_FLAG] = "created"
                _ensure_local_venv(False)
            return
        # Give the user a hint later during import errors
        return

    python_path = python_path_from_venv()

    # If already running inside the venv, nothing to do
    if Path(sys.prefix).resolve() == venv_dir.resolve() or sys.executable == str(
        python_path
    ):
        return

    if not python_path.exists():
        if _allow_bootstrap and os.environ.get(BOOTSTRAP_FLAG) != "force":
            if _auto_setup(force=True):
                os.environ[BOOTSTRAP_FLAG] = "force"
                _ensure_local_venv(False)
                return
        print(
            f"⚠️  Local virtualenv found at {venv_dir}, but python executable is missing.\n"
            "    Try rerunning setup-venv.sh --force.",
            file=sys.stderr,
        )
        return

    # Re-exec inside the virtual environment
    os.execv(str(python_path), [str(python_path), *sys.argv])


_ensure_local_venv()

try:
    import frontmatter  # type: ignore[import-not-found]
    from frontmatter import FrontmatterError  # type: ignore
except ModuleNotFoundError:  # pragma: no cover - handled by setup-venv.sh
    if os.environ.get(BOOTSTRAP_FLAG) != "deps" and _auto_setup(force=True):
        os.environ[BOOTSTRAP_FLAG] = "deps"
        os.execv(sys.executable, [sys.executable, *sys.argv])

    print(
        "Missing dependency 'python-frontmatter'.\n"
        "Run Scripts/planning/setup-venv.sh to install requirements.",
        file=sys.stderr,
    )
    sys.exit(1)
except ImportError:
    FrontmatterError = ValueError  # type: ignore[assignment]

# Configuration
REPO_OWNER = "mnemoverse"
REPO_NAME = "smartkeys-v2"
TASKS_DIR = Path(__file__).parent.parent.parent / "tasks"
DRY_RUN = "--dry-run" in sys.argv

# Task status to GitHub label mapping
STATUS_LABEL_MAP = {
    "Backlog": "status:backlog",
    "Ready": "status:ready",
    "InProgress": "status:in-progress",
    "In Progress": "status:in-progress",
    "Review": "status:review",
    "Done": "status:done",
    "Completed": "status:done",
    "Blocked": "status:blocked",
    "Cancelled": "status:cancelled",
    "Draft": "status:draft",
    "Planned": "status:planned",
    "ON_HOLD": "status:on-hold",
}

# Priority to label mapping
PRIORITY_LABEL_MAP = {
    "Critical": "priority:critical",
    "P0 - Critical": "priority:critical",
    "High": "priority:high",
    "P1 - High": "priority:high",
    "Medium": "priority:medium",
    "P2 - Medium": "priority:medium",
    "Low": "priority:low",
    "P3 - Low": "priority:low",
}


def run_gh_command(args: List[str], skip_dry_run: bool = False) -> Optional[str]:
    """Run a GitHub CLI command and return output"""
    cmd = ["gh"] + args

    # Some commands need to run even in dry-run mode (like fetching existing issues)
    if DRY_RUN and not skip_dry_run:
        print(f"[DRY RUN] Would execute: {' '.join(cmd)}")
        return None

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error running gh command: {e}")
        print(f"Error output: {e.stderr}")
        return None


def get_existing_issues() -> Dict[str, Dict]:
    """Get all existing issues for the repository (including closed)"""
    print("Fetching existing GitHub Issues (including closed)...")

    # Get BOTH open and closed issues
    all_issues = []

    # Fetch open issues (always run, even in dry-run)
    open_json = run_gh_command(
        [
            "issue",
            "list",
            "--repo",
            f"{REPO_OWNER}/{REPO_NAME}",
            "--limit",
            "1000",
            "--json",
            "number,title,body,labels,state",
        ],
        skip_dry_run=True,  # Need to fetch existing issues even in dry-run
    )

    # Fetch closed issues too (always run, even in dry-run)
    closed_json = run_gh_command(
        [
            "issue",
            "list",
            "--repo",
            f"{REPO_OWNER}/{REPO_NAME}",
            "--state",
            "closed",
            "--limit",
            "1000",
            "--json",
            "number,title,body,labels,state",
        ],
        skip_dry_run=True,  # Need to fetch existing issues even in dry-run
    )

    # Combine both sets
    if open_json:
        all_issues.extend(json.loads(open_json))
    if closed_json:
        all_issues.extend(json.loads(closed_json))

    if not all_issues:
        return {}

    issues = all_issues

    # Create mapping from task_id to issue
    issue_map = {}
    for issue in issues:
        # Extract task_id from body or title
        title = issue.get("title", "")

        # Look for task_id pattern in title or body
        import re

        match = re.search(r"(SMK|PS|SPIKE|HOTFIX)-\d{3}[A-Z]?", title)
        if match:
            task_id = match.group()
            issue_map[task_id] = issue

    print(f"Found {len(issue_map)} issues with task IDs")
    return issue_map


def get_task_files() -> List[Path]:
    """Get all valid task files"""
    skip_files = [
        "readme.md",
        "authors.md",
        "task_breakdown_stage1.md",
        "task_assignments.md",
        "week1_backlog.md",
    ]

    task_files = []
    for task_file in TASKS_DIR.rglob("*.md"):
        if task_file.name.lower() in skip_files:
            continue
        if "STATUS" in task_file.name:
            continue

        task_files.append(task_file)

    print(f"Found {len(task_files)} task files")
    return task_files


def create_issue_body(task_data: Dict, file_path: Path) -> str:
    """Create GitHub issue body from task data"""
    relative_path = file_path.relative_to(file_path.parent.parent.parent)

    body = f"""## 📋 Task Details

**Task ID**: `{task_data.get('task_id', 'N/A')}`
**Status**: {task_data.get('status', 'Unknown')}
**Priority**: {task_data.get('priority', 'Medium')}
**Estimate**: {task_data.get('estimate', 'TBD')}
**Assignee**: {task_data.get('assignee', 'Unassigned')}

## 📄 Description

{task_data.get('content', 'See task file for details.')}

## 🔗 Links

- [Task File]({relative_path})
- [Current Sprint](planning/current-sprint.md)

---
*This issue is automatically synchronized with the task file.*
"""
    return body


def sync_task_to_issue(task_file: Path, existing_issues: Dict[str, Dict]):
    """Sync a single task file with GitHub issue"""
    print(f"\nProcessing: {task_file.name}")
    try:
        with open(task_file, "r", encoding="utf-8") as f:
            post = frontmatter.load(f)

        task_id = post.metadata.get("task_id")
        if not task_id:
            print("  ⚠️ No task_id found, skipping")
            return

        title = f"{task_id}: {post.metadata.get('title', 'Untitled')}"
        status = post.metadata.get("status", "Unknown")
        priority = post.metadata.get("priority", "Medium")

        # Prepare labels
        labels: List[str] = []
        if status in STATUS_LABEL_MAP:
            labels.append(STATUS_LABEL_MAP[status])

        # Handle priority variations
        for key, label in PRIORITY_LABEL_MAP.items():
            if key in priority:
                labels.append(label)
                break

        # Add component label based on path
        if "planning-system" in str(task_file):
            labels.append("component:planning")
        elif "week1" in str(task_file):
            labels.append("sprint:1")
        elif "week2" in str(task_file):
            labels.append("sprint:2")

        # Check if issue exists
        if task_id in existing_issues:
            issue = existing_issues[task_id]
            issue_number = issue["number"]
            state = issue.get("state", "unknown")

            if state == "closed":
                print(f"  ⏭️ Skipping - Issue #{issue_number} already exists (CLOSED)")
            else:
                print(f"  ✓ Issue #{issue_number} exists (OPEN)")

                # Only update labels for open issues
                current_labels = [
                    label_info["name"] for label_info in issue.get("labels", [])
                ]
                if set(labels) != set(current_labels) and not DRY_RUN:
                    print("  📝 Updating labels...")
                    run_gh_command(
                        [
                            "issue",
                            "edit",
                            str(issue_number),
                            "--repo",
                            f"{REPO_OWNER}/{REPO_NAME}",
                            "--add-label",
                            ",".join(labels),
                        ]
                    )
        else:
            # Create new issue
            print("  📝 Creating new issue...")
            body = create_issue_body(post.metadata, task_file)

            result = run_gh_command(
                [
                    "issue",
                    "create",
                    "--repo",
                    f"{REPO_OWNER}/{REPO_NAME}",
                    "--title",
                    title,
                    "--body",
                    body,
                    "--label",
                    ",".join(labels) if labels else "task",
                ]
            )

            if result:
                print(f"  ✅ Created: {result}")
    except (OSError, ValueError, FrontmatterError) as exc:
        raise RuntimeError(f"Error reading {task_file}: {exc}") from exc


def create_labels_if_needed():
    """Ensure all required labels exist"""
    print("Ensuring labels exist...")

    all_labels = list(STATUS_LABEL_MAP.values()) + list(PRIORITY_LABEL_MAP.values())
    all_labels.extend(["component:planning", "sprint:1", "sprint:2", "task"])

    for label in set(all_labels):
        # Try to create label (will fail silently if exists)
        if not DRY_RUN:
            run_gh_command(
                [
                    "label",
                    "create",
                    label,
                    "--repo",
                    f"{REPO_OWNER}/{REPO_NAME}",
                    "--force",
                ]
            )


def main():
    print("=" * 60)
    print("Task to GitHub Issues Synchronization")
    print("=" * 60)

    if DRY_RUN:
        print("🔍 DRY RUN MODE - No changes will be made")
        print()

    # Ensure labels exist
    create_labels_if_needed()

    # Get existing issues
    existing_issues = get_existing_issues()

    # Get task files
    task_files = get_task_files()

    # Sync each task
    synced = 0
    for task_file in task_files:
        try:
            sync_task_to_issue(task_file, existing_issues)
            synced += 1
        except RuntimeError as exc:
            print(f"Error syncing {task_file}: {exc}")

    print()
    print("=" * 60)
    print(f"✅ Processed {synced}/{len(task_files)} tasks")

    if DRY_RUN:
        print("\nTo execute changes, run without --dry-run flag")


if __name__ == "__main__":
    main()
