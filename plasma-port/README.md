# plasma-port — вид и удобства whitebook на KDE Plasma (Legion 5)

Готовые файлы для переноса того, что описано в `../FEATURES-ON-PLASMA.md`, на ноутбук с
Arch + Plasma 6 (X11-сессия). Окна остаются обычными плавающими окнами Plasma; правила окон
KWin не переносятся. Всё написано без проверки на живой Plasma: где что-то не сойдётся, чинит
локальная нейронка, ниже написано, что именно может разойтись.

## Что внутри

| Папка | Что | Куда ставится |
|---|---|---|
| `colors/Sky.colors` | цветовая схема Plasma: фон `#000000`, поверхности `#12171a`, текст `#dfe8ee`, акцент `#0d8ecb`, свет `#48daf9` | `~/.local/share/color-schemes/` |
| `fonts/Diablo.ttf` | шрифт панели whitebook; DSEG7 (часы), Inter, JetBrainsMono — пакетами | `~/.local/share/fonts/` |
| `panel/sky-panel.js` | панель сверху 44 px: меню · панель задач · номера столов · растяжка · CPU · RAM · трей · раскладка · часы DSEG7 · выключение; чёрный фон | применяется скриптом `apply-panel.sh` |
| `kbd/sky-kbd` | переключатель раскладок как на whitebook: Alt+Shift EN⇄RU, Ctrl+Shift UA по отпусканию, OSD по центру, звуки Enter/стрелок из Diablo | `~/.local/bin/`, служба `sky-kbd.service` |
| `net/netqd`, `net/panel-ping` | пинг роутера и 1.1.1.1, «сейчас · медиана» для виджета панели | `~/.local/bin/`, служба `netqd.service` |
| `kitty/` | kitty с цветами темы, Ctrl+C/V в любой раскладке, Ctrl+клик по пути (kate/dolphin) | `~/.config/kitty/`, `~/.local/bin/open-path` |
| `kwin/effects.sh` | тени и затухание без размытия, 5 столов, тонкие рамки, кнопки окна как в Windows | `kwriteconfig6` → `kwinrc` |
| `touchegg/touchegg.conf` | жесты: 3 пальца столы/обзор/меню, 4 пальца развернуть/свернуть | `~/.config/touchegg/` (пакет `touchegg` из AUR) |
| `gaming/install-gaming.sh` | Steam, lib32-драйверы, gamemode, MangoHud, Lutris, Wine, Discord, OBS, Godot, Unity Hub, VS Code, Heroic, ProtonUp-Qt | отдельный шаг |
| `apply.sh` | ставит всё выше (кроме панели и touchegg) с бэкапами в `~/.local/state/plasma-port/` | — |

## Порядок

```
cd ~/ai/plasma-port          # папка скопирована сюда
chmod +x apply.sh panel/apply-panel.sh kwin/effects.sh gaming/install-gaming.sh
./apply.sh                   # цвета, шрифты, kitty, раскладки, netqd, KWin
./apply.sh panel             # панель — отдельно, заменяет текущую (бэкап appletsrc делается)
bash gaming/install-gaming.sh
```

Панель Command Output для пинга (штатного «вывод команды» в Plasma нет): пакета в AUR сейчас
нет, ставится из магазина KDE: «Параметри системи → Додати віджети → Отримати нові віджети»,
поиск `Command Output` (автор Zren), либо `kpackagetool6 -t Plasma/Applet -i <zip с github.com/Zren/plasma-applet-commandoutput>`.
Потом добавить виджет на панель перед треем: команда `~/.local/bin/panel-ping`, интервал 1000 мс,
шрифт Diablo 12.

Выход из сессии и вход заново после `./apply.sh` — раскладки и шрифты подхватятся везде.

## Что проверить после применения (и где может разойтись)

1. **Панель**: если после `apply-panel.sh` панель пустая или стандартная — имена виджетов
   `org.kde.plasma.systemmonitor.cpucore` / `.memory` и их ключи `Sensors` могли измениться в
   6.7; заменить на добавление виджетов «Монітор системи» вручную и удалить эти блоки из
   `sky-panel.js`. Ключи `lock_logout` (`show_*`) и часов (`showDate`, `fontFamily`) — проверить в
   `~/.config/plasma-org.kde.plasma.desktop-appletsrc`, лишние просто игнорируются.
   Откат: `plasmashell --replace` после возврата бэкапа `appletsrc.bak-*`.
2. **sky-kbd**: `systemctl --user status sky-kbd`; в «Параметри системи → Клавіатура» должно быть
   без сочетания переключения (скрипт убирает `grp:alt_shift_toggle` из `kxkbrc`; если Plasma
   вернула — снять в настройках). Индикатор раскладки в трее следит за группой XKB сам.
   На Wayland не работает (XRecord) — оставаться на X11 или переписать на evdev + D-Bus
   `org.kde.keyboard /Layouts switchToLayout`.
3. **Цвета**: если у окон GTK остался светлый вид — «Параметри системи → Кольори та теми →
   Стиль програм → Налаштувати стиль GNOME/GTK» → Breeze; цветовая схема Sky применяется к Qt.
4. **Звуки клавиш**: `libpulse-simple` через PipeWire-Pulse; выключить — `mkdir -p ~/.config/sky-kbd && touch ~/.config/sky-kbd/nosound`.
5. **kitty**: Ctrl+клик открывает пути через `~/.local/bin/open-path` (kate для файлов, dolphin
   для папок); если нужен другой редактор — одна строка в `open-path`.
6. **touchegg**: X11 только; `yay -S touchegg && sudo systemctl enable --now touchegg`,
   конфиг в `~/.config/touchegg/touchegg.conf`, клиент стартует из `/etc/xdg/autostart`.

## Чего здесь намеренно нет

Правила окон KWin (Telegram вне панели задач, Zoom, привязка программ к столам), рабочие
области отдельно на каждом экране, огонь и пентаграммы на панели, режим passthrough, лимиты
памяти Firefox, `sky-stars` (можно перенести отдельно: это X11-окно типа DESKTOP, под KWin
работает, но ставить только если друг захочет анимированный фон).
