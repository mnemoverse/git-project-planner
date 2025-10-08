# Usage Scenarios - Git Project Planner

Полное руководство по сценариям использования Git Project Planner.

## 🎯 Три основных паттерна использования

### Pattern 1: Standalone Tool (Copy-Paste)
**Для кого**: Solo developers, small teams  
**Время setup**: 5 минут

```bash
# 1. Копируем в свой проект
cd /path/to/your-project
curl -L https://github.com/mnemoverse/git-project-planner/archive/main.tar.gz | tar xz
cp -r git-project-planner-main/{docs,scripts,examples,.planner-config.yml,.gitignore} .

# 2. Инициализируем
./scripts/setup-project.sh --repo owner/name

# 3. Начинаем работать
vim planning/current-sprint.md
```

**Плюсы**:
- Полный контроль над файлами
- Можно адаптировать под проект
- Нет зависимости от внешнего репо

**Минусы**:
- Обновления вручную
- Нужно копировать в каждый проект

---

### Pattern 2: Git Submodule (Linked Reference)
**Для кого**: Multiple projects, shared team standards  
**Время setup**: 3 минуты

```bash
# 1. Добавляем как submodule
cd /path/to/your-project
git submodule add https://github.com/mnemoverse/git-project-planner .planner

# 2. Инициализируем
.planner/scripts/setup-project.sh --repo owner/name

# 3. Symlink для удобства (опционально)
ln -s .planner/docs docs-planner
ln -s .planner/scripts/setup-project.sh init-planning.sh
```

**Плюсы**:
- Легко обновлять (`git submodule update`)
- Единый источник для всех проектов
- Чистый основной репозиторий

**Минусы**:
- Дополнительный шаг при клонировании
- Нельзя модифицировать на месте

---

### Pattern 3: Fork & Customize
**Для кого**: Organizations with specific needs  
**Время setup**: 10-30 минут

```bash
# 1. Fork на GitHub
# gh repo fork mnemoverse/git-project-planner --clone

# 2. Кастомизируем
cd git-project-planner
# Изменяем шаблоны, добавляем свои скрипты
vim docs/templates/TASK_TEMPLATE.md
vim scripts/custom-report.sh

# 3. Используем в проектах
cd /path/to/your-project
git submodule add https://github.com/your-org/git-project-planner .planner
```

**Плюсы**:
- Полная кастомизация
- Можно добавить org-specific интеграции
- Централизованные обновления для команды

**Минусы**:
- Нужно поддерживать fork
- Merge upstream changes вручную

---

## 📋 Сценарии использования по ролям

### Сценарий 1: Solo Developer (Indie Hacker)

**Задача**: Управлять несколькими side projects

**Setup**:
```bash
# Проект 1: SaaS product
cd ~/projects/my-saas
cp -r ~/git-project-planner/{docs,scripts,examples,.planner-config.yml} .
./scripts/setup-project.sh --repo me/my-saas

# Проект 2: Open source library
cd ~/projects/my-lib
cp -r ~/git-project-planner/{docs,scripts,examples,.planner-config.yml} .
./scripts/setup-project.sh --repo me/my-lib
```

**Workflow**:
```bash
# Понедельник утро
vim planning/current-sprint.md
# Планирую неделю: 3-4 таски

# Ежедневно
./scripts/update-sprint.sh
# Обновляет прогресс автоматически

# Пятница вечер
cp planning/current-sprint.md planning/completed-sprints/sprint-$(date +%Y-%m-%d).md
# Ретроспектива: что сделал, что не успел
```

**Интеграции**:
- Никаких - работает локально
- Опционально: GitHub Issues для public visibility

---

### Сценарий 2: Small Team (2-5 человек)

**Задача**: Координировать команду в startup

**Setup**:
```bash
# Lead инициализирует
cd /path/to/team-project
git submodule add https://github.com/mnemoverse/git-project-planner .planner
.planner/scripts/setup-project.sh --repo company/product

# Настраиваем GitHub Project
# 1. Создаём на GitHub: Projects -> New Project -> Board
# 2. Получаем project number (из URL)
vim .planner-config.yml
# Прописываем project.number: 1

# Синхронизируем
.planner/scripts/sync-tasks.sh
.planner/scripts/link-issues-to-project.sh
```

