# Bootstrap policy

Use this policy only for an explicit custom OpenSpec workflow or an explicit
`$ai-skills-openspec-init` request. It is intentionally separate from library publishing
and skill installation.

## Resolution order

1. Check `openspec context --json`. A usable root means no initialization. A
   declared or malformed store error is a project configuration problem, not an
   uninitialized project; stop and show the CLI remedy.
2. Require OpenSpec CLI 1.14.0 or later. An unavailable or older CLI stops
   before any planning or skill write.
3. Inspect `%USERPROFILE%\.agents\skills` as the canonical global skill root.
   Every required custom OpenSpec skill must be a physical directory with a
   `SKILL.md` and no linked entry. `%USERPROFILE%\.codex\skills` is legacy:
   inspect it for migration/conflicts, but never write or delete it implicitly.
4. Inspect project `.agents\skills` and `.codex\skills` only for existing
   copies. Do not create either directory. A link/junction anywhere in a
   candidate skill is unsafe and blocks bootstrap.

## Source decisions

| State | Decision |
| --- | --- |
| Valid global suite; no project suite; no planning root | initialize planning only with `openspec init --tools none` |
| Valid project-local suite, no global suite | use the local suite as an intentional project exception; do not publish it |
| Identical local and global suite | report duplicate discovery; require an explicit retain-local or retire-local choice before changing either copy |
| Differing local and global suite | preserve local as a private fork; do not overwrite, delete, or publish it |
| Partial project-local suite | stop as an incomplete local installation; repair, retain as a deliberate exception, or explicitly retire it |
| Partial/stale/missing global suite | stop; request a trusted library checkout or repository link plus authorization to install globally |
| Legacy `.codex` copy alongside canonical global copy | report whether it is identical, conflicting, or partial; never auto-migrate or delete it |
| Offline without a usable suite | stop with the library source needed; do not create an official local substitute |

An “official generated” project-local suite is identified only when its marker
and complete unmodified generated shape are unambiguous. Otherwise treat it as
a private fork. Retirement or migration always requires a separate explicit
request.

## Trusted installation

Use a selected local library checkout or an explicitly supplied repository URL
as the source of truth. Before global installation, verify the expected custom
suite names and complete file-tree digests, then use `$ai-skills-library-pull`
for the named suite. Do not use a project-local copy as an installation source.
The library is published only through its normal reviewed Git workflow; private
project forks are never pushed back automatically.
