# arch-linux-kde-plasma-setup

Arch Linux + KDE Plasma на Lenovo Legion 5 15IMH05H (i5-10300H, Intel UHD 630 + GTX 1660 Ti,
32 ГБ, 1080p 120 Гц, Plasma на Wayland), настроенный в духе whitebook: без паролей, загрузка сразу в рабочий стол,
чёрная тема с акцентом `#0d8ecb`, клавиши как в Windows, раскладки us/ru/ua.

## Для локальной нейронки (Codex) на этой машине

1. Прочитать `docs/AGENTS.md` (философия и правила) и `docs/NEXT-STEPS.md` (что уже стоит, что
   ставить).
2. `plasma-port/README.md` — порядок применения готовых файлов: цвета, шрифты, панель, переключатель
   раскладок, netqd, kitty, KWin-эффекты, жесты, игровой стек (`gaming/install-gaming.sh`).
3. `docs/FEATURES-ON-PLASMA.md` — какие возможности whitebook чем реализуются в Plasma.

Окна остаются обычными плавающими окнами Plasma, правила окон KWin не переносятся.

## Структура

```
plasma-port/   готовые файлы и apply.sh (см. plasma-port/README.md)
docs/          AGENTS.md · NEXT-STEPS.md · FEATURES-ON-PLASMA.md · INSTALL.md · PLAN.md
stick/         как была собрана установочная флешка (friend-install, payload, packages.txt)
```

## Быстрый старт

```
git clone https://github.com/Rustam2704/arch-linux-kde-plasma-setup ~/ai/arch-linux-kde-plasma-setup
cd ~/ai/arch-linux-kde-plasma-setup/plasma-port
./apply.sh            # цвета, шрифты, kitty, раскладки, netqd, KWin
./apply.sh panel      # панель сверху (заменяет текущую, бэкап делается)
bash gaming/install-gaming.sh
```