**Workflow**:
```bash
# Понедельник: Sprint Planning (30 мин)
# - Lead обновляет planning/current-sprint.md
# - Team review через PR
git add planning/current-sprint.md
git commit -m "plan: Sprint 15 - User authentication"
git push

# Ежедневно: каждый developer
# 1. Берёт task из planning/current-sprint.md
# 2. Создаёт feature branch
git checkout -b feature/AUTH-001-oauth-integration

# 3. Работает, коммитит
# 4. Создаёт PR с "Closes #123" в описании
gh pr create --title "AUTH-001: Add OAuth integration"

# Автоматически:
# - Issue закрывается при merge
# - Card в Project двигается в Done
# - Sprint metrics обновляются
```

**Интеграции**:
- GitHub Issues (основная работа)
- GitHub Projects (визуализация для stakeholders)
- Slack notifications (опционально)

---

### Сценарий 3: Open Source Project

**Задача**: Координировать contributors, планировать releases

**Setup**:
```bash
cd /path/to/oss-project
git submodule add https://github.com/mnemoverse/git-project-planner .planner
.planner/scripts/setup-project.sh --repo oss-org/project

# Публичные issue templates
cp .planner/docs/templates/issue_template_*.md .github/ISSUE_TEMPLATE/

# CI для автоматизации
cp .planner/examples/ci/planning-sync.yml .github/workflows/
```

**Workflow**:
```bash
# Maintainers: планирование release
vim planning/roadmap.md
# Milestone: v2.0 - Q4 2024
# - Feature X
# - Feature Y
# - Breaking change Z

# Contributors: берут issues
# Issues автоматически создаются из tasks/
# Contributors видят в Projects board

# Maintainers: review и merge
# После merge PR:
# - Issue closes
# - Card moves to Done
# - Release notes auto-generated
```

**Интеграции**:
- GitHub Issues (публичные таски)
- GitHub Projects (roadmap для community)
- GitHub Actions (автоматизация)
- Discord/Slack webhooks (notifications)

---

### Сценарий 4: Hybrid Team (Humans + AI Agents)

**Задача**: AI agents работают как полноценные члены команды

**Setup**:
```bash
cd /path/to/ai-powered-project
git submodule add https://github.com/mnemoverse/git-project-planner .planner
.planner/scripts/setup-project.sh --repo company/ai-project

# Добавляем AI-friendly metadata
vim .planner-config.yml
# ai_agents:
#   - claude-code
#   - cursor
#   - github-copilot
```

**Workflow**:
```bash
# Human Lead: создаёт high-level task
vim tasks/FEAT-001-user-dashboard.md
# Frontmatter с AI-parseable структурой:
# ---
# task_id: "FEAT-001"
# ai_assignable: true
# complexity: "medium"
# dependencies: ["API-005"]
# ---

# AI Agent (Claude Code):
# 1. Читает task spec из tasks/FEAT-001-user-dashboard.md
# 2. Читает связанные API-005 dependencies
# 3. Читает planning/current-sprint.md для контекста
# 4. Генерирует код
# 5. Создаёт PR с ссылкой на task

# Human: review AI code
# AI: fix issues based on review
# Human: merge

# Автоматически:
# - Task marked complete
# - Sprint progress updated
# - AI learning from feedback
```

**Интеграции**:
- Claude Code (чтение tasks, генерация кода)
- Cursor (AI pair programming)
- GitHub Copilot (code suggestions)
- AI review bots (PR analysis)

---

### Сценарий 5: Business + Tech + Design Team

**Задача**: Единый контекст для всех ролей

**Setup**:
```bash
cd /path/to/cross-functional-project
git submodule add https://github.com/mnemoverse/git-project-planner .planner
.planner/scripts/setup-project.sh --repo company/product

# Структура по ролям
mkdir -p tasks/{business,design,engineering}
cp .planner/docs/templates/issue_template_epic.md tasks/business/
cp .planner/docs/templates/issue_template_api.md tasks/engineering/
```

**Workflow**:
```bash
# Product Manager: создаёт epic
vim tasks/business/EPIC-001-checkout-flow.md
# - Business goals
# - Success metrics
# - User stories

# Designer: создаёт design task (ссылается на epic)
vim tasks/design/DES-001-checkout-ui.md
# - Figma link
# - Design system refs
# - Accessibility requirements

# Engineer: создаёт tech tasks (ссылаются на design + epic)
vim tasks/engineering/ENG-001-payment-integration.md
vim tasks/engineering/ENG-002-checkout-ui-impl.md

# Все видят связи через frontmatter:
# dependencies: ["EPIC-001", "DES-001"]

# GitHub Project показывает:
# EPIC-001
#   ├── DES-001 (Design, In Progress)
#   └── ENG-001 (Engineering, Blocked by DES-001)
#       └── ENG-002 (Engineering, Ready)
```

