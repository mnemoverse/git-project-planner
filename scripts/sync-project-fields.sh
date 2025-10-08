#!/bin/bash
# Sync issue labels to GitHub Project fields
# Requires: GITHUB_PROJECT_ID environment variable

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_OWNER="mnemoverse"
REPO_NAME="smartkeys-v2"
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

# Get project field IDs
get_field_ids() {
    echo -e "${BLUE}Fetching project field configurations...${NC}"

    local fields=$(gh api graphql -f query="
        query {
            node(id: \"$GITHUB_PROJECT_ID\") {
                ... on ProjectV2 {
                    fields(first: 20) {
                        nodes {
                            ... on ProjectV2Field {
                                id
                                name
                            }
                            ... on ProjectV2SingleSelectField {
                                id
                                name
                                options {
                                    id
                                    name
                                }
                            }
                        }
                    }
                }
            }
        }" 2>/dev/null)

    echo "$fields"
}

# Map label to field value
map_label_to_field() {
    local label=$1
    local field_type=$2

    case "$field_type" in
        "status")
            case "$label" in
                "status:backlog") echo "Backlog" ;;
                "status:ready") echo "Ready" ;;
                "status:in-progress") echo "In Progress" ;;
                "status:review") echo "Review" ;;
                "status:done") echo "Done" ;;
                "status:blocked") echo "Blocked" ;;
                "status:cancelled") echo "Cancelled" ;;
                *) echo "" ;;
            esac
            ;;
        "priority")
            case "$label" in
                "priority:P0"|"priority:critical") echo "P0 - Critical" ;;
                "priority:P1"|"priority:high") echo "P1 - High" ;;
                "priority:P2"|"priority:medium") echo "P2 - Medium" ;;
                "priority:P3"|"priority:low") echo "P3 - Low" ;;
                *) echo "" ;;
            esac
            ;;
        "component")
            case "$label" in
                "component:core") echo "Core" ;;
                "component:platform") echo "Platform" ;;
                "component:app") echo "App" ;;
                "component:testing") echo "Testing" ;;
                "component:planning") echo "Planning" ;;
                "component:performance") echo "Performance" ;;
                "component:ai"|"component:llm") echo "AI/LLM" ;;
                "component:docs"|"component:documentation") echo "Documentation" ;;
                *) echo "" ;;
            esac
            ;;
        "sprint")
            # Extract sprint number from label
            if [[ "$label" =~ sprint:([0-9]+) ]]; then
                echo "Sprint ${BASH_REMATCH[1]}"
            else
                echo ""
            fi
            ;;
        *)
            echo ""
            ;;
    esac
}

# Update project item field
update_item_field() {
    local item_id=$1
    local field_id=$2
    local option_id=$3
    local field_name=$4
    local value_name=$5

    if [ "$DRY_RUN" = "true" ]; then
        echo -e "    ${YELLOW}[DRY RUN]${NC} Would set $field_name = $value_name"
        return
    fi

    # Update field value
    gh api graphql -f query="
        mutation {
            updateProjectV2ItemFieldValue(input: {
                projectId: \"$GITHUB_PROJECT_ID\"
                itemId: \"$item_id\"
                fieldId: \"$field_id\"
                value: {
                    singleSelectOptionId: \"$option_id\"
                }
            }) {
                projectV2Item {
                    id
                }
            }
        }" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo -e "    ${GREEN}✓ Set $field_name = $value_name${NC}"
        return 0
    else
        echo -e "    ${RED}✗ Failed to set $field_name${NC}"
        return 1
    fi
}

