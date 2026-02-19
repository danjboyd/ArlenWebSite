#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
unit_source="$repo_root/deploy/systemd/arlen-website.service"
unit_dir="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
unit_target="$unit_dir/arlen-website.service"

mkdir -p "$unit_dir"
cp "$unit_source" "$unit_target"

systemctl --user daemon-reload
systemctl --user enable --now arlen-website.service
systemctl --user restart arlen-website.service

echo "Installed $unit_target and started arlen-website.service"
systemctl --user --no-pager --full status arlen-website.service | sed -n '1,30p'
