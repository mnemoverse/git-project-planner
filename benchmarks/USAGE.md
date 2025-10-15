# Benchmark Usage Examples

This document provides practical examples of using the Git Project Planner benchmarking system.

## Quick Start

### 1. Run all benchmarks
```bash
cd /path/to/git-project-planner
./benchmarks/run-benchmarks.sh
```

This will run all three benchmark suites and display results.

### 2. Set a baseline
After running benchmarks for the first time on a stable version:
```bash
./benchmarks/run-benchmarks.sh --set-baseline
```

This creates baseline files that future runs will compare against.

### 3. Generate a report
```bash
./benchmarks/generate-report.sh
```

View the report:
```bash
cat benchmarks/results/report_*.md
```

## Understanding Results

### Sample Output
```
============================================================
Benchmark: file_operations
============================================================

Operations:
  read_files                                    0.0020s      0.00 MB
  parse_frontmatter                             0.0119s      0.01 MB
  validate_structure                            0.0117s      0.00 MB
  write_files                                   0.0066s      0.01 MB

Metrics:
  files_processed                                 50.00 files
  valid_files                                     50.00 files
  files_per_second                              4196.28 files/s
============================================================
```

### Interpreting Metrics

- **Elapsed Time**: Lower is better. Target < 0.1s for most operations
- **Memory Usage**: Lower is better. Watch for memory leaks (growing over time)
- **Throughput**: Higher is better (e.g., files/s, tasks/s)

### Performance Comparison

When baseline exists:
```
Comparing with baseline...
  📈 file_operations: Baseline comparison available
     ✅ Performance stable: 0%
```

Status indicators:
- ✅ Green: < 20% change (acceptable)
- ⚠️  Yellow: > 20% regression (needs investigation)
- ✨ Green: > 20% improvement

## Advanced Usage

### Run Individual Benchmarks

For targeted performance testing:

```bash
# Test file operations only
python3 benchmarks/benchmark_file_operations.py

# Test validation scripts
python3 benchmarks/benchmark_validation.py

# Test sync operations
python3 benchmarks/benchmark_sync_tasks.py
```

### Custom Test Data

Create custom fixtures for specific scenarios:

```python
# In benchmarks/benchmark_custom.py
from benchmark_utils import BenchmarkRunner

runner = BenchmarkRunner("custom_test", "Custom scenario testing")

# Your test code here
runner.start_timer("operation")
# ... test code ...
runner.stop_timer("operation")

runner.save_results()
runner.print_summary()
```

### Continuous Integration

Benchmarks run automatically on PRs via GitHub Actions. To check CI results:

1. Open the PR on GitHub
2. Go to "Checks" tab
3. Click on "Benchmarks" workflow
4. View the benchmark results and any warnings

## Performance Optimization Workflow

### 1. Establish Baseline
```bash
# On main branch, stable version
git checkout main
./benchmarks/run-benchmarks.sh --set-baseline
```

### 2. Make Changes
```bash
git checkout -b feature/optimize-parsing
# Make your optimizations
```

### 3. Test Performance
```bash
./benchmarks/run-benchmarks.sh
```

### 4. Compare Results
Check the output for performance changes:
- Look for regression warnings (> 20%)
- Verify improvements are real
- Generate detailed report if needed

### 5. Document Changes
If you improved performance significantly:
```bash
# Update baseline if performance improved by > 20%
./benchmarks/run-benchmarks.sh --set-baseline
```

## Troubleshooting

### Issue: "Module not found" errors
```bash
# Install dependencies
pip install python-frontmatter PyYAML
```

### Issue: Benchmarks fail on first run
This is normal - test fixtures are generated on first run. Run again:
```bash
./benchmarks/run-benchmarks.sh
```

### Issue: Performance varies significantly
Performance can vary due to system load. For accurate results:
1. Close other applications
2. Run benchmarks multiple times
3. Average the results
4. Run on same hardware for comparisons

### Issue: Memory measurements seem wrong
Memory tracking uses Python's `tracemalloc`. It measures memory allocated by Python code only, not total process memory.

## Best Practices

### When to Benchmark

✅ **Do benchmark:**
- Before and after performance optimizations
- When adding new features that process files
- Quarterly for long-term performance tracking
- When investigating performance complaints

❌ **Don't benchmark:**
- After every small change (too noisy)
- On systems with high load (unreliable)
- Without baseline comparison (no context)

### Interpreting CI Results

GitHub Actions runs benchmarks automatically. If you see warnings:

1. **Check percentage**: < 10% is usually noise
2. **Review changes**: Did you add features that naturally slow things down?
3. **Profile if needed**: Use Python profilers for deep investigation
4. **Consider tradeoffs**: Sometimes correctness > speed

### Setting New Baselines

Only update baselines when:
- ✅ You've verified the performance change is real and permanent
- ✅ The change is in main/default branch
- ✅ Multiple runs confirm the results
- ❌ Never set baseline from a single noisy run
- ❌ Never set baseline with known performance bugs

## Example Scenarios

### Scenario 1: Adding a New Feature

```bash
# Before implementing
./benchmarks/run-benchmarks.sh
# Note current performance

# Implement feature
# ... code changes ...

# After implementing
./benchmarks/run-benchmarks.sh
# Check if feature impacted performance
```

### Scenario 2: Performance Optimization

```bash
# Establish baseline
git checkout main
./benchmarks/run-benchmarks.sh --set-baseline

# Create optimization branch
git checkout -b optimize/file-parsing

# Make changes
# ... optimization code ...

# Test
./benchmarks/run-benchmarks.sh
# Should show improvement vs baseline

# If improved significantly, update baseline after merge
```

### Scenario 3: Investigating Slowdown

```bash
# Run comprehensive benchmarks
./benchmarks/run-benchmarks.sh

# Generate detailed report
./benchmarks/generate-report.sh --show

# Check historical trends
ls benchmarks/results/history/
# Compare multiple runs to identify when slowdown started
```

## Additional Resources

- [Benchmark README](README.md) - Complete benchmark documentation
- [benchmark_utils.py](benchmark_utils.py) - Utility API reference
- Python's `timeit` module - For micro-benchmarking
- GitHub Actions logs - For CI benchmark results

---

*Last updated: 2025-10-15*
