# Agent Operations

Recipes for generated jolo projects. Read this on demand; keep `AGENTS.md` for
rules that matter every session.

Before assuming the helper list is complete, inspect the live Emacs daemon:

```bash
emacsclient -e '(apropos-internal "^bergheim/agent-")'
```

## Org Helpers

Public arglists:

- `bergheim/agent-org-task-set-state FILE HEADING-RE NEW-STATE &optional NOTE AGENT SESSION-ID`
- `bergheim/agent-org-task-set-state-by-id FILE ID NEW-STATE &optional NOTE AGENT SESSION-ID`
- `bergheim/agent-org-task-schedule FILE LOCATOR DATE &optional BY-ID`
- `bergheim/agent-org-task-deadline FILE LOCATOR DATE &optional BY-ID`
- `bergheim/agent-org-entry-ensure-id FILE HEADING-RE`
- `bergheim/agent-org-task-add-log FILE HEADING-RE NOTE`
- `bergheim/agent-org-entry-add-tag FILE HEADING-RE TAG`
- `bergheim/agent-org-entry-remove-tag FILE HEADING-RE TAG`
- `bergheim/agent-org-task-create FILE HEADING &optional BODY TAGS STATE`
- `bergheim/agent-org-entry-link-note ORG-FILE LOCATOR NOTE-PATH &optional BY-ID`
- `bergheim/agent-org-task-list ORG-FILE &optional STATES`
- `bergheim/agent-org-entry-get FILE LOCATOR &optional BY-ID`
- `bergheim/agent-org-task-autonomous-select ORG-FILE`
- `bergheim/agent-org-task-autonomous-mark-dispatched ORG-FILE POSITION TIMESTAMP`
- `bergheim/agent-worklog-recent &optional N`

```bash
emacsclient -e '(bergheim/agent-org-task-set-state "docs/TODO.org" "TODO Heading text here" "DONE")'
emacsclient -e '(bergheim/agent-org-task-set-state "docs/TODO.org" "TODO Heading text here" "DONE" "Resolved by commit abc1234.")'
emacsclient -e '(bergheim/agent-org-task-set-state "docs/TODO.org" "TODO Heading text here" "CANCELLED" "No longer relevant because X.")'
emacsclient -e '(bergheim/agent-org-task-add-log "docs/TODO.org" "TODO Heading" "Made progress on X.")'
emacsclient -e '(bergheim/agent-org-entry-ensure-id "docs/TODO.org" "TODO Heading")'
emacsclient -e '(bergheim/agent-org-task-set-state-by-id "docs/TODO.org" "abc-def-123" "DONE")'
emacsclient -e '(bergheim/agent-org-task-schedule "docs/TODO.org" "TODO Heading" "2026-08-25")'
emacsclient -e '(bergheim/agent-org-task-deadline "docs/TODO.org" "abc-def-123" "2026-08-30" t)'
emacsclient -e "(bergheim/agent-org-task-set-state \"docs/TODO.org\" \"TODO Heading\" \"INPROGRESS\" nil $(agent-meta --elisp))"
emacsclient -e '(bergheim/agent-org-entry-add-tag "docs/TODO.org" "TODO Heading" "autonomous")'
emacsclient -e '(bergheim/agent-org-entry-remove-tag "docs/TODO.org" "TODO Heading" "autonomous")'
emacsclient -e '(bergheim/agent-org-task-create "docs/TODO.org" "New task heading" "Body text." (quote ("topic")) "TODO")'
emacsclient -e '(bergheim/agent-org-entry-link-note "docs/TODO.org" "TODO Heading" "/abs/path/to/note.org")'
emacsclient -e '(bergheim/agent-org-task-list "docs/TODO.org")'
emacsclient -e '(bergheim/agent-org-entry-get "docs/TODO.org" "TODO Heading")'
emacsclient -e '(bergheim/agent-org-entry-get "docs/TODO.org" "abc-def-123" t)'
emacsclient -e '(bergheim/agent-worklog-recent 10)'
```

States: `TODO`, `NEXT`, `INPROGRESS`, `WAITING`, `DONE`,
`CANCELLED`.

## Denote Helpers

Public arglists:

- `bergheim/agent-denote-create DIR TITLE KEYWORDS &optional BODY`
- `bergheim/agent-denote-find DIR &optional KEYWORDS TITLE-RE`
- `bergheim/agent-denote-get FILEPATH`
- `bergheim/agent-denote-update FILEPATH &rest CHANGES`
- `bergheim/agent-denote-list DIR &optional LIMIT`
- `bergheim/agent-denote-link SOURCE-PATH TARGET-PATHS`
- `bergheim/agent-denote-backlinks FILEPATH`

