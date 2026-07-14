---
spec: parse.spec.md
---

## Completed Tasks

- [x] Inventory 38 production files/3,278 lines, nine test files/1,569 lines, and all 185 XCTest methods.
- [x] Document every implemented public type, member family, invariant, boundary, and failure signal without changing product semantics.
- [x] Map the canonical companion to every production source file and configure contract enforcement at 100%.
- [x] Preserve package, source, test, README, CodeQL, platform, and documentation behavior.
- [x] Install Claude, Cursor, Codex, and Gemini SpecSync integrations.
- [x] Configure immutable Trust 1.0.0 to run the native Fledge verification lane.

## Verification Boundaries

- The deterministic suite covers the executable contracts mapped in `testing.md`; surfaces without a direct case are explicitly labeled source-reviewed.
- Performance, localization correctness, standards certification, cryptographic randomness, and long-running resource behavior are not claimed.
- Hosted checks provide platform/security evidence; they are recorded only after the exact commit completes.

## Review Sign-offs

- **Contract review**: source-derived companion complete; parser/coverage verification required before acceptance.
- **Native QA**: build and 185-test Fledge lane required before acceptance.
- **Hosted QA**: exact-head Trust and CodeQL required before merge.
- **Design**: not applicable; no product or visual behavior changes.
