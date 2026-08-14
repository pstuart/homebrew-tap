#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

if ! command -v brew >/dev/null 2>&1; then
  echo "brew is required to audit formulae" >&2
  exit 1
fi

brew style "$root/Formula/barista.rb"
