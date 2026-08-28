# AGENTS.md

Guidelines for AI coding assistants working on this project.

Generated: <YYYY-MM-DD>

Keep this file short: it is loaded into every session. Recipes and command
catalogs live in `docs/agent-ops.md`.

## Session Start

- Read `docs/PROJECT.org` and `docs/TODO.org`.
- If `docs/PROJECT.org` is missing, do not start implementation. First ask the
  user for the project purpose, audience, constraints, and key decisions; write
  them to `docs/PROJECT.org`.
- Scan recent note filenames with
  `emacsclient -e '(bergheim/agent-denote-list "docs/notes" 15)'`.
- Read only notes relevant to the task.
- For shared tooling, devcontainers, Emacs, org, denote, or agent behavior, also
  scan `/workspaces/stash/notes`.
- Check `.git`: file means worktree, directory means main checkout.
- Treat `scratch/` as gitignored throwaway space, not project code.

## Communication and Planning

- Assume the user is an experienced developer. Be direct and skip filler.
- Disagree when evidence supports it; explain the reasoning.
- If the user says they took a screenshot, read the newest
  `/workspaces/stash/shot-*.png`.
- Do not implement non-trivial changes without first presenting a plan and
  getting explicit approval. Read/search commands are fine.

## Scope Discipline

- Do only the work directly requested. Do not add adjacent audits, cleanup, or discovery.
- Scope reads to paths the user named. Never scan a parent directory to understand one named child.
- Before broadening scope, explain why and get explicit approval.
- Never read ignored files, caches, credentials, sessions, editor configuration, or machine-local state unless the user explicitly names the exact path.
- For commit review, list untracked files with `git ls-files --others --exclude-standard` and inspect only exact Git-visible paths. Never recursively inspect a directory merely because Git reports it as untracked.
- Stop after the requested phase. Do not automatically continue into adjacent work.

## Project Memory

- `docs/PROJECT.org` holds stable project context and decisions.
- `docs/TODO.org` is the active work log.
- Repo-specific discoveries go in `docs/notes`.
- Cross-project discoveries go in `/workspaces/stash/notes`.
- Install/deploy/config docs (compose, dotfiles, service defs, homelab) are
  host-level → `/workspaces/stash/notes`, as a literate cookbook: one org note
  with `:tangle <path> :mkdirp yes` src blocks, not a folder of loose files.
- Heuristic: Would I want this loaded at session start in an unrelated project?
  If yes, use stash.
- Stash is `/workspaces/stash` in containers and `~/stash` on the host. Write
  the container path; use the host path when telling the user to run something
  themselves.
- Denote notes are living documents: edit in place as understanding grows; git
  is the history layer. Editing a note (even retitling via denote) never breaks
  backlinks — they resolve by the immutable identifier, not the filename. One
  note = one topic. Create a new note only for a genuinely new topic, and link
  it. Prefer refining/consolidating over spawning near-duplicates.
- Never hard-wrap prose in notes or TODO bodies: one line per paragraph.
  Emacs soft-wraps on read, and the helpers unfill what you pass. Hard newlines
  are for structure only — headings, list items, table rows, src blocks.
- To link notes, always use `bergheim/agent-denote-link`; never hand-write
  `[[denote:ID]]` or a bare id (denote derives backlinks only from links its own
  API emits, so a typed id never registers).
- TODO → note uses `bergheim/agent-org-entry-link-note`. Note → TODO is forbidden.
  Do not put `TODO.org` in `denote-directory`.
- New custom `.org` files under `docs/` must use denote filenames:
  `YYYYMMDDTHHMMSS--title-slug__kind_topic.org`.
- Fixed files such as `docs/PROJECT.org` and `docs/TODO.org` are exceptions.
- Personal memories are agent-specific: `.claude/MEMORY.md`,
  `.gemini/MEMORY.md`, `.codex/MEMORY.md`, `.pi/MEMORY.md`.

## Task Tracking

`docs/TODO.org` is the source of truth.

- Before starting work, check for an existing TODO.
- Ad-hoc work with no heading still needs a paper trail: `agent-org-task-create`
  when you start, `DONE` when you land. That feeds the worklog. Untracked
  landings leave no trace.
- When starting a tracked task, mark it `INPROGRESS` with the org helper.
- Mark completed work `DONE` immediately, not at session end.
- Mark obsolete work `CANCELLED` with a reason.
- Preserve TODO body text when closing.
- Use `WAITING` when blocked, on a person or a system.

Use `bergheim/agent-org-task-set-state` for org state changes; never hand-edit TODO
keywords. Include `$(agent-meta --elisp)` as the AGENT/SESSION-ID args so the
transition is attributed; never hand-type a model name. Mutating `bergheim/agent-org-*` and `bergheim/agent-denote-*` helpers return a
plist with `:wrote`. Re-read every listed path before any later edit.

`:autonomous:` TODOs may only be tagged after per-item user agreement. Tag only
when all criteria hold:

- Bounded: the agent can verify "done" itself.
- In-container: no host Emacs, systemd, DNS, sudo, Tailscale, or other host step.
- Non-destructive: reversible by git reset plus branch deletion; no force-push.
- No external prompts: no auth dances, trust dialogs, MFA, or browser logins.
- Decision-free: no "decide first" or "consider whether" work remains.
- One branch: fits one branch.
- Self-contained: heading plus body is enough for a fresh agent.

Add/remove the tag only with `bergheim/agent-org-entry-add-tag` /
`bergheim/agent-org-entry-remove-tag`.

Helper examples are in `docs/agent-ops.md`.

## Development

