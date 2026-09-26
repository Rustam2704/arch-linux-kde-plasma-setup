# Установка Arch + KDE Plasma с флешки на Lenovo Legion 5 — инструкция для помощника

Контекст. На флешке записан кастомный образ Arch Linux (archiso). В корне образа есть папка
`friend/` с локальным репозиторием пакетов, Codex CLI и конфигами. В live-системе есть скрипт
`friend-install`, который ставит систему целиком без интернета. Скрипт ожидает папку по пути
`/run/archiso/bootmnt/friend` (запасной путь `/opt/friend`). Если её там нет, он завершается
с сообщением `package list not found`.

В ноутбуке два диска: ~1 ТБ (сюда ставим Linux, диск стирается полностью) и ~256 ГБ (не трогать,
он под Windows). Все данные с ноутбука уже сохранены, стирать можно.

Все команды выполняются в консоли live-системы от root (приглашение `root@archiso ~ #`).
Раскладка в консоли английская.

## 0. Если появилась ошибка `package list not found`

Выполнить по очереди и сфотографировать вывод:

```
findmnt /run/archiso/bootmnt
ls /run/archiso/bootmnt
lsblk -o NAME,SIZE,FSTYPE,LABEL
```

Ожидание: среди устройств есть раздел с `FSTYPE=iso9660` и `LABEL=ARCH_202609` (флешка, обычно
`sda1` или `sdb1`; диски ноутбука — `nvme0n1`, `nvme1n1` или `sda`).

Обход — смонтировать раздел флешки вручную и указать скрипту новый путь (вместо `sdX1` подставить
раздел с меткой ARCH_202609):

```
mkdir -p /run/stick
mount -o ro /dev/disk/by-label/ARCH_202609 /run/stick
ls /run/stick/friend
```

Если `ls` показал `codex docs packages.txt payload repo` — всё на месте. Тогда:

```
sed -i 's|^FRIEND=/run/archiso/bootmnt/friend|FRIEND=/run/stick/friend|' /usr/local/bin/friend-install
friend-install
```

Если по метке не монтируется, взять устройство из `lsblk`:
`mount -o ro /dev/sdX1 /run/stick` (или `/dev/sdX`, если у самого устройства FSTYPE iso9660).

## 1. Обычный запуск установщика

```
friend-install
```

Скрипт спросит:

1. `Install Linux to (the whole disk is erased) [/dev/...]:` — по умолчанию предлагает самый
   большой диск (~1 ТБ). Проверить по размеру в скобках; если предложен ~1 ТБ — просто Enter.
   Если предложен маленький диск — ввести имя большого (например `/dev/nvme0n1`).
2. `Username [legion]:` — имя пользователя латиницей, маленькими буквами (или Enter = legion).
3. `Hostname [legion]:` — имя компьютера (или Enter).
4. `Type YES to continue:` — ввести `YES` заглавными.

Дальше 7–15 минут: разметка, установка 844 пакетов, настройка. Признак конца:

```
== done.  Remove the stick and reboot: the machine boots straight into Plasma as <имя>.
```

Лог установки: `/tmp/friend-install.log` (после перезагрузки —
`~/ai/linux-setup/install.log`). Если что-то упало — сфотографировать последние строки:
`tail -30 /tmp/friend-install.log`.

Интернет не нужен. Если хочется свежие пакеты с зеркал, до запуска можно подключить Wi-Fi:

```
iwctl station wlan0 scan
iwctl station wlan0 get-networks
iwctl station wlan0 connect "Имя сети"
```

## 2. После установки

```
reboot
```

Вынуть флешку. Ноутбук должен загрузиться прямо в KDE Plasma без выбора системы и без пароля.

Если вместо этого запускается старая Windows или «no bootable device»: зайти в BIOS (F2 при
включении) → Boot → поставить `Linux Boot Manager` первым (или `UEFI OS` на диске ~1 ТБ),
Secure Boot должен быть Disabled.

## 3. Первые шаги в Plasma

1. Подключить Wi-Fi (значок сети в трее справа вверху).
2. Открыть терминал (Super+Enter или Konsole в меню) и выполнить:
   ```
   sudo pacman -Syu
   codex login
   ```
   Пароль нигде не спрашивается. `codex login` откроет браузер для входа в аккаунт OpenAI.
3. Запустить Codex в папке `~/ai` и сказать ему прочитать `~/ai/linux-setup/NEXT-STEPS.md` —
   там описано, что установлено и что ставить дальше (Steam, драйверы для игр, панель, раскладки).

## 4. Если установщик вообще не работает

Запасной путь — стандартный установщик Arch (он есть в live-системе, нужен интернет):

```
iwctl station wlan0 connect "Имя сети"
archinstall
```

Выбрать: диск ~1 ТБ, файловая система ext4, профиль Desktop → KDE Plasma, видеодрайвер
`nvidia-open`, bootloader systemd-boot, пользователь с правами sudo, сеть NetworkManager,
звук pipewire. После установки на систему вручную поставить Codex: `sudo npm install -g @openai/codex`.