`agent-denote-list` returns only `:id`, `:title`, and `:keywords`. Use
`agent-denote-find` when a path is needed.

```bash
emacsclient -e '(bergheim/agent-denote-create "docs/notes" "Title here" (quote ("kind" "topic1" "topic2")) "Body text.")'
emacsclient -e '(bergheim/agent-denote-find "docs/notes" (quote ("emacs")))'
emacsclient -e '(bergheim/agent-denote-list "docs/notes")'
emacsclient -e '(bergheim/agent-denote-get "/abs/path/to/note.org")'
emacsclient -e '(bergheim/agent-denote-update "/abs/path/to/note.org" :title "New title" :keywords (quote ("research")) :body "New body.")'
emacsclient -e '(bergheim/agent-denote-link "/abs/path/to/source.org" (quote ("/abs/path/to/target1.org" "/abs/path/to/target2.org")))'
emacsclient -e '(bergheim/agent-denote-backlinks "/abs/path/to/note.org")'
emacsclient -e '(bergheim/agent-denote-list "/workspaces/stash/notes" 15)'
```

## Ports and Dev Server

Use `$PORT` in every server command and URL.

```bash
echo "$PORT"
vite --host 0.0.0.0 --port "$PORT"
next dev -H 0.0.0.0 -p "$PORT"
flask run --host 0.0.0.0 --port "$PORT"
uvicorn app:app --host 0.0.0.0 --port "$PORT"
```

Clients connect to localhost:

```bash
curl "http://localhost:$PORT/healthz"
browser-check "http://localhost:$PORT" --describe --console --errors
playwright-cli open "http://localhost:$PORT"
```

## just Recipes

```bash
just --list
just dev
just dev-restart
just run
just test
just test-watch
just add <dependency>
just perf
just wt
```

`dev.log` is a tee of the dev server output.

## Git and Worktrees

Do not `just wt new` (or `jolo tree`, or harness `--worktree`) unless the
user explicitly asked for a worktree. Work on the current checkout.

`just wt` is the only worktree interface. Do not read `/usr/local/bin/wt`
to reverse-engineer it — `just wt help` is the catalog.

`wt new` creates the tmux window detached. `--switch` (or `-s`) focuses it;
`wt <name>` also switches.

`wt land` (must run from the main tree, both trees clean):

- rebases `<name>` onto the main tree's current branch (usually `main`)
- 1 commit → `--ff-only`; several → `--no-ff`; 0 → already up to date
- pushes the target if `origin` exists
- `--rm` then runs `wt delete` (worktree + branch + tmux window)

`wt delete` force-removes the worktree, its branch, and the tmux window,
prompting on uncommitted changes. Use only to abandon; landing already
deletes via `--rm`.

Detect checkout type:

```bash
test -f .git && echo "worktree" || echo "main repo"
```

## Pre-commit Linters

| Files | Linter | Hook repo |
|-------|--------|-----------|
| `*.py` | ruff | `https://github.com/astral-sh/ruff-pre-commit` |
| `*.go` | golangci-lint | `https://github.com/golangci/golangci-lint` |
| `*.rs` | clippy/rustfmt | `https://github.com/doublify/pre-commit-rust` |
| `*.ts/*.js` | biome | `https://github.com/biomejs/biome` |
| `*.sh` | shellcheck | `https://github.com/shellcheck-py/shellcheck-py` |
| `Dockerfile` | hadolint | `https://github.com/hadolint/hadolint` |
| `*.yaml/*.yml` | yamllint | `https://github.com/adrienverge/yamllint` |
| `playbook*.yml` | ansible-lint | `https://github.com/ansible/ansible-lint` |

## Browser Automation

Use `browser-check` for one-shot checks:

```bash
browser-check "http://localhost:$PORT" --describe --console --errors
browser-check "http://localhost:$PORT" --screenshot --output scratch/verify.png
browser-check "http://localhost:$PORT" --screenshot --full-page --output scratch/full.png
browser-check "http://localhost:$PORT" --aria
browser-check "http://localhost:$PORT" --aria --interactive --json
browser-check "http://localhost:$PORT" --pdf --output scratch/page.pdf
```

Phone-first checks — `--width` runs each width in its own context from one
launch and suffixes outputs when given more than one; `--overflow` exits 1 if
the page scrolls sideways (a box with `overflow-x: auto|scroll` is not flagged):

```bash
browser-check "http://localhost:$PORT" --overflow --width 320,390,430
browser-check "http://localhost:$PORT" --screenshot --width 320,390,430 --output scratch/p.png
# -> scratch/p-320.png, scratch/p-390.png, scratch/p-430.png
browser-check file:///tmp/prototype.html --overflow --width 320   # file:// works
```

