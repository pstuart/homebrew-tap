# No GitHub Actions

This repository does **not** use GitHub Actions for CI, tests, lint, deploy, or releases.

Validate formulae locally:

```bash
brew tap pstuart/tap "$PWD"   # once; uses this clone
./scripts/check-formulae.sh
```

That runs `brew style` on every `Formula/*.rb`. When the tap is installed it also runs `brew audit --strict`.

Do not add `.github/workflows/*.yml`.
