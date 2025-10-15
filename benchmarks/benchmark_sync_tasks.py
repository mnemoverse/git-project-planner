#!/usr/bin/env python3
"""
Benchmark for task synchronization operations.
Tests the performance of sync-tasks.py and related operations.
"""

import sys
import os
import tempfile
import shutil
from pathlib import Path

# Add parent directory to path to import benchmark_utils
sys.path.insert(0, str(Path(__file__).parent))

from benchmark_utils import BenchmarkRunner
import frontmatter


def benchmark_sync_tasks():
    """Benchmark task sync operations."""
    runner = BenchmarkRunner(
        "sync_tasks",
        "Benchmarks for task synchronization and GitHub operations"
    )
    
    print("📊 Benchmarking sync operations...")
    
    # Setup test fixtures
    fixtures_dir = Path(__file__).parent / "fixtures" / "sample-tasks"
    fixtures_dir.mkdir(parents=True, exist_ok=True)
    
    # Create test task files
    task_files = []
    for i in range(1, 26):  # 25 tasks
        task_file = fixtures_dir / f"TASK-{i:03d}-sync-test.md"
        content = f"""---
task_id: TASK-{i:03d}
title: Sync Test Task {i}
status: backlog
priority: medium
estimate: 4
assignee: test-user
labels: [test, sync]
---

# TASK-{i:03d}: Sync Test Task {i}

## Description
Test task for sync benchmarking.

## Acceptance Criteria
- [ ] Test criterion 1
- [ ] Test criterion 2
"""
        task_file.write_text(content)
        task_files.append(task_file)
    
    # Benchmark 1: Parse task files
    runner.start_timer("parse_tasks")
    parsed_tasks = []
    for task_file in task_files:
        post = frontmatter.load(task_file)
        parsed_tasks.append({
            "file": task_file,
            "metadata": post.metadata,
            "content": post.content
        })
    runner.stop_timer("parse_tasks")
    
    runner.record_metric("tasks_parsed", len(parsed_tasks), "tasks")
    
    # Benchmark 2: Extract task metadata
    runner.start_timer("extract_metadata")
    task_data = []
    for task in parsed_tasks:
        metadata = task["metadata"]
        task_info = {
            "id": metadata.get("task_id", ""),
            "title": metadata.get("title", ""),
            "status": metadata.get("status", "backlog"),
            "priority": metadata.get("priority", "medium"),
            "estimate": metadata.get("estimate", 0),
            "labels": metadata.get("labels", [])
        }
        task_data.append(task_info)
    runner.stop_timer("extract_metadata")
    
    # Benchmark 3: Validate task data
    runner.start_timer("validate_tasks")
    valid_tasks = 0
    for task in task_data:
        # Check required fields
        if (task["id"] and task["title"] and 
            task["status"] and task["priority"]):
            valid_tasks += 1
    runner.stop_timer("validate_tasks")
    
    runner.record_metric("valid_tasks", valid_tasks, "tasks")
    runner.record_metric("validation_rate", 
                        (valid_tasks / len(task_data)) * 100 if task_data else 0,
                        "%")
    
    # Benchmark 4: Group tasks by status
    runner.start_timer("group_by_status")
    status_groups = {}
    for task in task_data:
        status = task["status"]
        if status not in status_groups:
            status_groups[status] = []
        status_groups[status].append(task)
    runner.stop_timer("group_by_status")
    
    runner.record_metric("status_groups", len(status_groups), "groups")
    
    # Benchmark 5: Filter and sort tasks
    runner.start_timer("filter_sort_tasks")
    high_priority = [t for t in task_data if t["priority"] == "high"]
    sorted_tasks = sorted(task_data, key=lambda t: (t["priority"], t["id"]))
    runner.stop_timer("filter_sort_tasks")
    
    # Benchmark 6: Simulate batch operations
    runner.start_timer("batch_operations")
    batch_size = 5
    batches = [task_data[i:i+batch_size] for i in range(0, len(task_data), batch_size)]
    processed_batches = 0
    for batch in batches:
        # Simulate some processing
        for task in batch:
            _ = task["id"] + " - " + task["title"]
        processed_batches += 1
    runner.stop_timer("batch_operations")
    
    runner.record_metric("batches_processed", processed_batches, "batches")
    runner.record_metric("batch_size", batch_size, "tasks/batch")
    
    # Calculate throughput
    total_time = sum(op["elapsed_time"] for op in runner.results["operations"].values())
    if total_time > 0:
        runner.record_metric("tasks_per_second", len(task_data) / total_time, "tasks/s")
    
    # Print and save results
    runner.print_summary()
    runner.save_results()
    
    return runner.results


if __name__ == "__main__":
    try:
        benchmark_sync_tasks()
        print("✅ Sync tasks benchmark completed successfully")
    except Exception as e:
        print(f"❌ Benchmark failed: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