With `--json`, per-width results live in `viewports[]`, not at the top level.

Use `playwright-cli` for stateful flows:

```bash
playwright-cli open "http://localhost:$PORT"
playwright-cli -s=default snapshot
playwright-cli -s=default click e12
playwright-cli -s=default fill e20 "hello"
playwright-cli -s=default screenshot --filename scratch/after-click.png
playwright-cli -s=default close
```

Verification reports should include URL, exact command, success/failure evidence,
and artifact path when generated.

## Accessibility

```bash
just a11y
just a11y --include-notices "http://localhost:$PORT/some-page"
browser-check "http://localhost:$PORT" --aria
browser-check "http://localhost:$PORT" --aria --interactive
```

WCAG 2.2 AA is the minimum target.

## Notify and Share

Set the route used by completion notifications:

```bash
notify set-path /dashboard
notify set-path /article/123
notify set-path /
```

Share artifacts through the host stash:

```bash
share foo.png
share .
share /path/to/file
```

## Fetching Assets

`browser-check` and `playwright-cli` render pages; they cannot save an arbitrary
file. Use `fetch-asset` to vendor artwork, fonts, or any downloaded file:

```bash
fetch-asset https://example.org/drawing.png public/art/drawing.png
fetch-asset https://example.org/font.woff2 public/fonts/font.woff2
```

It sends a real User-Agent with a contact address, follows redirects, creates
missing parent directories, and prints the path and byte count it wrote.

It exits non-zero and writes nothing when the response is non-2xx, the body is
empty, or the body does not match the destination extension — the case that
matters is a site answering with an HTML error page that bare `curl` would
happily save as a `.png`, leaving an image that renders blank with nothing
reporting a failure. An existing file at the destination is never clobbered by
a failed fetch.

Override the User-Agent for a single call with `FETCH_ASSET_UA`. Do not paper
over a refusal by falling back to raw `curl` — a refusal means the bytes are
wrong.

## Image Tooling

Preferred formats: AVIF > WebP > PNG/JPEG.

```bash
vips copy input.png output.avif[Q=30]
cwebp -q 80 input.png -o output.webp
vipsthumbnail input.jpg -s 800x -o output.avif[Q=30]
```

Use vips/avifenc/cwebp; do not add ImageMagick or Pillow unless the project
requires them.

## Podman Gate

Host-side activation:

```sh
jolo allow podman <project>
cd <project> && jolo up --recreate
jolo deny podman <project>
jolo allow podman <project>
jolo allowed
```

Inside the container when allowed:

```sh
podman ps
podman exec other-project ls /workspaces
podman logs --tail 50 other-project
```

## Performance

`just perf` posts `perf-rig.toml` to the host-side perf hub. The target URL in
`perf-rig.toml` must be externally reachable; keep it symbolic with
`${DEV_HOST}` and `${PORT}`.

`PERF_HOST` flows from the host shell into devcontainers. Override
`PERF_TESTBED` when a worktree or CI runner needs a distinct baseline.

## Local Models

`LLAMA_HOST` points to a llama-swap OpenAI-compatible router.

```bash
curl -s "$LLAMA_HOST/v1/models" | jq '.data[].id'
curl -s "$LLAMA_HOST/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d '{"model":"gemma4","messages":[{"role":"user","content":"..."}]}'
curl -s "$LLAMA_HOST/v1/completions" \
  -H "Content-Type: application/json" \
  -d '{"model":"gemma4","prompt":"..."}'
curl -s "$LLAMA_HOST/v1/embeddings" \
  -H "Content-Type: application/json" \
  -d '{"model":"bge-m3","input":"..."}'
```

Use `/v1/*` endpoints so llama-swap loads the requested model.

## Cross-Agent Reviews

Unset API keys so peer CLIs use their own auth:

```bash
echo "$diff" | env -u ANTHROPIC_API_KEY -u OPENAI_API_KEY claude -p "Review this..."
```

Lean Codex text review:

```bash
OUT=$(mktemp)
printf '%s\n' "$PROMPT_PREFIX" "$DIFF_OR_PLAN" | env -u ANTHROPIC_API_KEY -u OPENAI_API_KEY codex exec \
  -s read-only \
  -c model_reasoning_effort=low \
  --ephemeral \
  -o "$OUT" - > /dev/null 2>&1
cat "$OUT"
rm -f "$OUT"
```

Prompt directive:

```text
Review only the text shown. Do not read other files, run commands, or search the codebase. Respond under 300 words with findings and severity.
```

Use `codex review --uncommitted` only when repository exploration is desired.
