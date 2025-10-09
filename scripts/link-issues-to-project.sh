#!/bin/bash
# Link all existing issues to GitHub Project
# Requires: GITHUB_PROJECT_ID environment variable

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Load configuration from .planner-config.yml
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../.planner-config.yml"

if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}Error: Configuration file not found: $CONFIG_FILE${NC}"
    echo "Please create .planner-config.yml in project root"
    exit 1
fi

# Read repository config using yq or Python
if command -v yq &> /dev/null; then
    REPO_OWNER=$(yq e '.repository.owner' "$CONFIG_FILE")
    REPO_NAME=$(yq e '.repository.name' "$CONFIG_FILE")
else
    # Fallback to Python
    REPO_OWNER=$(python3 -c "import yaml; print(yaml.safe_load(open('$CONFIG_FILE'))['repository']['owner'])" 2>/dev/null || echo "")
    REPO_NAME=$(python3 -c "import yaml; print(yaml.safe_load(open('$CONFIG_FILE'))['repository']['name'])" 2>/dev/null || echo "")
fi

if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ]; then
    echo -e "${RED}Error: Could not read repository config from $CONFIG_FILE${NC}"
    echo "Make sure 'repository.owner' and 'repository.name' are set"
    exit 1
fi

DRY_RUN=${DRY_RUN:-false}

# Check prerequisites
check_prerequisites() {
    if ! command -v gh &> /dev/null; then
        echo -e "${RED}Error: GitHub CLI (gh) is not installed${NC}"
        exit 1
    fi

    if [ -z "${GITHUB_PROJECT_ID:-}" ]; then
        echo -e "${RED}Error: GITHUB_PROJECT_ID environment variable not set${NC}"
        echo "Find your project ID in the URL when viewing the project"
        echo "It looks like: PVT_xxxxxxxxxxxx"
        echo ""
        echo "Usage: GITHUB_PROJECT_ID=PVT_xxxxxxxxxxxx $0"
        exit 1
    fi

    echo -e "${GREEN}✓ Prerequisites checked${NC}"
    echo "  Repository: $REPO_OWNER/$REPO_NAME"
    echo "  Project ID: $GITHUB_PROJECT_ID"
    echo ""
}

# Get all issues from repository
get_all_issues() {
    echo -e "${BLUE}Fetching all issues from repository...${NC}"

    # Get both open and closed issues
    local all_issues=$(gh issue list \
        --repo "$REPO_OWNER/$REPO_NAME" \
        --limit 1000 \
        --state all \
        --json number,title,state,labels)

    echo "$all_issues"
}

# Check if issue is already in project
is_issue_in_project() {
    local issue_number=$1

    # Query project items to see if issue is already linked
    local result=$(gh api graphql -f query="
        query {
            node(id: \"$GITHUB_PROJECT_ID\") {
                ... on ProjectV2 {
                    items(first: 100) {
                        nodes {
                            content {
                                ... on Issue {
                                    number
                                }
                            }
                        }
                    }
                }
            }
        }" 2>/dev/null | jq -r ".data.node.items.nodes[].content.number" | grep -w "$issue_number" || true)

    [ -n "$result" ]
}

# Add issue to project
add_issue_to_project() {
    local issue_number=$1
    local issue_title=$2

    if [ "$DRY_RUN" = "true" ]; then
        echo -e "  ${YELLOW}[DRY RUN]${NC} Would add issue #$issue_number: $issue_title"
        return
    fi

    # Get issue node ID
    local issue_id=$(gh api graphql -f query="
        query {
            repository(owner: \"$REPO_OWNER\", name: \"$REPO_NAME\") {
                issue(number: $issue_number) {
                    id
                }
            }
        }" --jq '.data.repository.issue.id')

    if [ -z "$issue_id" ]; then
        echo -e "  ${RED}✗ Failed to get ID for issue #$issue_number${NC}"
        return 1
    fi

    # Add to project
    gh api graphql -f query="
        mutation {
            addProjectV2ItemById(input: {
                projectId: \"$GITHUB_PROJECT_ID\"
                contentId: \"$issue_id\"
            }) {
                item {
                    id
                }
            }
        }" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo -e "  ${GREEN}✓ Added issue #$issue_number: $issue_title${NC}"
        return 0
    else
        echo -e "  ${RED}✗ Failed to add issue #$issue_number${NC}"
        return 1
    fi
}

# Main execution
main() {
    check_prerequisites

    if [ "$DRY_RUN" = "true" ]; then
        echo -e "${YELLOW}Running in DRY RUN mode - no changes will be made${NC}\n"
    fi

    # Get all issues
    local issues=$(get_all_issues)
    local total_issues=$(echo "$issues" | jq '. | length')

    echo -e "${BLUE}Found $total_issues issues in repository${NC}\n"

    local added=0
    local skipped=0
    local failed=0

    # Process each issue
    echo "$issues" | jq -c '.[]' | while read -r issue; do
        local number=$(echo "$issue" | jq -r '.number')
        local title=$(echo "$issue" | jq -r '.title')
        local state=$(echo "$issue" | jq -r '.state')

        # Skip if already in project
        if ! [ "$DRY_RUN" = "true" ] && is_issue_in_project "$number"; then
            echo -e "  ${YELLOW}⊘ Skipping #$number (already in project): $title${NC}"
            ((skipped++)) || true
            continue
        fi

        # Add to project
        if add_issue_to_project "$number" "$title"; then
            ((added++)) || true
        else
            ((failed++)) || true
        fi
    done

    # Summary
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Link Issues to Project Complete${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo "  Added:   $added issues"
    echo "  Skipped: $skipped issues (already in project)"
    echo "  Failed:  $failed issues"
    echo ""

    if [ "$DRY_RUN" = "true" ]; then
        echo -e "${YELLOW}This was a DRY RUN - no changes were made${NC}"
        echo "Run without DRY_RUN=true to apply changes"
    fi
}

# Run main function
main "$@"