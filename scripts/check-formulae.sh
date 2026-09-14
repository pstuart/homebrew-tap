#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "${root}"

if ! command -v brew >/dev/null 2>&1; then
  echo "brew is required to audit formulae" >&2
  exit 1
fi

shopt -s nullglob
formulae=(Formula/*.rb)
if ((${#formulae[@]} == 0)); then
  echo "no formulae in Formula/" >&2
  exit 1
fi

# When this tap is also installed under /opt/homebrew/Library/Taps, checking
# the local files directly makes RuboCop load the same formula classes from
# both locations and misfire Lint/DuplicateMethods, and it reports
# Style/Documentation on bare files outside a tap context. In that case the
# tap-qualified check below covers style for the installed copy, so skip the
# local style pass; otherwise run it on the local files directly.
if brew tap | grep -qx "pstuart/tap"; then
  names=()
  for formula in "${formulae[@]}"; do
    names+=("pstuart/tap/$(basename "$formula" .rb)")
  done
  brew style "${names[@]}"
  brew audit --strict "${names[@]}"
else
  brew style "${formulae[@]}"
  echo "skip brew audit: tap pstuart/tap is not installed" >&2
  echo "  brew tap pstuart/tap \"$root\"" >&2
fi
