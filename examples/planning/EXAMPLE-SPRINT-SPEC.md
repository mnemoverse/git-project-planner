# Sprint 2 (One‑Day MVP): Context Data Flow for Self‑Awareness

## Goal (today)
Deliver an end‑to‑end context extraction pipeline for the SelfAwareness module with LOD and token budget control, integrated into the current LangGraph agent. No ML, no caching, no external storage.

## Scope and constraints
- Module: SelfAwareness only
- LOD levels today: MINIMAL | BRIEF | STANDARD (3 levels)
- Dynamic priorities: simple rule-based
- Token budget: character-length approximation (no tiktoken today)
- Integration: a single SystemMessage injected before LLM in the existing graph
- Add/Update manager: define interface only (implementation later)

## Input to Context Manager (module descriptors)
Minimal descriptor (hard-coded for today):
- id: self_awareness
- outputs: identity, active_traits, capabilities, limitations, current_state
- lod_supported: MINIMAL, BRIEF, STANDARD
- cost_hint_chars: {MINIMAL: 80, BRIEF: 200, STANDARD: 450}
- priority_factors: identity_questions, capability_questions, meta_questions, first_greeting

## Tasks (in order) — all doable today

### A) ContextManager MVP (2h)
File: `src/mnemoverse_arch/core/context_manager.py`
- Methods:
  - `analyze_relevance(query: str, module_id: str) -> float` (keyword heuristics)
  - `select_lod(query: str, relevance: float, token_budget: int) -> LODLevel` (simple rules)
  - `prepare_context(query: str, user_id: str, modules: List[Descriptor], token_budget: int = 1200) -> Dict[str, str]`
- Flow: relevance → LOD → ask module for raw_data → slice → merge → return `{self_awareness: "..."}`
- Acceptance:
  - For "Who are you?": relevance(self_awareness) ≥ 0.8
  - LOD == STANDARD if token_budget ≥ 600

### B) SelfAwareness raw_data (1.5h)
File: `src/mnemoverse_arch/modules/self_awareness.py`
- Add `get_module_data(query: str, user_id: str) -> Dict[str, Any]`
- Required keys: `identity{name, version}, active_traits[3], capabilities[3], limitations[2], current_state{role, confidence}`
- Use actual config/constants and simple logic; no placeholders
- Acceptance: returns non-empty values for all required keys

### C) DataSlicer (1h)
File: `src/mnemoverse_arch/core/data_slicer.py`
- Function: `slice_self_awareness(raw: Dict[str, Any], lod: LODLevel) -> str`
- Length targets (characters): MINIMAL ≤ 80, BRIEF ≤ 200, STANDARD ≤ 450
- Content policy:
  - MINIMAL: name, role
  - BRIEF: name, version, up to 2 traits, role
  - STANDARD: name, version, up to 3 traits, 3 capabilities, confidence, 1 limitation
- Acceptance: outputs respect length targets and include required fields per LOD

### D) TokenBudget (30m)
In `ContextManager`:
- If combined length > 900 chars: degrade LOD STANDARD → BRIEF; if still over, BRIEF → MINIMAL
- Acceptance: final combined context ≤ 900 chars for a single module

### E) LangGraph integration (1h)
File: `src/mnemoverse_arch/graphs/agent_graph.py`
- Inject a single SystemMessage with the final self_awareness slice before LLM call
- Do not change other module calls today
- Acceptance: for "Who are you?" the SystemMessage contains a block starting with "Self‑Awareness"

### F) Add‑Manager interface (30m)
File: `src/mnemoverse_arch/core/add_manager.py`
- Define interface: `record_self_awareness(data: Dict[str, Any], user_id: str) -> None`
- Today: no‑op + logging (no storage)
- Acceptance: callable without errors, logs input

## Manual checks (today)
- Query: "Who are you and what can you do?"
  - SystemMessage injected with LOD=STANDARD
  - Self‑awareness block ≤ 450 chars
  - When token_budget set to 200 → LOD=BRIEF

## Out of scope (today)
- ML for LOD selection
- tiktoken precision, exact token counting
- Redis/Mem0/persistence
- Other modules

## Can a framework do this?
- LangGraph: great for orchestration (branching, parallel, conditional). It does not provide LOD selection, data slicing, or token budgeting. We implement those lightweight components ourselves and call them from a LangGraph node.

## Definition of Done (today)
- Self‑awareness context is injected as a SystemMessage
- LOD works (MINIMAL/BRIEF/STANDARD)
- Character budget respected with graceful degradation
- Add‑Manager interface exists (no‑op today)
- Locations of files and manual test steps are documented