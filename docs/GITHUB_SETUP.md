# GitHub Project Manual Setup Guide

## Prerequisites

1. GitHub account with access to `mnemoverse/smartkeys-v2` repository
2. Permission to create projects in the organization
3. GitHub CLI installed and authenticated (for post-setup automation)

## Manual Project Creation Steps

### Step 1: Create the Project

1. Navigate to https://github.com/mnemoverse
2. Click on "Projects" tab
3. Click "New project" button
4. Select "Board" template (for Kanban-style workflow)
5. Name it: **SmartKeys v2 Development**
6. Description: **AI-enhanced keyboard correction system development tracker**
7. Visibility: Set according to your preference (Public/Private)
8. Click "Create project"

### Step 2: Configure Columns

Create the following columns in order:

1. **📋 Backlog** - Tasks waiting to be scheduled
2. **🔄 Ready** - Sprint-ready tasks
3. **🚀 In Progress** - Active development
4. **👀 Review** - Code review/testing
5. **✅ Done** - Completed tasks

### Step 3: Add Custom Fields

Go to Project Settings → Custom Fields and add:

#### Status Field
- **Type**: Single select
- **Name**: Status
- **Options**:
  - Backlog
  - Ready
  - In Progress
  - Review
  - Done
  - Blocked
  - Cancelled

#### Priority Field
- **Type**: Single select
- **Name**: Priority
- **Options**:
  - P0 - Critical
  - P1 - High
  - P2 - Medium
  - P3 - Low

#### Component Field
- **Type**: Single select
- **Name**: Component
- **Options**:
  - Core
  - Platform
  - App
  - Testing
  - Planning
  - Performance
  - AI/LLM
  - Documentation

#### Sprint Field
- **Type**: Text
- **Name**: Sprint
- **Description**: Sprint number (e.g., Sprint 2)

#### Estimate Field
- **Type**: Number
- **Name**: Estimate
- **Description**: Estimated hours

### Step 4: Configure Automation Rules

Go to Workflows → Add workflow:

#### Rule 1: Auto-move to column based on Status
- **When**: Status changes
- **Then**: Move to corresponding column
  - Status = "In Progress" → Move to "🚀 In Progress"
  - Status = "Review" → Move to "👀 Review"
  - Status = "Done" → Move to "✅ Done"
  - Status = "Blocked" → Add 🚫 label

#### Rule 2: Auto-set Status based on column
- **When**: Item moved to column
- **Then**: Set Status field
  - Moved to "📋 Backlog" → Status = "Backlog"
  - Moved to "🔄 Ready" → Status = "Ready"
  - Moved to "🚀 In Progress" → Status = "In Progress"
  - Moved to "👀 Review" → Status = "Review"
  - Moved to "✅ Done" → Status = "Done"

#### Rule 3: Label sync
- **When**: Issue labeled
- **Then**: Update fields
  - Label contains "priority:" → Set Priority field
  - Label contains "component:" → Set Component field
  - Label contains "sprint:" → Set Sprint field

### Step 5: Create Views

#### Default Board View
- Group by: Status
- Sort by: Priority (High to Low), then Created (Newest first)
- Filters: None (show all)

#### Sprint View
- Group by: Sprint
- Sort by: Status, Priority
- Filter: Sprint is not empty

#### Blocked Items View
- Group by: Component
- Filter: Status = "Blocked"
- Sort by: Created (Oldest first)

#### My Tasks View
- Group by: Status
- Filter: Assignee = @me
- Sort by: Priority, Updated

## Post-Setup Automation

Once the project is created, note down the Project ID (visible in URL) and run:

```bash
# Store project ID for automation
export GITHUB_PROJECT_ID="PVT_xxxxxxxxxxxx"

# Link existing issues to project
./Scripts/planning/link-issues-to-project.sh

# Sync task metadata
./Scripts/planning/sync-project-fields.sh
```

## Verification Checklist

- [ ] Project created and named correctly
- [ ] All 5 columns created
- [ ] Custom fields configured (Status, Priority, Component, Sprint, Estimate)
- [ ] Automation rules active
- [ ] Views created and tested
- [ ] Project ID noted for automation scripts

## Next Steps

1. Run `link-issues-to-project.sh` to add all existing issues
2. Configure GitHub Actions to auto-add new issues
3. Set up daily sync automation
4. Create project dashboards for metrics

## Troubleshooting

### Can't create project
- Ensure you have organization permissions
- Check if projects are enabled for the repository

### Automation not working
- Verify workflow is enabled (not paused)
- Check workflow run history for errors
- Ensure fields are named exactly as specified

### Issues not appearing
- Check repository is linked to project
- Verify issue has correct labels
- Run manual sync script

## References

- [GitHub Projects documentation](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [Projects GraphQL API](https://docs.github.com/en/graphql/reference/objects#projectv2)
- [GitHub CLI project commands](https://cli.github.com/manual/gh_project)