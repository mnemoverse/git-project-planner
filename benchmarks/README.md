# Performance Benchmarks

This directory contains performance benchmarks for Git Project Planner scripts and operations.

## Overview

The benchmark suite measures:
- **Script execution time** - How long core scripts take to run
- **File processing performance** - Speed of parsing and validating files
- **Sync operations** - GitHub sync and update performance
- **Validation checks** - Speed of linting and checking operations

## Running Benchmarks

### Run all benchmarks
```bash
./benchmarks/run-benchmarks.sh
```

### Run specific benchmark
```bash
python3 benchmarks/benchmark_sync_tasks.py
python3 benchmarks/benchmark_validation.py
```

### Generate report
```bash
./benchmarks/generate-report.sh
```

## Benchmark Structure

```
benchmarks/
├── README.md                    # This file
├── run-benchmarks.sh           # Main benchmark runner
├── generate-report.sh          # Report generator
├── benchmark_sync_tasks.py     # Sync operations benchmark
├── benchmark_validation.py     # Validation scripts benchmark
├── benchmark_file_operations.py # File I/O benchmark
├── results/                    # Benchmark results (gitignored)
│   ├── latest.json
│   └── history/
└── fixtures/                   # Test data for benchmarks
    ├── sample-tasks/
    └── sample-planning/
```

## Interpreting Results

Benchmark results include:
- **Execution time** (seconds) - Lower is better
- **Memory usage** (MB) - Lower is better
- **Operations per second** - Higher is better
- **Comparison to baseline** - Percentage difference

### Performance Targets

| Operation | Target Time | Good | Needs Improvement |
|-----------|-------------|------|-------------------|
| Task validation | < 0.1s/file | < 0.05s | > 0.2s |
| Sync single task | < 1s | < 0.5s | > 2s |
| Full validation | < 5s | < 3s | > 10s |

## Adding New Benchmarks

1. Create a new Python file in `benchmarks/`
2. Use the `benchmark_utils.py` helper functions
3. Follow the naming convention: `benchmark_<feature>.py`
4. Add to `run-benchmarks.sh`

Example:
```python
#!/usr/bin/env python3
import time
from benchmark_utils import BenchmarkRunner

def benchmark_my_feature():
    runner = BenchmarkRunner("My Feature")
    
    runner.start_timer("operation_name")
    # Your code here
    runner.stop_timer("operation_name")
    
    runner.save_results()

if __name__ == "__main__":
    benchmark_my_feature()
```

## CI Integration

Benchmarks run automatically on pull requests via GitHub Actions.
Performance regressions > 20% will trigger a warning.

## Baseline Data

Baseline benchmarks are stored in `benchmarks/results/baseline.json` and updated quarterly.
