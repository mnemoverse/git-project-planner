# Publication Instructions

## ✅ Pre-Publication Checklist

- [x] All files committed
- [x] Git repository initialized
- [x] Tests passed (/tmp/planner-test-env)
- [x] Documentation complete
- [x] Scripts executable
- [x] LICENSE present (MIT)
- [x] .gitignore configured

## 🚀 Step 1: Link to GitHub Repository

Вы уже создали репозиторий на GitHub: https://github.com/mnemoverse/git-project-planner

Теперь просто привяжите локальный репозиторий:

```bash
cd /Users/eduardizgorodin/Projects/mnemoverse/git-project-planner

# Добавляем remote
git remote add origin https://github.com/mnemoverse/git-project-planner.git

# Push
git branch -M main
git push -u origin main
```

## 📊 Step 2: Configure GitHub Repository

### Repository Settings

1. **Description**: 
   ```
   Git-based project planning system for hybrid teams (humans + AI). Everything in Git, minimal external tools, automated workflows.
   ```

2. **Topics** (add these tags):
   - `project-management`
   - `planning`
   - `git-workflow`
   - `ai-friendly`
   - `automation`
   - `github-projects`
   - `sprint-planning`
   - `task-management`

3. **Website**: 
   ```
   (пока нет, добавите позже если нужно)
   ```

### README Badges (optional)

Add to top of README.md:

```markdown
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Stars](https://img.shields.io/github/stars/mnemoverse/git-project-planner)](https://github.com/mnemoverse/git-project-planner/stargazers)
```

## 📝 Step 3: Create GitHub Release

```bash
# Tag первый release
git tag -a v1.0.0 -m "Release v1.0.0: Initial public release

Features:
- Complete documentation (860+ lines)
- 7 automation scripts
- 11 templates
- VISION.md for hybrid teams
- Real production examples
- AI-friendly structure

Ready for solo developers, small teams, and hybrid human-AI teams."

# Push tag
git push origin v1.0.0
```

Или через GitHub UI:
1. Go to: https://github.com/mnemoverse/git-project-planner/releases/new
2. Tag: `v1.0.0`
3. Title: `v1.0.0 - Initial Public Release`
4. Description: (copy from tag message above)
5. Click "Publish release"

## 🎯 Step 4: Post-Publication Tasks

### Update Documentation Links

В README.md обновите ссылки если нужно:
```markdown
# Before
git clone https://github.com/mnemoverse/git-project-planner.git

# After (if you want HTTPS)
git clone https://github.com/mnemoverse/git-project-planner.git
```

### Create GitHub Project (Optional)

Для демонстрации системы:

1. Go to: https://github.com/mnemoverse/git-project-planner/projects
2. Click "New project"
3. Template: "Board"
4. Name: "Git Project Planner Roadmap"
5. Add columns: Backlog, Ready, In Progress, Done

## 📣 Step 5: Announce

### GitHub Discussions

Create announcement in Discussions:

```markdown
# 🎉 Git Project Planner v1.0 Released!

Git-based project planning system for hybrid teams (humans + AI).

## Why?
- Everything in Git (single source of truth)
- Minimal external tools (Slack/Figma/Jira only when necessary)
- Automation-first (CI hooks, scripts)
- AI-friendly (structured for AI agents)

## Quick Start
\`\`\`bash
curl -L https://github.com/mnemoverse/git-project-planner/archive/main.tar.gz | tar xz
cp -r git-project-planner-main/{docs,scripts,examples,.planner-config.yml} .
./scripts/setup-project.sh
\`\`\`

## Read the Vision
See [VISION.md](VISION.md) for the full philosophy.

Questions? Open an issue!
```

### Twitter/Social Media (optional)

```
🚀 Just released Git Project Planner v1.0!

✅ Everything in Git
✅ AI-friendly structure  
✅ Minimal external tools
✅ Automation-first

Perfect for hybrid teams (humans + AI agents) 🤖

https://github.com/mnemoverse/git-project-planner

#gitops #projectmanagement #ai
```

## 🧪 Step 6: Test Public Access

```bash
# Новая директория для теста
mkdir /tmp/public-test && cd /tmp/public-test

# Клонируем публичный репо
git clone https://github.com/mnemoverse/git-project-planner.git

# Тестируем
cd git-project-planner
./scripts/setup-project.sh

# Проверяем
ls planning/ tasks/
```

## 🔄 Step 7: Clone to Your Working Projects

### Вариант 1: SmartKeys v2

```bash
cd /Users/eduardizgorodin/Projects/mnemoverse/smartkeys-v2

# Добавляем как submodule
git submodule add https://github.com/mnemoverse/git-project-planner .planner

# Или копируем напрямую (если хотите модифицировать)
curl -L https://github.com/mnemoverse/git-project-planner/archive/main.tar.gz | tar xz
cp -r git-project-planner-main/{docs,scripts,examples,.planner-config.yml} .planning-system/

# Инициализируем
./planner/scripts/setup-project.sh --repo mnemoverse/smartkeys-v2
```

### Вариант 2: Mnemoverse-arch

```bash
cd /Users/eduardizgorodin/Projects/mnemoverse/mnemoverse-arch

# Добавляем как submodule
git submodule add https://github.com/mnemoverse/git-project-planner .planner

# Инициализируем
.planner/scripts/setup-project.sh --repo mnemoverse/mnemoverse-arch
```

### Вариант 3: Новые проекты

Для любых новых проектов:
```bash
cd /path/to/new-project
git submodule add https://github.com/mnemoverse/git-project-planner .planner
.planner/scripts/setup-project.sh --repo owner/name
```

## 📚 Documentation Updates

После публикации обновите workspace документацию:

1. **Update workspace README** (`~/Projects/mnemoverse/README.md`):
   ```markdown
   ## Tools
   - [Git Project Planner](https://github.com/mnemoverse/git-project-planner) - Planning system for all projects
   ```

2. **Update CLAUDE.md** в проектах:
   ```markdown
   ## Planning System
   Uses [Git Project Planner](https://github.com/mnemoverse/git-project-planner)
   - Everything in Git
   - See `.planner/` for documentation
   ```

## 🎯 Success Metrics

Track these to know if it's working:

- GitHub Stars: ⭐
- Clones per week: (check Insights -> Traffic)
- Issues opened: (user feedback)
- PRs submitted: (community contributions)

## ⚡️ Quick Commands

```bash
# После публикации, чтобы использовать где угодно:

# 1. Clone
git clone https://github.com/mnemoverse/git-project-planner.git

# 2. Use in project
cp -r git-project-planner/{docs,scripts,examples,.planner-config.yml} /path/to/project/
cd /path/to/project
./scripts/setup-project.sh

# 3. Done!
```

---

**Status**: Ready to publish! ✅

**Next**: Run the commands in Step 1 to push to GitHub.
