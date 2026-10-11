# Tasks

## 1. Public rollout only when separately authorized

- [x] 1.1 For an authorized upstream rollout, run existing staging/release workflows with source/type/test/package gates and verify exact staged version, game-specific two-client checks and the documented 240-second Hobby probe; keep the stable endpoint unchanged on staging failure.
- [ ] 1.2 For an authorized promotion, verify exact stable version and compatible consumers before publishing the generated typed client artifact; verify the existing rollback path on failure and record public probe/release evidence without adding hosts, paid services or durability promises.
