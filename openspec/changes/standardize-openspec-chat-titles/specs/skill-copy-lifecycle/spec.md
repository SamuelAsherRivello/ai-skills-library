# Spec Delta

## ADDED Requirements

### Requirement: Lifecycle conflicts use quality and recency
When selected source and destination skill directories differ, each push, pull,
or move lifecycle command SHALL compare their most recent file modification
times and inspect the substantive differences. It SHALL select a newer copy
automatically only when that copy is clearly better. If the newer copy is
inferior or quality cannot be determined confidently, it SHALL leave both
copies unchanged and ask the user which copy to retain.

#### Scenario: A newer copy is clearly better
- **WHEN** a lifecycle command finds a newer differing copy with a clear,
  validated improvement over the older copy
- **THEN** it selects that newer copy and reports the comparison outcome

#### Scenario: A newer copy is not clearly better
- **WHEN** a lifecycle command finds a newer differing copy whose quality is
  unclear or inferior
- **THEN** it makes no copy and asks the user to choose the source of truth
