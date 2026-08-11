# pstuart/homebrew-tap

Homebrew formulae for Stuart Technologies tools.

## Install

```bash
brew tap pstuart/tap
brew install bmd
brew install barista
```

## Formulae

| Formula | Description | Notes |
|---------|-------------|--------|
| `bmd` | Better Markdown CLI — export/preview markdown | public release asset; Apple Silicon and macOS Sonoma+ |
| `barista` | Claude Code modular statusline | public source archive; requires Bash and `jq` |

## Requirements

- **bmd:** Apple Silicon (`arm64`) and macOS Sonoma or later.
- **barista:** Bash and `jq`; `bc` is recommended for decimal calculations.

Both formulae use public GitHub downloads and do not require a GitHub token.

## Release packaging (bmd)

Public `bmd` release archives must ship only the CLI binary and the
`BetterMarkdownKit.framework` runtime dylib. Do **not** include
`Headers/`, `Modules/*.swiftmodule`, or `.swiftsourceinfo` — those leak
private-product paths from the private `better-markdown` build tree.

Rebuild/upload the GitHub release asset with a stripped framework if an
older archive still contains those paths.