**Интеграции**:
- GitHub Projects (визуализация для всех)
- Figma (design ссылки в tasks)
- Slack (нотификации по ролям)
- Confluence (только архивные docs, не planning)

---

## 🔧 Testing Strategy

### Test 1: Clean Install
```bash
# Создаём чистый проект
mkdir /tmp/test-planner && cd /tmp/test-planner
git init

# Устанавливаем planner
curl -L https://github.com/mnemoverse/git-project-planner/archive/main.tar.gz | tar xz
cp -r git-project-planner-main/{docs,scripts,examples,.planner-config.yml} .

# Инициализируем
./scripts/setup-project.sh

# Проверяем
ls planning/ tasks/
cat planning/current-sprint.md
```

**Expected**:
- ✅ planning/ directory created
- ✅ tasks/ directory created
- ✅ Templates copied
- ✅ Config file present

---

### Test 2: Submodule Workflow
```bash
# Создаём проект с submodule
mkdir /tmp/test-submodule && cd /tmp/test-submodule
git init
git submodule add https://github.com/mnemoverse/git-project-planner .planner

# Инициализируем
.planner/scripts/setup-project.sh --repo test/test

# Проверяем
ls planning/
git status
```

**Expected**:
- ✅ Submodule added
- ✅ Planning directories created
- ✅ Config generated
- ✅ Git status clean

---

### Test 3: Script Functionality
```bash
cd /tmp/test-planner

# Test 1: update-sprint.sh
./scripts/update-sprint.sh

# Test 2: sync-tasks.sh (dry run)
./scripts/sync-tasks.sh --dry-run

# Test 3: setup-venv.sh
./scripts/setup-venv.sh
source scripts/.venv/bin/activate
python --version
```

**Expected**:
- ✅ update-sprint calculates progress
- ✅ sync-tasks shows what would change
- ✅ venv setup works

---

## 🎪 Integration Examples

### Example 1: Slack Notifications

```bash
# .github/workflows/planning-notifications.yml
name: Planning Notifications

on:
  push:
    paths:
      - 'planning/current-sprint.md'
      - 'tasks/**/*.md'

jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Send to Slack
        env:
          SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK }}
        run: |
          MESSAGE="Planning updated: $(git log -1 --pretty=%B)"
          curl -X POST -H 'Content-type: application/json' \
            --data "{\"text\":\"$MESSAGE\"}" \
            $SLACK_WEBHOOK
```

---

### Example 2: Automatic Sync

```bash
# .github/workflows/planning-sync.yml
name: Sync Planning

on:
  push:
    branches: [main]
    paths:
      - 'tasks/**/*.md'
  schedule:
    - cron: '0 9 * * 1'  # Monday 9am

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Sync to GitHub
        run: |
          ./scripts/sync-tasks.sh
          ./scripts/update-sprint.sh
```

---

## 📚 Best Practices

### DO ✅

1. **Keep tasks small** (1-8h each)
2. **Update daily** (./scripts/update-sprint.sh)
3. **Review weekly** (sprint retrospective)
4. **Link everything** (dependencies in frontmatter)
5. **Commit often** (planning evolves with code)

### DON'T ❌

1. **Don't skip frontmatter** (AI needs it)
2. **Don't use external planning** (defeats the purpose)
3. **Don't ignore automation** (scripts save time)
4. **Don't forget documentation** (context is king)
5. **Don't overcomplicate** (keep it simple)

---

## 🚀 Migration Paths

### From Jira

```bash
# 1. Export Jira issues to JSON
# 2. Convert to markdown tasks
python scripts/convert-jira.py jira-export.json tasks/

# 3. Review and adjust
vim tasks/imported/*.md

# 4. Sync to GitHub
./scripts/sync-tasks.sh
```

### From Trello

```bash
# 1. Export Trello board to JSON
# 2. Convert to sprint plan
python scripts/convert-trello.py trello-export.json planning/

# 3. Review
vim planning/current-sprint.md
```

### From Linear

```bash
# 1. Use Linear API to export
# 2. Convert issues to tasks
python scripts/convert-linear.py

# 3. Migrate in phases (don't do everything at once)
```

---

**Remember**: The best planning system is the one you actually use. Start simple, automate gradually, scale naturally.
