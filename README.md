# pstuart/homebrew-tap

Homebrew formulae for Stuart Technologies tools.

## Install

```bash
brew tap pstuart/tap
# Private release assets (better-markdown) need GitHub auth:
export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)
brew install bmd
brew install barista
```

## Formulae

| Formula | Description | Notes |
|---------|-------------|--------|
| `bmd` | Better Markdown CLI — export/preview markdown |
| `barista` | Claude Code modular statusline | arm64 + Sonoma+; private release tarball |

## Requirements

- **Apple Silicon** (`arm64`) — Intel Macs are not supported by the published binary.
- **macOS Sonoma** or later.
- **GitHub access** to `pstuart/better-markdown` so Homebrew can download the release asset.