- Use `just --list` as the command menu.
- Custom commands belong in the justfile with a `# comment` description.
- The dev server is expected to already be running via `just dev` with reload.
  Do not start temporary servers on other ports for screenshots or tests.
- Use `just dev-restart` after dependency/config changes or server crashes.
- `dev.log` is a tee of dev-server stdout/stderr; read it like a normal file.
- Use `$PORT` in every server command and URL. Do not hardcode 4000.
- Servers bind to `0.0.0.0` for container networking; browser/curl connect to
  `localhost:$PORT`.
- Node projects use pnpm. Do not introduce npm/npx flows.

| Task | Command |
|------|---------|
| List recipes | `just --list` |
| Run dev server | `just dev` |
| Restart dev server | `just dev-restart` |
| Run once | `just run` |
| Run tests | `just test` |
| Watch tests | `just test-watch` |
| Add dependency | `just add NAME` |
| Manage worktrees | `just wt` (`help`, `new`, `sync`, `land --rm`) |
| Run performance probe | `just perf` |

## Git

Work on the current checkout. Never create a worktree (`just wt new`,
`jolo tree`, `grok --worktree`, grok `/fork`, `claude --worktree`,
EnterWorktree) unless the user explicitly asks for one.

When they do ask, **`just wt` is the worktree CLI** — do not hand-roll, and
do not use harness-native worktrees (they land under `~/.grok` or
`.claude/worktrees` and magit cannot switch to them). `just wt help` is the
menu. Do not reverse-engineer `/usr/local/bin/wt`.

- Finish: **`just wt land <name> --rm`** from the main tree (the branch you
  want to merge into, usually `main`). Rebases, fast-forwards one commit or
  `--no-ff` merges several, pushes if a remote exists, then removes
  worktree, branch, and tmux window. Merging plus `wt delete` by hand is
  that same path, slower and less safe.
- Default workflow: commit on the current branch and push if a remote exists
  unless the user says not to.
- Branch names: `feat/<slug>`, `fix/<slug>`, `docs/<slug>`, `chore/<slug>`,
  `refactor/<slug>`, `test/<slug>`.
- Keep history rebased and linear.
- Merge feature branches into `main`, not into each other.
- Use merge commits for multi-commit branches; fast-forward single-commit
  branches. `wt land` picks the right one by commit count.
- After a merge, the branch and its worktree must go — a leftover merged
  branch is read as unfinished work. `just wt delete <name>` is only for
  abandoning unmerged work.
- Never use `git reset --hard`, `git checkout --`, or `git commit --no-verify`
  unless explicitly requested.
- Never `git add -A` or `git add .`. Stage named paths. `-A` sweeps untracked agent homes, scratch, and `.devcontainer`; `rebase --abort` then deletes them from disk.
- In a worktree, do not checkout `main`; find the main tree with
  `git worktree list`.
- Worktrees belong in `$WORKSPACE/.worktrees/` via `just wt`.

## Code Quality

- Pre-commit hooks are installed. If a hook blocks commit, fix the issue and
  retry; never skip hooks.
- Prefer small, direct code and established project patterns.
- Add type annotations and use strict mode where the language supports it.
- Add abstractions only when they remove real complexity.
- Validate at boundaries; do not duplicate internal checks.
- Comments explain why, not what. Keep them rare and short.
- Test behavior through public contracts, not implementation details.

## Frontend and Browser Work

Browsing and screenshots are pre-installed. **NEVER** install a browser,
`puppeteer`, `playwright`, `chromium`, or any screenshot tool — they are already
on PATH. Use them directly:

- `browser-check <url>` — one-shot: `--screenshot`, `--console`, `--errors`,
  `--aria` snapshot. The default for quick checks and screenshots. `<url>` may
  be `file://`. For phone-first work add `--width 320,390,430` (one launch, one
  file per width) and `--overflow`, which exits 1 if the page scrolls sideways.
- `playwright-cli` — multi-step interactive flows (open, click, fill, snapshot).
- `fetch-asset <url> <dest>` — download a file (vendored artwork, fonts). Those
  two are page tools and cannot save an arbitrary asset; bare `curl` will write
  an HTML error page into a `.png` and report success. `fetch-asset` checks the
  status and the magic bytes, and writes nothing if they disagree.
- After visible UI changes, screenshot the running app and inspect it before
  committing. Run `just a11y` when present.
- Use semantic HTML, labeled inputs, keyboard-reachable controls, visible focus
  styles, useful alt text, and AA contrast.

## Host and Container Boundaries

- Shared, non-reproducible resources live in `/workspaces/stash`.
- `share <path>` publishes an artifact from stash when a browser-viewable URL is
  useful.
- Cross-container Podman access is off by default and must be enabled from the
  host. `Cannot connect to Podman ... no such file or directory` is the off state.
- Host-only operations stay host-only. If a task needs host sudo, Tailscale, DNS,
  systemd, or trust dialogs, explain the manual step, and record the host-side
  procedure in `/workspaces/stash/notes` via `bergheim/agent-denote-*` — it does
  not persist in container state.
- Emacs runs as a daemon. Use `emacsclient --eval`; never ask the user to run
  interactive Emacs commands.

## More Recipes

Read `docs/agent-ops.md` only when needed for:

- Worktree catalog (`just wt help`; do not reverse-engineer `/usr/local/bin/wt`).
- Exact org/denote `emacsclient` forms.
- Browser-check and Playwright command catalogs.
- Port, notify, share, asset fetching, image, perf, and podman operations.
- Local llama-swap curl examples.
- Cross-agent review snippets.
