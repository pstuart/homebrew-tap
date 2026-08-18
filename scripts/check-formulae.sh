#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

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

brew style "${formulae[@]}"

if brew tap | grep -qx "pstuart/tap"; then
  names=()
  for formula in "${formulae[@]}"; do
    names+=("pstuart/tap/$(basename "$formula" .rb)")
  done
  brew audit --strict "${names[@]}"
else
  echo "skip brew audit: tap pstuart/tap is not installed" >&2
  echo "  brew tap pstuart/tap \"$root\"" >&2
fi
