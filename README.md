# pstuart/homebrew-tap

Homebrew formulae for Stuart Technologies tools.

## Install

```bash
brew tap pstuart/tap
brew install barista
```

## Formulae

| Formula | Description | Notes |
|---------|-------------|--------|
| `barista` | Claude Code modular statusline | public source archive; requires Bash and `jq` |

## Requirements

- **barista:** Bash and `jq`; `bc` is recommended for decimal calculations.

The formula uses public GitHub downloads and does not require a GitHub token.

## Local formula checks

```bash
./scripts/check-formulae.sh
```

Runs `brew style` on `Formula/barista.rb`. The `bmd`
formula was removed from this public tap; do not reintroduce it here without a
macOS 26 (`:tahoe`) floor that matches the published Mach-O `minos`.
