#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "${root}"

# Dependency-free self-check: validates the script's own bash syntax and the
# Ruby syntax of every formula without requiring brew. Intended for local
# pre-flight in environments without a Homebrew installation; never invokes
# brew. The full brew style/audit lane is the no-arg path below.
if [[ "${1:-}" == "--check" ]]; then
  status=0

  if ! bash -n "$0"; then
    echo "bash syntax check failed: $0" >&2
    status=1
  else
    echo "OK bash -n ${0}"
  fi

  shopt -s nullglob
  formulae=(Formula/*.rb)
  if ((${#formulae[@]} == 0)); then
    echo "no formulae in Formula/" >&2
    exit 1
  fi
  shopt -u nullglob

  for formula in "${formulae[@]}"; do
    if command -v ruby >/dev/null 2>&1; then
      if ! result="$(ruby -c "$formula")"; then
        echo "ruby syntax check failed: $formula" >&2
        status=1
        continue
      fi
      echo "OK $result (${formula})"
    else
      echo "ruby not found; cannot syntax-check: $formula" >&2
      status=1
    fi
  done

  exit "$status"
fi

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
