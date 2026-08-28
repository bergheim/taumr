# AGENTS.md

## Scope Discipline

- Do only the work directly requested. Do not add adjacent audits, cleanup, or discovery.
- Scope reads to paths the user named. Never scan a parent directory to understand one named child.
- Before broadening scope, explain why and get explicit approval.
- Never read ignored files, caches, credentials, sessions, editor configuration, or machine-local state unless the user explicitly names the exact path.
- For commit review, list untracked files with `git ls-files --others --exclude-standard` and inspect only exact Git-visible paths. Never recursively inspect a directory merely because Git reports it as untracked.
- Stop after the requested phase. Do not automatically continue into adjacent work.
