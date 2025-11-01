#!/usr/bin/env python3
"""
Benchmark utilities for Git Project Planner performance testing.
Provides common helpers for running and recording benchmarks.
"""

import json
import time
import os
import sys
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any, Optional
import tracemalloc


class BenchmarkRunner:
    """Helper class for running and recording benchmarks."""
    
    def __init__(self, name: str, description: str = ""):
        self.name = name
        self.description = description
        self.results: Dict[str, Any] = {
            "name": name,
            "description": description,
            "timestamp": datetime.now().isoformat(),
            "operations": {},
            "summary": {}
        }
        self.timers: Dict[str, float] = {}
        self.memory_snapshots: Dict[str, Any] = {}
        
    def start_timer(self, operation: str):
        """Start timing an operation."""
        self.timers[operation] = time.perf_counter()
        
        # Start memory tracking
        if operation not in self.memory_snapshots:
            tracemalloc.start()
            self.memory_snapshots[operation] = {"start": tracemalloc.take_snapshot()}
    
    def stop_timer(self, operation: str) -> float:
        """Stop timing an operation and return elapsed time."""
        if operation not in self.timers:
            raise ValueError(f"Timer '{operation}' was not started")
        
        elapsed = time.perf_counter() - self.timers[operation]
        
        # Stop memory tracking
        if operation in self.memory_snapshots:
            self.memory_snapshots[operation]["end"] = tracemalloc.take_snapshot()
            tracemalloc.stop()
            
            # Calculate memory usage
            snapshot_start = self.memory_snapshots[operation]["start"]
            snapshot_end = self.memory_snapshots[operation]["end"]
            top_stats = snapshot_end.compare_to(snapshot_start, 'lineno')
            
            total_memory = sum(stat.size_diff for stat in top_stats) / 1024 / 1024  # MB
            self.results["operations"][operation] = {
                "elapsed_time": elapsed,
                "memory_mb": round(total_memory, 2)
            }
        else:
            self.results["operations"][operation] = {
                "elapsed_time": elapsed,
                "memory_mb": 0
            }
        
        return elapsed
    
    def record_metric(self, metric_name: str, value: float, unit: str = ""):
        """Record a custom metric."""
        if "metrics" not in self.results:
            self.results["metrics"] = {}
        self.results["metrics"][metric_name] = {
            "value": value,
            "unit": unit
        }
    
    def save_results(self, output_dir: str = "benchmarks/results"):
        """Save benchmark results to JSON file."""
        output_path = Path(output_dir)
        output_path.mkdir(parents=True, exist_ok=True)
        
        # Calculate summary statistics
        if self.results["operations"]:
            times = [op["elapsed_time"] for op in self.results["operations"].values()]
            memories = [op["memory_mb"] for op in self.results["operations"].values()]
            
            self.results["summary"] = {
                "total_time": sum(times),
                "avg_time": sum(times) / len(times),
                "total_memory": sum(memories),
                "operations_count": len(self.results["operations"])
            }
        
        # Save to timestamped file
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"{self.name.lower().replace(' ', '_')}_{timestamp}.json"
        filepath = output_path / "history" / filename
        filepath.parent.mkdir(parents=True, exist_ok=True)
        
        with open(filepath, 'w') as f:
            json.dump(self.results, f, indent=2)
        
        # Also save as latest
        latest_path = output_path / f"{self.name.lower().replace(' ', '_')}_latest.json"
        with open(latest_path, 'w') as f:
            json.dump(self.results, f, indent=2)
        
        print(f"✅ Benchmark results saved to {filepath}")
        return filepath
    
    def print_summary(self):
        """Print a summary of benchmark results."""
        print(f"\n{'='*60}")
        print(f"Benchmark: {self.name}")
        print(f"{'='*60}")
        
        if self.results["operations"]:
            print("\nOperations:")
            for op_name, op_data in self.results["operations"].items():
                time_str = f"{op_data['elapsed_time']:.4f}s"
                mem_str = f"{op_data['memory_mb']:.2f} MB"
                print(f"  {op_name:40s} {time_str:>12s} {mem_str:>12s}")
        
        if "metrics" in self.results and self.results["metrics"]:
            print("\nMetrics:")
            for metric_name, metric_data in self.results["metrics"].items():
                value_str = f"{metric_data['value']:.2f}"
                unit = metric_data.get('unit', '')
                print(f"  {metric_name:40s} {value_str:>12s} {unit}")
        
        if self.results["summary"]:
            print(f"\nSummary:")
            print(f"  Total Time: {self.results['summary']['total_time']:.4f}s")
            print(f"  Average Time: {self.results['summary']['avg_time']:.4f}s")
            print(f"  Total Memory: {self.results['summary']['total_memory']:.2f} MB")
            print(f"  Operations: {self.results['summary']['operations_count']}")
        
        print(f"{'='*60}\n")


def compare_with_baseline(current_results: Dict, baseline_path: str) -> Dict[str, float]:
    """Compare current results with baseline and return percentage differences."""
    if not os.path.exists(baseline_path):
        return {}
    
    with open(baseline_path, 'r') as f:
        baseline = json.load(f)
    
    comparisons = {}
    
    # Compare operation times
    for op_name, op_data in current_results.get("operations", {}).items():
        if op_name in baseline.get("operations", {}):
            baseline_time = baseline["operations"][op_name]["elapsed_time"]
            current_time = op_data["elapsed_time"]
            
            if baseline_time > 0:
                diff_percent = ((current_time - baseline_time) / baseline_time) * 100
                comparisons[op_name] = diff_percent
    
    return comparisons


def load_baseline(benchmark_name: str) -> Optional[Dict]:
    """Load baseline results for a benchmark."""
    baseline_path = Path(f"benchmarks/results/{benchmark_name.lower().replace(' ', '_')}_baseline.json")
    
    if baseline_path.exists():
        with open(baseline_path, 'r') as f:
            return json.load(f)
    
    return None


def set_as_baseline(benchmark_name: str):
    """Set the latest results as the baseline."""
    latest_path = Path(f"benchmarks/results/{benchmark_name.lower().replace(' ', '_')}_latest.json")
    baseline_path = Path(f"benchmarks/results/{benchmark_name.lower().replace(' ', '_')}_baseline.json")
    
    if latest_path.exists():
        with open(latest_path, 'r') as f:
            results = json.load(f)
        
        with open(baseline_path, 'w') as f:
            json.dump(results, f, indent=2)
        
        print(f"✅ Set baseline for {benchmark_name}")
        return True
    
    return False
