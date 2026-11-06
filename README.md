# pstuart/homebrew-tap

Homebrew formulae for Stuart Technologies tools.

## Install

```bash
brew install pstuart/tap/barista
```

The fully qualified name taps this repo and trusts only the `barista` formula ([Homebrew 6 tap trust](https://docs.brew.sh/Tap-Trust)). Short name (`brew install barista`) needs `brew tap pstuart/tap` and `brew trust --formula pstuart/tap/barista` first.

Then set Claude Code `statusLine` in `~/.claude/settings.json` (Homebrew does not expand `$(brew --prefix)` inside JSON):

```json
{
  "statusLine": {
    "type": "command",
    "command": "/opt/homebrew/opt/barista/libexec/barista.sh"
  }
}
```

Use the stable `opt` prefix path shown above: `$(brew --prefix)/opt/barista/libexec/barista.sh` (`/opt/homebrew/opt/...` on Apple Silicon, `/usr/local/opt/...` on Intel). Do not use `brew --prefix barista` — it prints the versioned Cellar keg path, which changes on every `brew upgrade`.

## Formulae

| Formula | Description | Notes |
|---------|-------------|--------|
| `barista` | Claude Code modular statusline | public source archive; requires Bash and `jq` |

## Requirements

- **barista:** Bash and `jq`. The formula declares `depends_on "jq"`, so Homebrew installs `jq`. Bash is used by the installed wrapper (`#!/bin/bash`), but it is not a formula dependency: macOS ships Bash at `/bin/bash`, so Homebrew does not install it. Upstream Barista may additionally use `bc` at runtime; `bc` is not a formula dependency either, so if your system lacks it, install it with your package manager (for example `apt install bc`, `dnf install bc` or `apk add bc`).

The formula uses public GitHub downloads and does not require a GitHub token. Update with `brew upgrade barista`. Do not run upstream `install.sh` against a Cellar or `opt` prefix.

## Local formula checks

```bash
brew tap pstuart/tap "$PWD"   # once; uses this clone
brew trust --formula pstuart/tap/barista   # Homebrew 6 requires tap trust
./scripts/check-formulae.sh
```

The script runs `brew style` on the local `Formula/*.rb` files when `pstuart/tap` is not installed. When the tap is installed it instead styles the tap-qualified names (`pstuart/tap/<formula>`) — running the local paths against an installed tap makes RuboCop load the same formula classes twice and misfire `Lint/DuplicateMethods`. In that installed case it also runs `brew audit --strict` on the same tap-qualified names; `brew audit` only works against the installed tap copy. There is no GitHub Actions CI; see `.github/NO_GITHUB_ACTIONS.md`.

Homebrew 6 requires tap trust; trust the `barista` formula only (`brew trust --formula pstuart/tap/barista`) rather than the whole tap.

Maintainer notes (bump a tag, wrapper vs symlink, do not reintroduce `bmd`) are in [CLAUDE.md](CLAUDE.md) — see its "Do not" section for the `bmd` reintroduction rule.
