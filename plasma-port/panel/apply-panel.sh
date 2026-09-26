#!/usr/bin/env bash
# Apply sky-panel.js to the running Plasma shell. Backs up the current layout first.
# Undo: copy the backup back over ~/.config/plasma-org.kde.plasma.desktop-appletsrc
# and run `plasmashell --replace &`.
set -euo pipefail
here=$(dirname "$(readlink -f "$0")")
cfg=~/.config/plasma-org.kde.plasma.desktop-appletsrc
[[ -f $cfg ]] && cp -a "$cfg" "$cfg.bak-$(date +%Y%m%d-%H%M%S)"
gdbus call --session --dest org.kde.plasmashell --object-path /PlasmaShell \
    --method org.kde.PlasmaShell.evaluateScript "$(cat "$here/sky-panel.js")"
echo "panel applied; backup: $(ls -t "$cfg".bak-* 2>/dev/null | head -1)"
