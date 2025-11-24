#!/usr/bin/env bash
set -euo pipefail

# Main benchmark runner script
# Runs all benchmarks and generates a report

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS_DIR="$SCRIPT_DIR/results"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   Git Project Planner - Performance Benchmarks${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo "📅 Started at: $(date)"
echo "📁 Results directory: $RESULTS_DIR"
echo ""

# Create results directory if it doesn't exist
mkdir -p "$RESULTS_DIR"
mkdir -p "$RESULTS_DIR/history"

# Check Python version
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 is required but not found${NC}"
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo "🐍 Python version: $PYTHON_VERSION"

# Install dependencies if needed
echo ""
echo "📦 Checking dependencies..."
if ! python3 -c "import frontmatter" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Installing python-frontmatter...${NC}"
    pip install python-frontmatter --quiet
fi

if ! python3 -c "import yaml" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Installing PyYAML...${NC}"
    pip install PyYAML --quiet
fi

echo -e "${GREEN}✅ Dependencies ready${NC}"
echo ""

# Array to track benchmark results
declare -a benchmark_results
failed=0

# Function to run a single benchmark
run_benchmark() {
    local benchmark_name=$1
    local benchmark_file=$2
    
    echo -e "${BLUE}▶ Running: ${benchmark_name}${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if python3 "$benchmark_file"; then
        echo -e "${GREEN}✅ ${benchmark_name} completed${NC}"
        benchmark_results+=("$benchmark_name:success")
    else
        echo -e "${RED}❌ ${benchmark_name} failed${NC}"
        benchmark_results+=("$benchmark_name:failed")
        ((failed++))
    fi
    echo ""
}

# Run benchmarks
echo -e "${BLUE}Running benchmarks...${NC}"
echo ""

run_benchmark "File Operations" "$SCRIPT_DIR/benchmark_file_operations.py"
run_benchmark "Validation Scripts" "$SCRIPT_DIR/benchmark_validation.py"
run_benchmark "Sync Tasks" "$SCRIPT_DIR/benchmark_sync_tasks.py"

# Summary
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   Benchmark Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

total_benchmarks=${#benchmark_results[@]}
successful=$((total_benchmarks - failed))

for result in "${benchmark_results[@]}"; do
    name="${result%%:*}"
    status="${result##*:}"
    if [ "$status" = "success" ]; then
        echo -e "  ${GREEN}✅${NC} $name"
    else
        echo -e "  ${RED}❌${NC} $name"
    fi
done

echo ""
echo "📊 Results:"
echo "   Total benchmarks: $total_benchmarks"
echo "   Successful: $successful"
echo "   Failed: $failed"
echo ""

# Check for baseline comparisons
echo -e "${BLUE}Comparing with baseline...${NC}"
for benchmark in "file_operations" "validation" "sync_tasks"; do
    latest_file="$RESULTS_DIR/${benchmark}_latest.json"
    baseline_file="$RESULTS_DIR/${benchmark}_baseline.json"
    
    if [ -f "$latest_file" ] && [ -f "$baseline_file" ]; then
        echo "  📈 $benchmark: Baseline comparison available"
        
        # Extract total_time from JSON files (simple grep/awk approach)
        if command -v jq &> /dev/null; then
            baseline_time=$(jq -r '.summary.total_time // 0' "$baseline_file")
            current_time=$(jq -r '.summary.total_time // 0' "$latest_file")
            
            if [ "$baseline_time" != "0" ] && [ "$baseline_time" != "null" ]; then
                diff=$(echo "scale=2; (($current_time - $baseline_time) / $baseline_time) * 100" | bc)
                if (( $(echo "$diff > 20" | bc -l) )); then
                    echo -e "     ${RED}⚠️  Performance regression: +${diff}%${NC}"
                elif (( $(echo "$diff < -20" | bc -l) )); then
                    echo -e "     ${GREEN}✨ Performance improvement: ${diff}%${NC}"
                else
                    echo -e "     ${GREEN}✅ Performance stable: ${diff}%${NC}"
                fi
            fi
        fi
    else
        echo "  ℹ️  $benchmark: No baseline (run with --set-baseline to create)"
    fi
done

echo ""
echo "📁 Results saved in: $RESULTS_DIR"
echo "📅 Completed at: $(date)"
echo ""

# Handle --set-baseline flag
if [ "${1:-}" = "--set-baseline" ]; then
    echo -e "${YELLOW}Setting current results as baseline...${NC}"
    for benchmark in "file_operations" "validation" "sync_tasks"; do
        latest_file="$RESULTS_DIR/${benchmark}_latest.json"
        baseline_file="$RESULTS_DIR/${benchmark}_baseline.json"
        if [ -f "$latest_file" ]; then
            cp "$latest_file" "$baseline_file"
            echo -e "  ${GREEN}✅${NC} Set baseline for $benchmark"
        fi
    done
    echo ""
fi

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✅ All benchmarks completed successfully!${NC}"
    exit 0
else
    echo -e "${RED}❌ $failed benchmark(s) failed${NC}"
    exit 1
fi
