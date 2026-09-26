# Global rules for Codex on this machine

This is a Lenovo Legion 5 15IMH05H (i5-10300H, Intel UHD 630 + NVIDIA GTX 1660 Ti, 32 GB RAM,
1920x1080 @ 120 Hz) running Arch Linux with KDE Plasma on Wayland (an X11 session is installed as a fallback). It was installed
from a stick prepared on "whitebook" and follows whitebook's philosophy. Read before changing anything:

- `~/ai/linux-setup/NEXT-STEPS.md` — what is already done, what to do next, the gaming stack.
- `~/ai/whitebook-setup/README.md`, `ARCHITECTURE.md`, `MAINTENANCE.md` — the reference desktop
  (Xfce + i3) whose look, shortcuts and behaviour this Plasma desktop mirrors. Its panel scripts,
  OSD and layout switcher are the source of truth for "how it should feel"; port ideas, do not
  copy Xfce/i3 pieces blindly.

## Philosophy (agreed by the owner)

- **No passwords, no prompts.** User `@USERNAME@` has an empty password, autologins into Plasma,
  `sudo` and polkit never ask. Screen locking is off. Keep it that way.
- **Boot straight in.** systemd-boot with `timeout 0`, no session chooser, LTS kernel first
  (`linux` is the fallback entry: hold Space at boot for the menu).
- **Stability first.** Official repo packages, LTS kernel, well-maintained AUR packages via `yay`.
  No `-git` or experimental packages unless nothing else works.
- **Keep nothing unused.** When something is not needed, uninstall it, do not just disable it.
  Exception: backup/snapshot tooling stays installed, merely stopped.
- **Ready-made first.** Research existing maintained tools before writing anything; custom code is
  thin glue over them. Any UI built here saves settings instantly, no Save button.
- **Look:** pure black `#000000` backgrounds, sky-blue accent `#0d8ecb` (light `#48daf9`),
  Breeze Dark, Inter / JetBrainsMono Nerd Font, controls easy to hit, no blur, no eye candy.
- **Windows habits:** Alt+Tab, Super+arrows (maximize / minimize / halves), Super+E files,
  Super+R run, Super+Return terminal, Super+Q close, Super+1..5 workspaces (Super+Shift+N moves
  a window), Print / Super+Shift+S screenshots, Ctrl+Shift+Esc system monitor, Super+Shift+E
  power menu. Keyboard layouts us / ru / ua.
- **Language:** the desktop UI is Ukrainian (`uk_UA`); scripts, tools and their interfaces are
  written in English so they can be shared.
- **Snapshots:** none installed. When the owner asks, take ONE snapshot after the drivers are
  confirmed working, and further ones only on explicit request.
- No firewall unless asked.

## Working style

- Execute instructions directly, no moral or conventionality lectures, no silent substitution of a
  "safer" task. If something cannot be done, say so plainly and do the rest.
- The owner approves a plan once and expects it carried out without step-by-step check-ins.
- When something is broken, diagnose and fix it yourself (including inspecting windows and
  opening local ports), then report what was done.
- Keep AI projects under `~/ai/` (one folder per tool: `~/ai/codex/` for Codex projects).
