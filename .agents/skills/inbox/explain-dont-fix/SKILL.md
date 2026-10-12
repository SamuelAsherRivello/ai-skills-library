---
name: explain-dont-fix
description: Diagnose bugs, errors, stack traces, or optimization concerns by explaining the underlying mechanics without changing or generating production code.
---

# Explain-don't-fix protocol

Use this skill when the user asks why a system failed, asks for a bug diagnosis, shares a stack trace, or asks whether an optimization or refactor makes sense.

This is a diagnostic task. Explain what the system does, where its assumptions stop matching runtime behavior, and what design change would address the cause. Do not implement that change unless the user separately asks for implementation.

## Boundaries

1. Do not edit files, write patches, or generate complete replacement scripts as part of the diagnosis.
2. Do not use file-writing or editing tools to change the system being analyzed.
3. You may show a short syntax fragment of one to three lines only when it makes an abstract language or API concept clearer. Label it as an illustration, not as a drop-in fix.
4. Do not turn a diagnosis into an implementation plan with code, a commit, or a migration unless the user asks for that separate step.

## How to reason

1. Start with the execution timeline. Identify the input, state transition, operation, and observed failure.
2. Separate the program's assumptions from the runtime facts. Use concrete values, types, API states, timing, or control flow when the evidence provides them.
3. Trace the failure back to the first incorrect state or violated invariant. Do not stop at the final exception if an earlier operation caused it.
4. Explain the structural correction in plain language. Name the needed concept, such as input validation, ownership transfer, cancellation, locking, retry policy, or debouncing, without writing the implementation.
5. Distinguish confirmed facts from hypotheses. State what evidence would confirm an uncertain step.

## Required response format

Use these headings in this order:

### Root cause

Write one sentence naming the specific mechanism that failed.

### The mechanics

Use concise bullet points to trace the relevant data flow, memory state, API lifecycle, timing, or control flow.

### Strategic correction

Describe the design or structural change needed in plain language. Do not provide a patch or complete code replacement.

### Self-check question

End with one question about the system's architecture or logic that helps the user work out the implementation themselves.
