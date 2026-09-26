#!/usr/bin/env bash
# KWin like whitebook's picom: shadows and fade, no blur, no bouncy animations.
# Only effect toggles and the desktop count; NO window rules (the owner wants Plasma stock).
set -euo pipefail
k() { kwriteconfig6 --file kwinrc "$@"; }
k --group Plugins --key blurEnabled false
k --group Plugins --key contrastEnabled false
k --group Plugins --key kwin4_effect_fadeEnabled true
k --group Plugins --key kwin4_effect_squashEnabled false
k --group Plugins --key kwin4_effect_scaleEnabled false
k --group Plugins --key magiclampEnabled false
k --group Plugins --key wobblywindowsEnabled false
k --group Desktops --key Number 5
k --group Desktops --key Rows 1
# borders: thin, titlebar buttons minimize / maximize / close on the right (Windows order)
k --group org.kde.kdecoration2 --key BorderSize Tiny
k --group org.kde.kdecoration2 --key ButtonsOnLeft ""
k --group org.kde.kdecoration2 --key ButtonsOnRight IAX
qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || gdbus call --session --dest org.kde.KWin --object-path /KWin --method org.kde.KWin.reconfigure >/dev/null
echo "kwin reconfigured"
