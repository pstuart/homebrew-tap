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

`brew --prefix barista` prints the keg path; use its output in `command` (`/opt/homebrew/...` on Apple Silicon, `/usr/local/...` on Intel).

## Formulae

| Formula | Description | Notes |
|---------|-------------|--------|
| `barista` | Claude Code modular statusline | public source archive; requires Bash and `jq` |

## Requirements

- **barista:** Bash and `jq`; `bc` (macOS ships it, and the formula declares it via `uses_from_macos "bc"`; on Linux, install `bc` with your system package manager).

The formula uses public GitHub downloads and does not require a GitHub token. Update with `brew upgrade barista`. Do not run upstream `install.sh` against a Cellar or `opt` prefix.

## Local formula checks

```bash
brew tap pstuart/tap "$PWD"   # once; uses this clone
brew trust --formula pstuart/tap/barista
./scripts/check-formulae.sh
```

Runs `brew style` on every `Formula/*.rb`. When `pstuart/tap` is installed it also runs `brew audit --strict`. There is no GitHub Actions CI; see `.github/NO_GITHUB_ACTIONS.md`.

Maintainer notes (bump a tag, wrapper vs symlink, do not reintroduce `bmd`) are in [CLAUDE.md](CLAUDE.md).

The `bmd` formula was removed from this public tap; do not reintroduce it here without a macOS 26 (`:tahoe`) floor that matches the published Mach-O `minos`.
