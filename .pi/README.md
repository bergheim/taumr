# `.pi/`

Mirrors the `~/.pi` namespace. Shared material lives under `.pi/agent/` (extensions, settings fragments, prompt bits).

This is not a live `~/.pi`. Never commit `auth.json`, sessions, `MEMORY.md`, or trust stores.

## Extensions

Kit extensions live in `.pi/agent/extensions/` and are **always** named `pi-taumr-<name>`. No unprefixed copies (`usage/`, `clock/`, …). Live `~/.pi` still has the old names until you hitch; do not load both.

Hitch by copying or symlinking a `pi-taumr-*` dir into `~/.pi/agent/extensions/`. Live after `/reload` or a new session.

- `pi-taumr-statusbar` — two-line usage/cost footer plus `/usage` (from live `agent/extensions/usage`)
