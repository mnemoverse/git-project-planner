#!/usr/bin/env python3
"""
Benchmark for validation scripts performance.
"""

import sys
import os
import subprocess
import tempfile
from pathlib import Path

# Add parent directory to path to import benchmark_utils
sys.path.insert(0, str(Path(__file__).parent))

from benchmark_utils import BenchmarkRunner


def benchmark_validation():
    """Benchmark validation script performance."""
    runner = BenchmarkRunner(
        "validation",
        "Benchmarks for validation scripts and checks"
    )
    
    repo_root = Path(__file__).parent.parent
    scripts_dir = repo_root / "scripts"
    
    print("📊 Benchmarking validation operations...")
    
    # Benchmark 1: Shell script syntax check
    runner.start_timer("shellcheck_syntax")
    shell_scripts = list(scripts_dir.glob("*.sh"))
    for script in shell_scripts:
        result = subprocess.run(
            ["bash", "-n", str(script)],
            capture_output=True,
            text=True
        )
    elapsed = runner.stop_timer("shellcheck_syntax")
    runner.record_metric("shell_scripts_checked", len(shell_scripts), "scripts")
    runner.record_metric("scripts_per_second", len(shell_scripts) / elapsed if elapsed > 0 else 0, "scripts/s")
    
    # Benchmark 2: Python script syntax check
    runner.start_timer("python_syntax")
    python_scripts = list(scripts_dir.glob("*.py"))
    for script in python_scripts:
        result = subprocess.run(
            ["python3", "-m", "py_compile", str(script)],
            capture_output=True,
            text=True
        )
    elapsed = runner.stop_timer("python_syntax")
    runner.record_metric("python_scripts_checked", len(python_scripts), "scripts")
    
    # Benchmark 3: YAML validation
    runner.start_timer("yaml_validation")
    yaml_files = [
        repo_root / ".planner-config.yml",
        repo_root / ".github" / "workflows" / "ci.yml"
    ]
    
    try:
        import yaml
        valid_yaml = 0
        for yaml_file in yaml_files:
            if yaml_file.exists():
                with open(yaml_file, 'r') as f:
                    yaml.safe_load(f)
                valid_yaml += 1
    except ImportError:
        print("⚠️  PyYAML not installed, skipping YAML validation")
        valid_yaml = 0
    
    runner.stop_timer("yaml_validation")
    runner.record_metric("yaml_files_checked", len(yaml_files), "files")
    
    # Benchmark 4: Markdown validation
    runner.start_timer("markdown_check")
    md_files = list(repo_root.glob("*.md")) + list((repo_root / "docs").glob("*.md"))
    checked_files = 0
    for md_file in md_files[:20]:  # Check first 20 files
        if md_file.exists():
            with open(md_file, 'r') as f:
                content = f.read()
                # Basic checks
                if content.strip():
                    checked_files += 1
    runner.stop_timer("markdown_check")
    runner.record_metric("markdown_files_checked", checked_files, "files")
    
    # Benchmark 5: Task naming validation
    runner.start_timer("task_naming_check")
    examples_dir = repo_root / "examples" / "tasks"
    if examples_dir.exists():
        task_files = list(examples_dir.glob("*.md"))
        valid_names = 0
        for task_file in task_files:
            # Check if filename matches TASK-XXX-*.md pattern
            import re
            if re.match(r'TASK-\d+-.*\.md', task_file.name):
                valid_names += 1
        runner.record_metric("task_files_validated", len(task_files), "files")
        runner.record_metric("valid_task_names", valid_names, "files")
    runner.stop_timer("task_naming_check")
    
    # Print and save results
    runner.print_summary()
    runner.save_results()
    
    return runner.results


if __name__ == "__main__":
    try:
        benchmark_validation()
        print("✅ Validation benchmark completed successfully")
    except Exception as e:
        print(f"❌ Benchmark failed: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
