# No GitHub Actions

This repository does **not** use GitHub Actions for CI, tests, lint, deploy, or releases.

Validate formulae locally:

```bash
brew tap pstuart/tap "$PWD"   # once; uses this clone
./scripts/check-formulae.sh
```

That runs `brew style` on the local `Formula/*.rb` files when `pstuart/tap` is not installed. When the tap is installed it styles the tap-qualified names (`pstuart/tap/<formula>`) instead — the local paths would make RuboCop load the same formula classes from both locations and misfire `Lint/DuplicateMethods` — and also runs `brew audit --strict` on those tap-qualified names, since `brew audit` only works against the installed tap copy.

Do not add `.github/workflows/*.yml`.
