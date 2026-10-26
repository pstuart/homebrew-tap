#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "${root}"

# Collect Formula/*.rb into the "formulae" array; exit 1 when none exist.
load_formulae() {
  shopt -s nullglob
  formulae=(Formula/*.rb)
  shopt -u nullglob
  if ((${#formulae[@]} == 0)); then
    echo "no formulae in Formula/" >&2
    exit 1
  fi
}

if ! command -v brew >/dev/null 2>&1; then
  echo "brew is required to audit formulae" >&2
  exit 1
fi

load_formulae

# When this tap is also installed under /opt/homebrew/Library/Taps, checking
# the local files directly makes RuboCop load the same formula classes from
# both locations and misfire Lint/DuplicateMethods, and it reports
# Style/Documentation on bare files outside a tap context. In that case the
# tap-qualified names below cover style for the installed copy, so use them
# instead of the local paths; otherwise run it on the local files directly.
if brew tap | grep -qx "pstuart/tap"; then
  targets=()
  for formula in "${formulae[@]}"; do
    targets+=("pstuart/tap/$(basename "$formula" .rb)")
  done
else
  targets=("${formulae[@]}")
fi

brew style "${targets[@]}"

if brew tap | grep -qx "pstuart/tap"; then
  brew audit --strict "${targets[@]}"
else
  echo "skip brew audit: tap pstuart/tap is not installed" >&2
  echo "  brew tap pstuart/tap \"$root\"" >&2
fi
