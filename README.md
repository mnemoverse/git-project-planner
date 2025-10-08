# Git Project Planner

[![CI](https://github.com/mnemoverse/git-project-planner/workflows/CI/badge.svg)](https://github.com/mnemoverse/git-project-planner/actions)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](CHANGELOG.md)

**Методология и инструменты для планирования проектов через Git + опциональная интеграция с GitHub Projects.**

## 🎯 Что это?

**Git Project Planner** — это система планирования на основе Git, которая собрала лучшие практики из реальных проектов (SmartKeys, Mnemoverse, Gitea API) в единый переносимый пакет.

### Для кого?
- ✅ **Solo-разработчики** — структурированное планирование без оверхеда
- ✅ **Малые команды (2-5 человек)** — простая координация через Git
- ✅ **Гибридные команды (люди + AI)** — единый контекст для всех участников
- ✅ **Open Source проекты** — прозрачное публичное планирование

### Зачем?
Решает главную проблему: **рассинхронизация планирования и кода**.

**Было:**
```
Планирование → Jira/Notion/Asana (отдельно)
Код → GitHub (отдельно)
Документация → Confluence (отдельно)
Решения → Slack (потеряны)
```

**Стало:**
```
Git Repository = Единственный источник истины
    ├── Код (что строим)
    ├── Планы (зачем строим)
    ├── Задачи (как строим)
    └── История (почему так решили)
```

### Как работает?

**3 уровня использования:**

1. **Методология** (философия) — прочитайте [VISION.md](VISION.md)
2. **Инструменты** (скрипты, хуки, CI/CD) — скопируйте в свой проект
3. **Шаблоны** (tasks, sprints, roadmaps) — адаптируйте под себя

> 💡 **Философия**: Всё в Git. Минимум внешних зависимостей. Автоматизировать всё возможное.

## 🚀 Быстрый старт (5 минут)

### Вариант 1: Скопировать в проект (рекомендуется)

```bash
# 1. Скачать
git clone https://github.com/mnemoverse/git-project-planner.git
cd git-project-planner

# 2. Скопировать в ваш проект
cp -r {docs,scripts,examples,.planner-config.yml} /path/to/your-project/
cd /path/to/your-project

# 3. Инициализация
./scripts/setup-project.sh --repo owner/repo-name

# 4. Начать работу
vim planning/current-sprint.md
```

### Вариант 2: Git Submodule (для нескольких проектов)

```bash
cd /path/to/your-project
git submodule add https://github.com/mnemoverse/git-project-planner .planner
.planner/scripts/setup-project.sh --repo owner/repo-name
```

### Вариант 3: Fork и кастомизация (для организаций)

```bash
# Fork на GitHub → адаптируйте под свои нужды
gh repo fork mnemoverse/git-project-planner --clone
```

**Подробности всех вариантов:** [docs/USAGE_SCENARIOS.md](docs/USAGE_SCENARIOS.md)

---

## 📦 Что внутри?

### 1. Методология и философия

- **[VISION.md](VISION.md)** — зачем это нужно, как работает с гибридными командами
- **[docs/PLANNING_SYSTEM.md](docs/PLANNING_SYSTEM.md)** — полное описание системы планирования
- **[docs/WORKFLOW_GUIDE.md](docs/WORKFLOW_GUIDE.md)** — ежедневные процессы и команды

### 2. Автоматизация

#### Pre-commit хуки (9 проверок)
```bash
./scripts/setup-hooks.sh  # установка

# Автоматически проверяют перед коммитом:
# ✓ Markdown форматирование
# ✓ YAML синтаксис
# ✓ Shell script линтинг (shellcheck)
# ✓ Обнаружение секретов
# ✓ Trailing whitespace
```

#### CI/CD (GitHub Actions)
```yaml
# Автоматически запускается при PR:
# ✓ Линтинг всех файлов
# ✓ Проверка именования задач
# ✓ Валидация линков
# ✓ Security сканирование
```

#### Скрипты автоматизации
```bash
./scripts/sync-tasks.sh          # → синхронизация с GitHub Issues
./scripts/update-sprint.sh       # → обновление прогресса спринта
./scripts/validate-all.sh        # → запуск всех проверок локально
./scripts/link-issues-to-project.sh  # → привязка к GitHub Project
```

**Детали:** [docs/AUTOMATION_GUIDE.md](docs/AUTOMATION_GUIDE.md)

### 3. Шаблоны

```
docs/templates/
├── TASK_TEMPLATE.md        # Спецификация задачи
├── SPRINT_TEMPLATE.md      # План спринта
├── MILESTONE_TEMPLATE.md   # Milestone
└── ISSUE_TEMPLATE.md       # GitHub Issue
```

### 4. Примеры

```
examples/
├── planning/               # Примеры roadmap и sprint
└── tasks/                  # Примеры feature/bug/tech debt задач
```

---

## 🎯 Ключевые подходы

### 1. Git-Native First
**Принцип:** Если может жить в Git — должно жить в Git.

```
✅ В Git:                    ⚠️ Опционально (со ссылками):
• Задачи (tasks/*.md)       • Figma (ссылка в задаче)
• Спринты (planning/*.md)   • Slack (саммари в задаче)
• Roadmap                   • Zoom (ссылка + транскрипт)
• Решения и контекст        
• История изменений         ❌ Только внешне:
                            • Real-time чат
                            • Синхронные встречи
```

### 2. Automation First
**Принцип:** Люди не должны делать то, что могут делать машины.

```
Layer 1: Git Hooks           → авто-форматирование, валидация
Layer 2: CI/CD               → синхронизация, репорты, нотификации  
Layer 3: Scripts (manual)    → планирование спринтов, ретроспективы
```

### 3. Minimal External Connectors
**Принцип:** Используйте внешние инструменты только когда они дают уникальную ценность.

```
CORE (required):        Git + GitHub
OPTIONAL (sparingly):   Slack, Figma, CI/CD
AVOID:                  Jira, Confluence, Notion, etc.
```

### 4. Structured for AI Agents
**Принцип:** AI агенты видят тот же контекст, что и люди.

```markdown
<!-- Frontmatter для машинного парсинга -->
---
task_id: "TASK-001"
status: "in-progress"
priority: "high"
---

# TASK-001: Feature Name

<!-- Markdown для людей -->
## Context
Почему эта задача важна...
```

**Подробности:** [VISION.md](VISION.md)

---

## 📚 Полная документация

| Документ | Для чего | Читать когда |
|----------|----------|--------------|
| **[VISION.md](VISION.md)** | Философия и "зачем" | Перед началом работы |
| **[STRUCTURE.md](STRUCTURE.md)** | Структура репозитория | Ориентация в файлах |
| **[docs/PLANNING_SYSTEM.md](docs/PLANNING_SYSTEM.md)** | Полный гайд системы | Настройка процессов |
| **[docs/WORKFLOW_GUIDE.md](docs/WORKFLOW_GUIDE.md)** | Ежедневные команды | Quick reference |
| **[docs/AUTOMATION_GUIDE.md](docs/AUTOMATION_GUIDE.md)** | Скрипты и CI/CD | Настройка автоматизации |
| **[docs/GITHUB_SETUP.md](docs/GITHUB_SETUP.md)** | GitHub Projects | Интеграция с GitHub |
| **[docs/GIT_HOOKS_GUIDE.md](docs/GIT_HOOKS_GUIDE.md)** | Pre-commit хуки | Настройка качества |
| **[docs/USAGE_SCENARIOS.md](docs/USAGE_SCENARIOS.md)** | Сценарии использования | Выбор подхода |
| **[CONTRIBUTING.md](CONTRIBUTING.md)** | Как контрибьютить | Перед PR |
| **[CHANGELOG.md](CHANGELOG.md)** | История версий | Обновления |

---

## �️ Требования

**Минимальные:**
- Git
- Bash 4.0+

**Опциональные (для полной функциональности):**
- Python 3.8+ (для скриптов автоматизации)
- GitHub CLI `gh` (для синхронизации с GitHub)
- pre-commit framework (для Git hooks)

---

## 🎪 Что уникального?

1. **Собрано из реальных проектов** — не теория, а работающие практики
2. **Гибридные команды (люди + AI)** — структура понятна и людям, и AI агентам
3. **Комплексное решение** — методология + инструменты + шаблоны
4. **Portable** — скопируй в любой проект за 5 минут
5. **Quality-first** — встроенные проверки и автоматизация
6. **Git-native** — работает офлайн, синхронизируется через Git

---

## 🤝 Лицензия и вклад

**Лицензия:** MIT — используйте свободно в любых проектах.

**Контрибьюции приветствуются:**
- Issues с багами или идеями
- Pull requests с улучшениями
- Документация и примеры
- Sharing ваших практик

**[Contributing Guide](CONTRIBUTING.md)** • **[Issues](https://github.com/mnemoverse/git-project-planner/issues)**

---

**Начните планировать умнее, а не сложнее.** 🚀
