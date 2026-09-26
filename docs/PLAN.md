# PLAN — Arch + KDE Plasma for the friend's Lenovo Legion 5

Status: built and tested in QEMU on 2026-09-25; the stick is written from `build/out/`.

## Target machine (from the screenshots)

| | |
|---|---|
| Model | Lenovo Legion 5 15IMH05H (81Y6), BIOS EFCN58WW 2022-11 |
| CPU | Intel i5-10300H (Comet Lake, 4c/8t) |
| GPU | Intel UHD 630 (iGPU) + NVIDIA GTX 1660 Ti (Turing, 6 GB), hybrid/Optimus |
| RAM | 32 GB |
| Display | 1920x1080 @ 120 Hz |
| Disks | two: ~1 TB (Linux, whole disk) and ~256 GB (left untouched for Windows) |
| Firmware | UEFI, Secure Boot ON (must be disabled for the stick to boot) |
| Uses | GitHub Desktop, Visual Studio, Unity, Godot (game dev), games |

## Decisions (approved by the owner)

1. Clean install, Windows wiped from the big disk; the small disk is reserved for a later Windows
   install, no dual-boot menu: systemd-boot `timeout 0`, Windows via the firmware boot menu (F12).
2. The stick is minimal: base + drivers + Plasma + Codex offline; games and the rest are downloaded
   on the friend's faster internet by Codex, following `NEXT-STEPS.md`.
3. No passwords anywhere: empty user password, autologin, `sudo`/polkit without prompts,
   screen lock and KWallet off — the same philosophy as whitebook.
4. ext4, no snapshots now; one snapshot later on request (Timeshift rsync).
5. UI Ukrainian, layouts us/ru/ua, Alt+Shift cycles; the exact whitebook switcher
   (Alt+Shift EN⇄RU, Ctrl+Shift UA, OSD) is a Codex task with `osd-daemon` as the reference.
6. Plasma on Wayland (switched after the X11 session showed a black desktop on the hybrid GPU); X11 kept as a fallback.

## Stage A — this laptop (done)

- archiso releng profile + `friend/` folder in the ISO root: offline repo (844 packages, 2.5 GB),
  Codex npm tarball, payload configs, docs, `friend-install` in the live system.
- Tested in QEMU (two virtio disks, no network): install → reboot → Plasma autologin.

## Stage B — on the friend's laptop

1. BIOS: Secure Boot off, UEFI, hybrid graphics. Boot the stick (F12).
2. `friend-install`: Enter (largest disk), username, hostname, `YES`. About 7–10 minutes.
3. Reboot into Plasma. Wi-Fi → `sudo pacman -Syu` → `codex login` → `~/ai/linux-setup/NEXT-STEPS.md`.

## Known Linux limits on this machine

- Kernel anti-cheat games (Valorant, CoD, Fortnite, BF6) — never; that is what the Windows disk is for.
- HDR — not relevant (SDR panel). VRR — panel is not G-Sync; nothing lost.
- NVIDIA driver is closed; the X11 session gave a black desktop on this hybrid GPU, Wayland works.
