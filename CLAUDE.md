# homebrew-tap

Public Homebrew tap for Stuart Technologies CLI tools. GitHub repo: `pstuart/homebrew-tap`. Users install it as `pstuart/tap`.

## Layout

- `Formula/*.rb` — formulae only. Current: `barista` (Claude Code statusline).
- `scripts/check-formulae.sh` — local `brew style` and, when tapped, `brew audit --strict`.
- `.github/NO_GITHUB_ACTIONS.md` — do not add workflows.

This repo is not a Nuxt site and has no `stuartdeploy` contract. There is no Swift package.

## Do not

- Add `.github/workflows/*.yml`.
- Reintroduce `bmd` / Better Markdown without a macOS 26 (`:tahoe`) floor that matches the published Mach-O `minos`. That formula was removed from this public tap.
- Pin `barista` to a branch or untagged commit. Use a GitHub release tag tarball + sha256.
- Symlink `bin/barista` to `libexec/barista.sh`. `SCRIPT_DIR` is derived from `BASH_SOURCE`; a symlink would look for `modules/` next to the link.

## Bump barista

After a new [Barista](https://github.com/pstuart/Barista) **release tag** (not `main`):

```bash
VERSION=1.x.y
curl -fsSL -o /tmp/barista.tar.gz \
  "https://github.com/pstuart/Barista/archive/refs/tags/v${VERSION}.tar.gz"
shasum -a 256 /tmp/barista.tar.gz
```

Update `url` and `sha256` in `Formula/barista.rb`. Do not add a redundant `version` line when the tag is in the URL (`brew audit --strict` flags it). Keep `livecheck` on `:github_latest`. Leave `lib/` and `modules/` in `libexec`; `barista config` sources `lib/config-tui.sh`.

Caveats must include `statusLine.type: "command"` and the `#{opt_libexec}/barista.sh` path so upgrades keep working.

## Local checks

```bash
brew tap pstuart/tap "$PWD"   # once
brew trust --formula pstuart/tap/barista
./scripts/check-formulae.sh
HOMEBREW_NO_AUTO_UPDATE=1 brew reinstall pstuart/tap/barista
HOMEBREW_NO_AUTO_UPDATE=1 brew test pstuart/tap/barista
```

Homebrew 6 requires tap trust. Prefer `brew install pstuart/tap/barista` (trusts that formula only) over whole-tap `brew trust pstuart/tap`.
