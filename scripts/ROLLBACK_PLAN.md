# 🚨 Rollback Plan for Task Synchronization

## Before Sync Checklist

1. **Record current state**:
   ```bash
   # Save current issues list
   gh issue list --repo mnemoverse/smartkeys-v2 --limit 200 --json number,title,labels > issues-backup-$(date +%Y%m%d-%H%M%S).json

   # Count current issues
   gh issue list --repo mnemoverse/smartkeys-v2 --limit 200 --json number | jq '. | length'
   ```

2. **Dry run first** (MANDATORY):
   ```bash
   ./Scripts/planning/sync-tasks.sh --dry-run > sync-dry-run-$(date +%Y%m%d-%H%M%S).log
   ```

3. **Review dry run output**:
   - Check for unexpected task files
   - Verify label mapping is correct
   - Ensure no existing issues will be modified unexpectedly

## During Sync

The sync script is designed to be safe:
- ✅ Only creates new issues (doesn't delete)
- ✅ Updates labels only on issues it created
- ✅ Preserves manual issues unchanged
- ✅ Each issue tagged with task_id for tracking

## Rollback Procedures

### Scenario 1: Too Many Issues Created

**Problem**: Script created more issues than expected

**Solution**:
```bash
# List all issues created today
gh issue list --repo mnemoverse/smartkeys-v2 --limit 100 --json number,title,createdAt | \
  jq '.[] | select(.createdAt | startswith("2025-10-16"))'

# Close specific issues (if needed)
gh issue close <issue-number> --comment "Closed: sync error, will recreate"

# Bulk close (CAREFUL!)
for num in $(gh issue list --repo mnemoverse/smartkeys-v2 --limit 100 --json number,title | \
  jq -r '.[] | select(.title | startswith("SMK-")) | .number'); do
  echo "Would close issue #$num"
  # gh issue close $num --comment "Bulk close: sync error"
done
```

### Scenario 2: Wrong Labels Applied

**Problem**: Issues have incorrect labels

**Solution**:
```bash
# Remove specific label from all issues
gh issue list --repo mnemoverse/smartkeys-v2 --label "wrong-label" --limit 100 --json number | \
  jq -r '.[].number' | \
  xargs -I {} gh issue edit {} --remove-label "wrong-label"

# Fix label on specific issue
gh issue edit <issue-number> --add-label "status:ready" --remove-label "status:backlog"
```

### Scenario 3: Duplicate Issues Created

**Problem**: Same task has multiple issues

**Solution**:
```bash
# Find duplicates by title
gh issue list --repo mnemoverse/smartkeys-v2 --limit 200 --json number,title | \
  jq -r '.[] | "\(.title)"' | sort | uniq -d

# Close duplicates manually
gh issue close <duplicate-number> --comment "Duplicate of #<original-number>"
```

### Scenario 4: Complete Reset (Nuclear Option)

**Problem**: Everything went wrong, need to start over

**Solution**:
```bash
# 1. Export all issues first
gh issue list --repo mnemoverse/smartkeys-v2 --limit 200 --json number,title,body,labels,state > \
  all-issues-backup-$(date +%Y%m%d-%H%M%S).json

# 2. Close all SMK/PS issues (VERY CAREFUL!)
echo "⚠️ This will close ALL task-related issues!"
read -p "Are you absolutely sure? (type 'yes'): " confirm
if [ "$confirm" == "yes" ]; then
  for num in $(gh issue list --repo mnemoverse/smartkeys-v2 --limit 200 --json number,title | \
    jq -r '.[] | select(.title | test("^(SMK|PS)-")) | .number'); do
    gh issue close $num --comment "Reset: will recreate with sync script"
  done
fi

# 3. Re-run sync from scratch
./Scripts/planning/sync-tasks.sh
```

## Safety Commands

### View what would be affected:
```bash
# Count issues by label
gh issue list --repo mnemoverse/smartkeys-v2 --limit 200 --json labels | \
  jq -r '.[].labels[].name' | sort | uniq -c

# List issues created by automation
gh issue list --repo mnemoverse/smartkeys-v2 --limit 200 --json number,title,body | \
  jq '.[] | select(.body | contains("automatically synchronized"))'
```

### Monitoring:
```bash
# Watch issue count
watch -n 5 'gh issue list --repo mnemoverse/smartkeys-v2 --limit 200 --json number | jq ". | length"'

# Check rate limit
gh api rate_limit
```

## Post-Sync Verification

1. **Verify counts**:
   ```bash
   echo "Task files: $(find tasks -name '*.md' -type f | wc -l)"
   echo "GitHub Issues: $(gh issue list --repo mnemoverse/smartkeys-v2 --limit 200 --json number | jq '. | length')"
   ```

2. **Spot check issues**:
   ```bash
   # View a few created issues
   gh issue view <number> --json title,body,labels
   ```

3. **Check labels**:
   ```bash
   gh label list --repo mnemoverse/smartkeys-v2 | grep -E "(status:|priority:|component:|sprint:)"
   ```

## Emergency Contacts

- GitHub API Status: https://www.githubstatus.com/
- Rate Limit Reset: Wait 1 hour or use different token
- Script Author: @eduard-izgorodin-reluna (via this session)

## Important Notes

1. **GitHub API Rate Limits**:
   - 5000 requests/hour for authenticated requests
   - Creating 50 issues uses ~150 API calls
   - Always check rate limit before bulk operations

2. **Issue Numbers are Permanent**:
   - Once created, issue numbers never reuse
   - Closing doesn't delete the issue
   - All closed issues remain in history

3. **Labels are Shared**:
   - Labels apply to entire repository
   - Removing a label doesn't delete it from repo
   - Other tools may use same labels

---
Last Updated: 2025-10-16
Script Version: sync-tasks.py v1.0