---
name: ai-skills-create-app
description: Create a non-game React application from the shared repository template. Gate on requirements and required access before implementation; use when starting an application rather than a game.
---

# AI Skills Create App

Create a new repository and React application in strict TypeScript. Default to a single-user, client-only application. Route game/game-engine/Babylon-renderer requests to `$ai-skills-create-game`; Babylon is game-only and must not be selected or used for ordinary applications. Do not add gameplay or game dependencies unless the user changes scope. Publish, deploy, or release only when explicitly requested, and do not silently substitute local-only handoff when requested delivery is blocked.

Author application source, React components, tests, executable JavaScript configuration, and JavaScript tooling in `.ts`/`.tsx` with `strict: true`. Migrate a JavaScript shared or custom starter in the copied project before handoff, including local-only work. Generated JavaScript, dependencies, and native shell orchestration remain valid; file renames or blanket declarations do not establish type safety.

## Mandatory intake and access gate

Complete this gate before creating a repository, editing a checkout, generating assets, or beginning OpenSpec artifacts. Report a concise readiness table or equivalent that identifies every required capability as ready, not required, or blocked.

1. Establish the application requirements, repository owner, and automation identity. Resolve material product, delivery/deployment, and service requirements. Default to a single-user, client-only app. For a multiplayer request, clarify whether it needs real-time interaction, collaborative editing, shared presence, or another shared-state model before selecting any backend. When visuals or supplied assets are relevant, clarify their source, rights, and provenance. Resolve and verify the AI organization as the repository owner unless the user explicitly supplies another owner; do not invent an organization slug. The required automation identity is the existing GitHub user `ai-rmc-com` (the AI user). Ask targeted questions and wait only when a material requirement cannot be safely derived.
2. Inspect access for every service and tool in scope for this request: verify that `ai-rmc-com` is the authenticated GitHub actor, then resolve and verify the AI organization and the AI user's repository-creation permission for it; also inspect the shared template, every prompt-required delivery/deployment service, and any user-named tool, asset source, or credential. For multiplayer, discover the existing shared multiplayer server/client path and verify that its current room, protocol, and shared-client capabilities suit the app; protect compatible existing consumers. Inspect the server repository, its Vercel project, and deployment permission only when the verified workflow requires them. Inspect the in-scope global OpenSpec skills—`openspec-explore`, `openspec-propose`, `openspec-update-change` when a plan changes, and `openspec-apply-change`—and Playwright CLI by default. Do not infer access from a stated owner, AI user, or authenticated identity.
3. If required access, credentials, template/service permission, or an in-scope global skill is unavailable, pause before implementation and state the exact missing access or skill. Ask the user to restore access or change scope; do not install substitutes, create repository-local OpenSpec skills, or silently degrade a delivery request to a local-only build. Playwright CLI is optional: report it unavailable and use another suitable verification method only after the required gate passes.
4. Once ready, use the in-scope global OpenSpec workflow in this order: **Explore → Propose → optional Update → Apply**. Do not generate, install, or copy repository-local OpenSpec skills unless the user explicitly authorizes it. Apply remains the implementation step; Update is only needed when the approved plan changes.

## Inputs

Accept natural language or prompt fields, not shell flags. `app` describes users, purpose, and essential features; `name` supplies repository identity. `mode` defaults to `single-user`; a request for shared or multiplayer behavior selects the multiplayer intake path. Optional `folder` and `project` default from the name, and `visibility` defaults to `public`. `requirements` controls features, exclusions, visuals, assets, deployment/delivery, and scope. The owner and AI user remain the values resolved during intake; naming either does not establish authentication or access.

## Multiplayer application path

Use this path only for a requested shared or multiplayer application; it is not a game workflow. First determine whether the application needs real-time interaction, collaboration, presence, or another shared-state model. Discover and use the existing shared multiplayer server/client path only when its actual room/protocol contract supports that model and its compatible existing consumers remain protected.

If the verified server and shared client already support the app, use their existing release and deployment workflow. Release a Vercel backend only when a required room, protocol, or shared-client capability is missing. For such a change, extend the existing server-first workflow through the global OpenSpec sequence, validate compatibility for existing consumers, release the backend, and verify the application against that released capability before frontend delivery. If the shared path is unsuitable, pause and ask the user to change scope rather than inventing a substitute backend. Do not create an unnecessary backend or change its protocol merely because the request says multiplayer.

When appropriate to the application and its template, preserve the existing GitHub Pages frontend delivery pattern. For multiplayer applications, use the verified Vercel backend workflow only as required by the compatible shared-server path; verify both surfaces when delivery is requested.

Use the [shared template](https://github.com/SamuelAsherRivello/github-repository-template) unless another is supplied. After the intake gate passes, generate through GitHub's template flow; never overwrite or reuse a colliding repository/folder without an explicit continuation request.

## Create and verify

1. Clone the generated repository and verify its remote/default branch. Read generated `AGENTS.md` and template checklist. Inspect actual React/Vite structure and commands; preserve conventions, rename the copied application directory and update dependent paths as required. Remove game-only starter code/dependencies. Implement the responsive, accessible app within scope, keeping meaningful application behavior testable independently of React/external adapters.
2. Run complete strict typechecking, source-coverage checks, meaningful tests, and the production build under [the quality gate](references/quality-gate.md). Test meaningful user flows and recovery states in a real browser when warranted. Default to `$playwright-cli` with isolated test profiles when its intake check passes; if it is unavailable, use another suitable method and report unverified browser behavior where applicable.
3. Use headless automation with isolated test profiles. If headed testing is necessary, launch minimized without taking focus; never spawn normal visible windows for automated testing, including browser capability fallbacks. If a tool cannot comply, choose another method or report the limitation. Keep tests silent and close only automation-owned sessions/processes.
4. Complete [the quality gate](references/quality-gate.md) before reporting completion. Then perform only requested delivery actions through the repository's existing workflows and verify their actual outcome. Local-only scope does not authorize publishing.

Return repository URL, local checkout, validation evidence, final triage packet/scores, deferred candidates, requested delivery results, and precise blockers. Preserve unrelated work; never expose credentials, force-push, delete repositories, or overwrite destinations. Stop affected work when access or a destination conflict blocks it.
