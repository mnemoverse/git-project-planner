# Examples Directory

Universal examples to help you get started with Git Project Planner.

## 📁 Structure

```
examples/
├── planning/                    # Sprint and roadmap examples
│   ├── roadmap-example.md      # Long-term planning
│   └── sprint-example.md       # Weekly/bi-weekly sprints
└── tasks/                      # Task specification examples
    ├── EXAMPLE-001-feature-implementation.md
    └── EXAMPLE-002-bug-fix.md
```

## 🚀 How to Use

### For Planning

```bash
# Copy roadmap template
cp examples/planning/roadmap-example.md planning/roadmap.md
vim planning/roadmap.md  # Customize for your project

# Copy sprint template
cp examples/planning/sprint-example.md planning/current-sprint.md
vim planning/current-sprint.md  # Plan your first sprint
```

### For Tasks

```bash
# Copy task template for a new feature
cp examples/tasks/EXAMPLE-001-feature-implementation.md tasks/PROJ-001-your-feature.md
vim tasks/PROJ-001-your-feature.md  # Fill in details

# Copy bug fix template
cp examples/tasks/EXAMPLE-002-bug-fix.md tasks/BUG-001-your-bug.md
vim tasks/BUG-001-your-bug.md  # Describe the bug
```

## 📝 Template Patterns

### Task IDs

Choose a pattern that works for your team:

- **Project-based**: `PROJ-001`, `PROJ-002`, ...
- **Type-based**: `FEAT-001`, `BUG-001`, `DOCS-001`, ...
- **Component-based**: `API-001`, `UI-001`, `DB-001`, ...
- **Custom**: `YOUR-PREFIX-001`, ...

### Task Types

Common task types to consider:

- **FEAT**: New feature
- **BUG**: Bug fix
- **DOCS**: Documentation
- **PERF**: Performance improvement
- **REFACTOR**: Code refactoring
- **TEST**: Testing
- **CHORE**: Maintenance tasks

## 💡 Tips

1. **Keep it simple**: Start with basic templates, add complexity as needed
2. **Adapt to your team**: Modify frontmatter fields to match your workflow
3. **Link everything**: Use dependencies to show task relationships
4. **Update regularly**: Keep examples fresh with lessons learned

## 🔗 Next Steps

After copying examples:

1. Initialize planning system: `./scripts/setup-project.sh`
2. Customize examples for your project
3. Start planning your first sprint
4. Create your first task

See [docs/PLANNING_SYSTEM.md](../docs/PLANNING_SYSTEM.md) for complete guide.
