#!/usr/bin/env bash
# Apply the whitebook look and helpers to KDE Plasma on the Legion 5.
# Idempotent; every step can be skipped with an argument: ./apply.sh [colors] [fonts] [kitty]
# [kbd] [net] [kwin] [pager] [panel]. No arguments = everything except the panel (run it last,
# separately, it replaces the current panel). Backups go to ~/.local/state/plasma-port/.
set -euo pipefail
here=$(dirname "$(readlink -f "$0")")
bak=~/.local/state/plasma-port/$(date +%Y%m%d-%H%M%S)
mkdir -p "$bak" ~/.local/bin ~/.local/share/fonts ~/.local/share/color-schemes \
         ~/.local/share/sky-kbd ~/.config/kitty ~/.config/systemd/user
steps=("$@"); [[ ${#steps[@]} -eq 0 ]] && steps=(colors fonts kitty kbd net kwin pager)
want() { for s in "${steps[@]}"; do [[ $s == "$1" ]] && return 0; done; return 1; }
backup() { for f in "$@"; do [[ -e $f ]] && cp -a "$f" "$bak/" || true; done; }

if want fonts; then
    cp "$here/fonts/Diablo.ttf" ~/.local/share/fonts/
    sudo pacman -S --needed --noconfirm ttf-dseg inter-font ttf-jetbrains-mono-nerd
    fc-cache -f >/dev/null
    echo "fonts: Diablo, DSEG7, Inter, JetBrainsMono Nerd"
fi

if want colors; then
    backup ~/.config/kdeglobals
    cp "$here/colors/Sky.colors" ~/.local/share/color-schemes/
    plasma-apply-colorscheme Sky >/dev/null && echo "colors: Sky (black + #0d8ecb)"
    kwriteconfig6 --file kdeglobals --group General --key AccentColor 13,142,203
    kwriteconfig6 --file kdeglobals --group General --key font "Inter,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    kwriteconfig6 --file kdeglobals --group General --key fixed "JetBrainsMono Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    kwriteconfig6 --file kdeglobals --group General --key menuFont "Inter,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    kwriteconfig6 --file kdeglobals --group General --key toolBarFont "Inter,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    kwriteconfig6 --file kdeglobals --group WM --key activeFont "Inter,10,-1,5,600,0,0,0,0,0,0,0,0,0,0,1"
fi

if want kitty; then
    backup ~/.config/kitty/kitty.conf
    cp "$here/kitty/kitty.conf" "$here/kitty/open-click.py" ~/.config/kitty/
    install -m 755 "$here/kitty/open-path" ~/.local/bin/open-path
    echo "kitty: config, Ctrl+click paths"
fi

if want kbd; then
    sudo pacman -S --needed --noconfirm python-evdev python-gobject libpulse
    sudo usermod -aG input "$USER"   # evdev needs it; takes effect after re-login
    install -m 755 "$here/kbd/sky-kbd" ~/.local/bin/sky-kbd
    cp "$here/kbd/sounds/"*.wav ~/.local/share/sky-kbd/
    cp "$here/systemd/sky-kbd.service" ~/.config/systemd/user/
    # Plasma's own xkb toggle must go, or Alt+Shift switches twice (sky-kbd switches via org.kde.keyboard)
    backup ~/.config/kxkbrc
    kwriteconfig6 --file kxkbrc --group Layout --key Options "grp_led:scroll"
    kwriteconfig6 --file kxkbrc --group Layout --key ResetOldOptions true
    systemctl --user daemon-reload
    systemctl --user enable --now sky-kbd.service
    echo "kbd: Alt+Shift EN/RU, Ctrl+Shift UA, OSD, key sounds (takes effect fully after re-login)"
fi

if want net; then
    install -m 755 "$here/net/netqd" ~/.local/bin/netqd
    install -m 755 "$here/net/panel-ping" ~/.local/bin/panel-ping
    cp "$here/systemd/netqd.service" ~/.config/systemd/user/
    systemctl --user daemon-reload
    systemctl --user enable --now netqd.service
    echo "net: netqd running; add the 'Command Output' widget with ~/.local/bin/panel-ping (see README)"
fi

if want kwin; then
    backup ~/.config/kwinrc
    bash "$here/kwin/effects.sh"
fi

if want pager; then
    # the Diablo workspace strip (Plasma applet); -u upgrades an installed copy
    kpackagetool6 -t Plasma/Applet -u "$here/panel/sky-pager" >/dev/null 2>&1 \
        || kpackagetool6 -t Plasma/Applet -i "$here/panel/sky-pager"
    echo "pager: org.sky.pager installed (appears in the panel after 'apply.sh panel' or 'Додати віджети')"
fi

if want panel; then
    bash "$here/panel/apply-panel.sh"
fi

echo "backups: $bak"
