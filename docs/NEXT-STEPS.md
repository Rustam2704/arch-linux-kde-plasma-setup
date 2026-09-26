# Legion 5 — что уже сделано и что делать дальше (для Codex)

Машина: Lenovo Legion 5 15IMH05H, i5-10300H, Intel UHD 630 + GTX 1660 Ti (Turing), 32 ГБ,
экран 1920×1080 120 Гц, два диска: Linux занимает весь больший (~1 ТБ), меньший (~256 ГБ)
оставлен под Windows. Установлено с флешки, собранной на whitebook 2026-09-25.

## Что уже есть

- Arch Linux, ядра `linux-lts` (по умолчанию) и `linux` (запасное), systemd-boot без меню
  (`timeout 0`; меню — зажать пробел при загрузке). ext4, ESP 1 ГБ на `/boot`, zram 8 ГБ вместо
  файла подкачки, `zswap` выключен.
- Графика: `nvidia-open` (+`-lts`), `nvidia-utils`, `nvidia-settings`, `nvidia-prime` (`prime-run`),
  `switcheroo-control` (пункт «Запустить на дискретной видеокарте» в меню Plasma), Intel `mesa` +
  `vulkan-intel`. Ноутбук гибридный: экран рисует Intel, игры — через `prime-run` или Steam
  (Steam сам выбирает NVIDIA). Ранний KMS только для `i915`; `nvidia` грузится обычным
  модулем; `NVreg_DynamicPowerManagement=0x02` (дискретная карта засыпает без нагрузки).
- Звук `pipewire` + `sof-firmware`, сеть `NetworkManager`, Bluetooth `bluez`, `power-profiles-daemon`,
  `thermald`, `fstrim.timer`, `paccache.timer`.
- KDE Plasma, сессия **Wayland** (`plasma`); X11-сессия установлена как запасная.
  SDDM автологин. Пароли: у пользователя пустой, root заблокирован, `sudo` и polkit без
  запросов, блокировка экрана и KWallet выключены.
- Интерфейс украинский (`LANG=uk_UA.UTF-8`, `plasma-localerc`), локали en_US/uk_UA/ru_RU.
  Раскладки `us,ru,ua`, переключение `Alt+Shift` по кругу (xkb `grp:alt_shift_toggle`).
- Первый вход: скрипт `friend-first-login` ставит Breeze Dark с акцентом `#0d8ecb`, панель сверху
  44 px (меню · панель задач · номера рабочих столов · трей · раскладка · часы · выключение),
  чёрный фон, максимальную частоту экрана; после этого удаляет себя. Лог:
  `~/.local/state/friend-first-login.log`.
- Клавиши (см. `~/.config/kglobalshortcutsrc`): Super+Return Konsole, Super+E Dolphin, Super+R
  KRunner, Super+Q закрыть, Super+↑/↓/←/→ развернуть/свернуть/половины, Super+1..5 рабочие
  столы, Super+Shift+1..5 перенос окна, Print / Super+Shift+S скриншот, Ctrl+Shift+Esc монитор,
  Super+Shift+E выход. Alt+Tab — стандартный.
- Codex CLI (`codex`, npm-пакет `@openai/codex` 0.157.0), `nodejs`, `npm`, `git`, `base-devel`,
  `yay` (AUR), `multilib` включён в `pacman.conf`. `firefox`, `konsole`, `kitty`, `dolphin`, `kate`.
- Шрифты: Noto (+CJK, emoji), Liberation, DejaVu, Inter, JetBrainsMono Nerd.
- `~/ai/whitebook-setup/` — копия setup-проекта whitebook (эталон поведения и вида).

## Первым делом

1. Подключить Wi-Fi (трей → сеть), `sudo pacman -Syu`, перезагрузка.
2. `codex login` (нужен браузер), затем `codex` в `~/ai/`.
3. Проверить: `nvidia-smi`, `prime-run glxinfo -B | grep renderer`, `kscreen-doctor -o` (120 Гц),
   звук, Bluetooth, тачпад, `Alt+Shift` по раскладкам, `~/.local/state/friend-first-login.log`.

## Что установить (интернет здесь быстрый — качать всё сюда, не на флешку)

Игры:
- `steam` (multilib), `lib32-nvidia-utils`, `lib32-mesa`, `lib32-vulkan-intel`,
  `gamemode` + `lib32-gamemode`, `mangohud` + `lib32-mangohud`, `gamescope`.
- `lutris`, `wine-staging`, `winetricks`; AUR: `protonup-qt` (Proton-GE), `heroic-games-launcher-bin`.
- `discord`, `obs-studio`, `vlc`, `telegram-desktop`.
- В Steam: Настройки → Совместимость → включить Proton для всех игр; для тяжёлых игр
  `gamemoderun %command%` в параметрах запуска. Игры с kernel-античитом (Valorant, CoD, Fortnite,
  Battlefield 6) — только Windows на втором диске.

Разработка (то, что стояло на Windows): `godot`, AUR `unityhub`, `github-desktop-bin`,
`visual-studio-code-bin` (или `code` из extra — открытая сборка).

## Довести «как на whitebook»

- Переключение раскладок как там: `Alt+Shift` EN⇄RU, `Ctrl+Shift` → UA на отпускании, с OSD —
  готово в `plasma-port/kbd/sky-kbd` (evdev + D-Bus Plasma), ставится `plasma-port/apply.sh`.
- Панель: сравнить со снимком и описанием в `ARCHITECTURE.md` («Панель Xfce»): индикаторы
  ping/CPU/RAM, погода, батарея, Telegram; в Plasma это либо виджеты из Discover (System
  Monitor Sensor, Weather), либо `plasma-applet-commandoutput` для genmon-подобных скриптов.
- Цветовая схема: чисто чёрная схема на базе Breeze Dark (фон `#000000`, поверхности `#12171a`,
  рамки `#1e262c`, текст `#dfe8ee`, акцент `#0d8ecb`, свет `#48daf9`) — `~/.local/share/color-schemes/`.
- Окна: тонкая рамка акцентного цвета, заголовки компактные (Breeze → размер кнопок), без
  анимаций «взрыва» (Параметри системи → Ефекти).
- Уведомления Plasma не лезть в игру: «Не турбувати» при полноэкранных окнах (стандартно есть).
- Fn-клавиши Legion (режимы вентилятора, подсветка): AUR `lenovolegionlinux-dkms-git` — только если
  друг попросит; это `-git`.

## Windows на второй диск (когда понадобится)

1. Установщик Windows: выбрать ТОЛЬКО меньший диск, остальное не трогать.
2. После установки Windows поставит себя первым в UEFI. Вернуть Linux первым:
   `sudo efibootmgr` → найти `Linux Boot Manager` → `sudo efibootmgr -o XXXX,YYYY`.
3. Windows выбирать через меню загрузки Lenovo (F12 / кнопка Novo), меню systemd-boot не нужно.
4. В Windows выключить Fast Startup и синхронизировать часы: в Linux
   `timedatectl set-local-rtc 1` (иначе время расходится на 3 часа).

## Снапшоты

Пока не ставить. Когда все драйверы проверены и друг попросит — один снапшот (Timeshift
rsync на ext4 — `timeshift` из extra) и дальше только по запросу.
