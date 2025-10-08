#!/bin/bash
# Update sprint progress automatically

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Project paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PLANNING_DIR="$PROJECT_ROOT/planning"
CURRENT_SPRINT="$PLANNING_DIR/current-sprint.md"

# Function to count tasks
count_tasks() {
    local file="$1"
    local pattern="$2"
    grep -c "$pattern" "$file" 2>/dev/null || echo 0
}

# Function to calculate percentage
calc_percentage() {
    local completed="$1"
    local total="$2"
    if [ "$total" -eq 0 ]; then
        echo 0
    else
        echo $((completed * 100 / total))
    fi
}

# Function to update progress section
update_progress() {
    local file="$1"

    # Count tasks
    local completed=$(count_tasks "$file" "^- \[x\]")
    local in_progress=$(count_tasks "$file" "^- \[ \].*%")
    local ready=$(count_tasks "$file" "^- \[ \]")
    local total=$((completed + ready))

    # Calculate progress
    local percentage=$(calc_percentage "$completed" "$total")

    # Count blockers (look for actual blocker section content, not just the emoji)
    local blockers=0
    if grep -q "## Blockers" "$file"; then
        # Check if there's actual content after Blockers section (not just "None")
        local blocker_content=$(sed -n '/^## Blockers$/,/^##/p' "$file" | grep -v "^##" | grep -v "^None" | grep -v "^$" | wc -l)
        blockers=$((blocker_content))
    fi

    # Determine status
    local status="On Track"
    if [ "$blockers" -gt 0 ]; then
        status="Has Blockers"
    elif [ "$percentage" -lt 30 ] && [ "$(date +%u)" -gt 3 ]; then
        status="At Risk"
    fi

    # Create progress section
    local progress_text="## Progress
📊 Completed: ${completed}/${total} tasks (${percentage}%)
⏱️ Hours: [Calculate manually]
🔥 Blockers: ${blockers}
🚀 Status: ${status}"

    # Update file
    # Use temporary file to avoid sed issues
    local temp_file="${file}.tmp"

    # Read file up to Progress section
    awk '/^## Progress$/{exit}1' "$file" > "$temp_file"

    # Add new progress section
    echo "$progress_text" >> "$temp_file"
    echo "" >> "$temp_file"

    # Add rest of file after Progress
    awk '/^## Daily Notes$/,0' "$file" >> "$temp_file" 2>/dev/null || true

    # Replace original file
    mv "$temp_file" "$file"

    echo -e "${GREEN}✓${NC} Updated progress: ${completed}/${total} tasks (${percentage}%)"
}

# Function to archive completed sprint
archive_sprint() {
    local sprint_file="$1"
    local sprint_number=$(grep -o "Sprint [0-9]*" "$sprint_file" | head -1 | awk '{print $2}')
    local archive_dir="$PLANNING_DIR/completed-sprints"
    local archive_file="$archive_dir/sprint-${sprint_number}-summary.md"

    mkdir -p "$archive_dir"

    # Copy to archive
    cp "$sprint_file" "$archive_file"

    echo -e "${GREEN}✓${NC} Archived to: $archive_file"
}

# Main execution
main() {
    echo -e "${BLUE}=== Sprint Progress Update ===${NC}"
    echo "Project: $PROJECT_ROOT"
    echo "Sprint: $CURRENT_SPRINT"
    echo ""

    if [ ! -f "$CURRENT_SPRINT" ]; then
        echo -e "${RED}✗${NC} Current sprint file not found: $CURRENT_SPRINT"
        exit 1
    fi

    # Check if sprint is complete
    local total=$(count_tasks "$CURRENT_SPRINT" "^- \[")
    local completed=$(count_tasks "$CURRENT_SPRINT" "^- \[x\]")

    if [ "$total" -gt 0 ] && [ "$completed" -eq "$total" ]; then
        echo -e "${YELLOW}Sprint appears complete!${NC}"
        read -p "Archive this sprint? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            archive_sprint "$CURRENT_SPRINT"
            echo -e "${GREEN}✓${NC} Sprint archived. Create new sprint file."
        fi
    else
        # Update progress
        update_progress "$CURRENT_SPRINT"

        # Show summary
        echo ""
        echo -e "${BLUE}Current Sprint Status:${NC}"
        grep "^📊" "$CURRENT_SPRINT"
        grep "^🔥" "$CURRENT_SPRINT"
    fi

    # Git status reminder
    if git diff --quiet "$CURRENT_SPRINT" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} No changes to commit"
    else
        echo ""
        echo -e "${YELLOW}Remember to commit changes:${NC}"
        echo "  git add planning/current-sprint.md"
        echo "  git commit -m \"chore: Update sprint progress\""
    fi
}

# Handle arguments
case "${1:-}" in
    -h|--help)
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  -h, --help    Show this help message"
        echo "  -a, --auto    Auto-commit changes (no prompt)"
        echo ""
        echo "Updates the current sprint progress automatically."
        exit 0
        ;;
    -a|--auto)
        AUTO_COMMIT=true
        ;;
esac

# Run main function
main

# Auto-commit if requested
if [ "${AUTO_COMMIT:-false}" = "true" ] && ! git diff --quiet "$CURRENT_SPRINT" 2>/dev/null; then
    git add "$CURRENT_SPRINT"
    git commit -m "chore: Update sprint progress (automated)"
    echo -e "${GREEN}✓${NC} Changes committed automatically"
fi