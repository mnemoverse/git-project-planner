---
task_id: "SMK-020E"
title: "Eliminate Hidden Container.shared Dependencies"
created: "2025-09-29"
priority: "Medium"
status: "Planned"
phase: "Sprint 1 Week 1"
dependencies: ["SMK-020", "SMK-005A", "SMK-004"]
series: "factory-di"
estimate: "3h"
assignee: ""
reviewer: ""
labels: ["core", "di", "testability"]
complexity: "Intermediate"
repository: "mnemoverse/smartkeys-v2"
---

# SMK-020E: Eliminate Hidden Container.shared Dependencies

## 🎯 Objective

Remove implicit Factory lookups inside core components to improve testability and clarity of dependency flows.

## ✅ Definition of Done

- [ ] `QwertyJcukenMapper` no longer accesses `Container.shared` inside static helpers; alternate helper or explicit injection provided
- [ ] `DefaultEventProcessor` constructor requires dependencies as parameters; DI supplies defaults via factory
- [ ] `Task.sleep` delays in `DefaultEventProcessor.start/stop` removed or made configurable via injected scheduler
- [ ] Unit tests or smoke checks updated to cover new signatures
- [ ] Documentation/backlog updated accordingly

## 🛠️ Implementation Guide

1. **Refactor QwertyJcukenMapper helpers**
   - Convert static convenience methods to accept optional mapper (default provided by caller)
   - Update call sites (`LayoutDetector`, tests)
2. **Adjust DefaultEventProcessor**
   - Replace default parameter closures referencing `Container.shared` with explicit arguments
   - Provide factory default via `Container.shared.eventProcessor`
   - Introduce optional scheduler or remove artificial delay
3. **Validation**
   - Run targeted tests (or `swift build`) to ensure no regressions
   - Update docs as needed

## 📎 References

- `Sources/SmartKeysCore/Correction/QwertyJcukenMapper.swift`
- `Sources/SmartKeysCore/EventProcessing/DefaultEventProcessor.swift`
- `Sources/SmartKeysCore/DependencyInjection/Container+CoreProtocols.swift`
