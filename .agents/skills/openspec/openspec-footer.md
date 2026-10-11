# OpenSpec Footer

Every OpenSpec workflow response must end with this footer. It is the final
content in the response: do not put a sign-off, links, explanation, or other
text after it.

Render it as a compact Markdown block with a bold title on the same line as
solid em dashes, followed by exactly three bullets. Do not put the title above
a separate horizontal rule or use box-drawing characters for the line:

```markdown
**— OpenSpec Flow ——————————**

- Status: <phase>
- Tasks: N/A
- Next: <action>
```

When tasks exist, replace the `Tasks: N/A` line with:

```text
- Tasks: <completed> of <total>
```

Formatting rules:

- Use `Tasks: N/A` when the change has no tasks. When tasks exist, replace it
  with verified counts from the OpenSpec CLI or the relevant artifact in the
  form `Tasks: <completed> of <total>`. Do not invent a count.
- Use exactly one status value: `Explore`, `Propose`, `Apply`, or `Archived`.
  Choose the active phase, not the name of the skill that happened to run.
- Use `Continue` when the user should keep working in the current phase.
  Use the form Call `/some-command` only when the next action advances to a
  specific workflow phase, replacing `/some-command` with the actual command.
- For a blocked, failed, or clarification response, keep the current phase in
  `Status` and use `Continue` unless a concrete phase-advancing command is
  genuinely the next action.

Examples:

```markdown
**— OpenSpec Flow ——————————**

- Status: Apply
- Tasks: 3 of 7
- Next: Continue
```

```markdown
**— OpenSpec Flow ——————————**

- Status: Explore
- Tasks: N/A
- Next: Call `/openspec-propose`
```
