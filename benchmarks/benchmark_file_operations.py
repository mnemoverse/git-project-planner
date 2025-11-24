#!/usr/bin/env python3
"""
Benchmark for file operations (parsing, validation, I/O).
"""

import sys
import os
from pathlib import Path

# Add parent directory to path to import benchmark_utils
sys.path.insert(0, str(Path(__file__).parent))

from benchmark_utils import BenchmarkRunner
import frontmatter
import yaml


def benchmark_file_operations():
    """Benchmark file parsing and validation operations."""
    runner = BenchmarkRunner(
        "file_operations",
        "Benchmarks for file I/O, parsing, and validation"
    )
    
    # Setup test fixtures
    fixtures_dir = Path(__file__).parent / "fixtures" / "sample-tasks"
    fixtures_dir.mkdir(parents=True, exist_ok=True)
    
    # Create sample task files if they don't exist
    sample_tasks = []
    for i in range(1, 51):  # 50 sample files
        task_file = fixtures_dir / f"TASK-{i:03d}-sample-task.md"
        if not task_file.exists():
            content = f"""---
task_id: TASK-{i:03d}
title: Sample Task {i}
status: backlog
priority: medium
estimate: 4
tags: [test, benchmark]
---

# TASK-{i:03d}: Sample Task {i}

## Context
This is a sample task for benchmarking purposes.

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes
Some technical details here.
"""
            task_file.write_text(content)
        sample_tasks.append(task_file)
    
    print(f"📊 Benchmarking file operations with {len(sample_tasks)} files...")
    
    # Benchmark 1: Reading files
    runner.start_timer("read_files")
    for task_file in sample_tasks:
        with open(task_file, 'r') as f:
            content = f.read()
    runner.stop_timer("read_files")
    
    # Benchmark 2: Parsing frontmatter
    runner.start_timer("parse_frontmatter")
    for task_file in sample_tasks:
        post = frontmatter.load(task_file)
        metadata = post.metadata
        content = post.content
    runner.stop_timer("parse_frontmatter")
    
    # Benchmark 3: Validating task structure
    runner.start_timer("validate_structure")
    valid_count = 0
    for task_file in sample_tasks:
        post = frontmatter.load(task_file)
        # Check required fields
        required_fields = ['task_id', 'title', 'status', 'priority']
        if all(field in post.metadata for field in required_fields):
            valid_count += 1
    runner.stop_timer("validate_structure")
    
    runner.record_metric("files_processed", len(sample_tasks), "files")
    runner.record_metric("valid_files", valid_count, "files")
    runner.record_metric("files_per_second", 
                        len(sample_tasks) / runner.results["operations"]["parse_frontmatter"]["elapsed_time"],
                        "files/s")
    
    # Benchmark 4: Writing files
    output_dir = Path(__file__).parent / "fixtures" / "output"
    output_dir.mkdir(parents=True, exist_ok=True)
    
    runner.start_timer("write_files")
    for i, task_file in enumerate(sample_tasks[:10]):  # Write 10 files
        post = frontmatter.load(task_file)
        output_file = output_dir / f"output_{i:03d}.md"
        with open(output_file, 'w') as f:
            f.write(frontmatter.dumps(post))
    runner.stop_timer("write_files")
    
    # Print and save results
    runner.print_summary()
    runner.save_results()
    
    return runner.results


if __name__ == "__main__":
    try:
        benchmark_file_operations()
        print("✅ File operations benchmark completed successfully")
    except Exception as e:
        print(f"❌ Benchmark failed: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
