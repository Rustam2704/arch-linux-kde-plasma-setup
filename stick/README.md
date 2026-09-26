# stick — установочная флешка (archiso)

Что лежало на флешке, с которой ставился ноутбук: `friend-install` (скрипт установки в live-системе),
`packages.txt` (офлайн-набор, 844 пакета), `system/` `home/` `boot/` (payload: sudoers, polkit,
SDDM-автологин, systemd-boot без меню, zram, NVIDIA, раскладки, конфиги Plasma).
Сборка: профиль archiso `releng` + папка `friend/` в корне ISO (`repo/`, `codex/`, `payload/`, `docs/`),
см. `docs/INSTALL.md`. Пересобирать не нужно, оставлено для истории и повторной установки.
