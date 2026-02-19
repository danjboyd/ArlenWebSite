#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
arlen_root="$repo_root/vendor/Arlen"
output_root="$repo_root/public/docs/latest"

if [[ ! -d "$arlen_root" ]]; then
  echo "error: missing Arlen submodule at $arlen_root" >&2
  exit 1
fi

if [[ -f /usr/GNUstep/System/Library/Makefiles/GNUstep.sh ]]; then
  had_nounset=0
  case $- in
    *u*) had_nounset=1 ;;
  esac
  set +u
  # shellcheck source=/dev/null
  source /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
  if [[ "$had_nounset" -eq 1 ]]; then
    set -u
  fi
fi

echo "Building docs HTML from $arlen_root"
make -C "$arlen_root" docs-html

mkdir -p "$output_root"
if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete "$arlen_root/build/docs/" "$output_root/"
else
  find "$output_root" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
  cp -R "$arlen_root/build/docs/." "$output_root/"
fi

echo "Synced docs to $output_root"
