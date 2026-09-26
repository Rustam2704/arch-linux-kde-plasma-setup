// Plasma panel in the spirit of whitebook's top panel:
// app menu · taskbar · Diablo workspace strip · (stretch) · CPU · RAM · tray · layout · clock · power
// Applied with apply-panel.sh (evaluateScript over D-Bus). Replaces every existing panel.
var old = panels();
for (var i = 0; i < old.length; ++i) { old[i].remove(); }

var p = new Panel;
p.location = "top";
p.height = 44;
p.hiding = "none";
p.lengthMode = "fill";
p.floating = false;

p.addWidget("org.kde.plasma.kickoff");

var tasks = p.addWidget("org.kde.plasma.icontasks");
tasks.currentConfigGroup = ["General"];
tasks.writeConfig("launchers", [
    "applications:kitty.desktop",
    "applications:org.kde.dolphin.desktop",
    "applications:firefox.desktop",
    "applications:org.kde.kate.desktop"
]);
tasks.writeConfig("showOnlyCurrentDesktop", true);
tasks.writeConfig("middleClickAction", "NewInstance");

// whitebook's workspace strip: Diablo digits, fire + pentagrams on the active one
// (plasmoid org.sky.pager from panel/sky-pager, installed by apply.sh)
var pager = p.addWidget("org.sky.pager");
pager.currentConfigGroup = ["General"];
pager.writeConfig("scale", 60);
pager.writeConfig("showPentagrams", true);

p.addWidget("org.kde.plasma.panelspacer");

// System monitor widgets: CPU and memory. The sensor ids are the ones the
// "Системний монітор" widgets use by default; if a widget shows nothing, open its
// settings once and pick the sensor by hand (the config is then written properly).
var cpu = p.addWidget("org.kde.plasma.systemmonitor.cpucore");
cpu.currentConfigGroup = ["Appearance"];
cpu.writeConfig("chartFace", "org.kde.ksysguard.textonly");
cpu.writeConfig("title", "CPU");
cpu.currentConfigGroup = ["SensorColors"];
cpu.writeConfig("cpu/all/usage", "72,218,249");
cpu.currentConfigGroup = ["Sensors"];
cpu.writeConfig("highPrioritySensorIds", '["cpu/all/usage"]');
cpu.writeConfig("totalSensors", '["cpu/all/usage"]');

var mem = p.addWidget("org.kde.plasma.systemmonitor.memory");
mem.currentConfigGroup = ["Appearance"];
mem.writeConfig("chartFace", "org.kde.ksysguard.textonly");
mem.writeConfig("title", "RAM");
mem.currentConfigGroup = ["SensorColors"];
mem.writeConfig("memory/physical/used", "72,218,249");
mem.currentConfigGroup = ["Sensors"];
mem.writeConfig("highPrioritySensorIds", '["memory/physical/usedPercent"]');
mem.writeConfig("totalSensors", '["memory/physical/usedPercent"]');

p.addWidget("org.kde.plasma.systemtray");
p.addWidget("org.kde.plasma.keyboardlayout");

var clock = p.addWidget("org.kde.plasma.digitalclock");
clock.currentConfigGroup = ["Appearance"];
clock.writeConfig("showDate", false);
clock.writeConfig("showSeconds", 0);
clock.writeConfig("use24hFormat", 2);
clock.writeConfig("autoFontAndSize", false);
clock.writeConfig("fontFamily", "DSEG7 Classic");
clock.writeConfig("fontWeight", 700);
clock.writeConfig("italicText", true);
clock.writeConfig("fontSize", 14);

var power = p.addWidget("org.kde.plasma.lock_logout");
power.currentConfigGroup = ["General"];
power.writeConfig("show_lockScreen", false);
power.writeConfig("show_requestLogout", false);
power.writeConfig("show_requestLogoutAndLock", false);
power.writeConfig("show_switchUser", false);
power.writeConfig("show_suspend", false);
power.writeConfig("show_hibernate", false);
power.writeConfig("show_requestReboot", false);
power.writeConfig("show_requestShutDown", true);

// Pure black desktop, no wallpaper image.
var ds = desktops();
for (var i = 0; i < ds.length; ++i) {
    ds[i].wallpaperPlugin = "org.kde.color";
    ds[i].currentConfigGroup = ["Wallpaper", "org.kde.color", "General"];
    ds[i].writeConfig("Color", "#000000");
}
