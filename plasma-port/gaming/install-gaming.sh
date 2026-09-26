#!/usr/bin/env bash
# Gaming and dev stack for the Legion 5 (Intel + GTX 1660 Ti, nvidia-open). Needs internet.
# Safe to re-run: pacman --needed, yay --needed.
set -euo pipefail

sudo pacman -Syu --needed --noconfirm \
    steam lib32-nvidia-utils lib32-mesa lib32-vulkan-intel \
    gamemode lib32-gamemode mangohud lib32-mangohud gamescope \
    lutris wine-staging winetricks \
    discord obs-studio vlc telegram-desktop \
    godot ttf-dseg

# AUR (yay is installed): Proton-GE manager, Epic/GOG launcher, dev tools the friend used on Windows
yay -S --needed --noconfirm protonup-qt heroic-games-launcher-bin github-desktop-bin unityhub visual-studio-code-bin

# gamemode: let the user's games ask for the performance governor
sudo usermod -aG gamemode "$USER" 2>/dev/null || true

cat <<'EOF'

Done. In Steam: Settings → Compatibility → enable Steam Play for all titles.
Heavy games: launch options `gamemoderun %command%`; overlay: `mangohud %command%`.
Run a game on the NVIDIA GPU outside Steam: `prime-run <program>`.
Proton-GE: open ProtonUp-Qt, add the latest GE-Proton, restart Steam.
EOF