# Process all project items
process_project_items() {
    local field_data=$1

    echo -e "${BLUE}Processing project items...${NC}\n"

    # Get all project items with their linked issues
    local items=$(gh api graphql -f query="
        query {
            node(id: \"$GITHUB_PROJECT_ID\") {
                ... on ProjectV2 {
                    items(first: 100) {
                        nodes {
                            id
                            content {
                                ... on Issue {
                                    number
                                    title
                                    labels(first: 20) {
                                        nodes {
                                            name
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }" 2>/dev/null)

    local updated=0
    local skipped=0
    local failed=0

    # Process each item
    echo "$items" | jq -r '.data.node.items.nodes[] | @json' | while read -r item; do
        local item_data=$(echo "$item" | jq -r '.')
        local item_id=$(echo "$item_data" | jq -r '.id')
        local issue_number=$(echo "$item_data" | jq -r '.content.number // 0')
        local issue_title=$(echo "$item_data" | jq -r '.content.title // "Unknown"')
        local labels=$(echo "$item_data" | jq -r '.content.labels.nodes[].name' 2>/dev/null || echo "")

        if [ "$issue_number" = "0" ]; then
            continue
        fi

        echo -e "${BLUE}Processing issue #$issue_number: $issue_title${NC}"

        local item_updated=false

        # Check each label for field mapping
        for label in $labels; do
            # Check Status field
            local status_value=$(map_label_to_field "$label" "status")
            if [ -n "$status_value" ]; then
                local status_field_id=$(echo "$field_data" | jq -r '.data.node.fields.nodes[] | select(.name == "Status") | .id')
                local status_option_id=$(echo "$field_data" | jq -r ".data.node.fields.nodes[] | select(.name == \"Status\") | .options[] | select(.name == \"$status_value\") | .id")

                if [ -n "$status_field_id" ] && [ -n "$status_option_id" ]; then
                    update_item_field "$item_id" "$status_field_id" "$status_option_id" "Status" "$status_value"
                    item_updated=true
                fi
            fi

            # Check Priority field
            local priority_value=$(map_label_to_field "$label" "priority")
            if [ -n "$priority_value" ]; then
                local priority_field_id=$(echo "$field_data" | jq -r '.data.node.fields.nodes[] | select(.name == "Priority") | .id')
                local priority_option_id=$(echo "$field_data" | jq -r ".data.node.fields.nodes[] | select(.name == \"Priority\") | .options[] | select(.name == \"$priority_value\") | .id")

                if [ -n "$priority_field_id" ] && [ -n "$priority_option_id" ]; then
                    update_item_field "$item_id" "$priority_field_id" "$priority_option_id" "Priority" "$priority_value"
                    item_updated=true
                fi
            fi

            # Check Component field
            local component_value=$(map_label_to_field "$label" "component")
            if [ -n "$component_value" ]; then
                local component_field_id=$(echo "$field_data" | jq -r '.data.node.fields.nodes[] | select(.name == "Component") | .id')
                local component_option_id=$(echo "$field_data" | jq -r ".data.node.fields.nodes[] | select(.name == \"Component\") | .options[] | select(.name == \"$component_value\") | .id")

                if [ -n "$component_field_id" ] && [ -n "$component_option_id" ]; then
                    update_item_field "$item_id" "$component_field_id" "$component_option_id" "Component" "$component_value"
                    item_updated=true
                fi
            fi
        done

        if [ "$item_updated" = true ]; then
            ((updated++)) || true
        else
            echo -e "    ${YELLOW}⊘ No field updates needed${NC}"
            ((skipped++)) || true
        fi

        echo ""
    done

    # Summary
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Field Sync Complete${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo "  Updated: $updated items"
    echo "  Skipped: $skipped items"
    echo "  Failed:  $failed items"
    echo ""

    if [ "$DRY_RUN" = "true" ]; then
        echo -e "${YELLOW}This was a DRY RUN - no changes were made${NC}"
        echo "Run without DRY_RUN=true to apply changes"
    fi
}

# Main execution
main() {
    check_prerequisites

    if [ "$DRY_RUN" = "true" ]; then
        echo -e "${YELLOW}Running in DRY RUN mode - no changes will be made${NC}\n"
    fi

    # Get field configurations
    local field_data=$(get_field_ids)

    # Process all items
    process_project_items "$field_data"
}

# Run main function
main "$@"