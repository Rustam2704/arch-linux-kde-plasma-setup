// Plasma panel in the spirit of whitebook's top panel: one row at the top,
// app menu · taskbar · workspace numbers · (stretch) · tray · layout · clock · power.
var old = panels();
for (var i = 0; i < old.length; ++i) { old[i].remove(); }

var p = new Panel;
p.location = "top";
p.height = 44;
p.hiding = "none";
p.lengthMode = "fill";

p.addWidget("org.kde.plasma.kickoff");

var tasks = p.addWidget("org.kde.plasma.icontasks");
tasks.currentConfigGroup = ["General"];
tasks.writeConfig("launchers", [
    "applications:org.kde.konsole.desktop",
    "applications:org.kde.dolphin.desktop",
    "applications:firefox.desktop",
    "applications:org.kde.kate.desktop"
]);
tasks.writeConfig("showOnlyCurrentDesktop", true);

var pager = p.addWidget("org.kde.plasma.pager");
pager.currentConfigGroup = ["General"];
pager.writeConfig("displayedText", "Number");
pager.writeConfig("wrapPage", true);

p.addWidget("org.kde.plasma.panelspacer");
p.addWidget("org.kde.plasma.systemtray");
p.addWidget("org.kde.plasma.keyboardlayout");

var clock = p.addWidget("org.kde.plasma.digitalclock");
clock.currentConfigGroup = ["Appearance"];
clock.writeConfig("showDate", false);
clock.writeConfig("use24hFormat", 2);

var power = p.addWidget("org.kde.plasma.lock_logout");
power.currentConfigGroup = ["General"];
power.writeConfig("show_lockScreen", false);
power.writeConfig("show_requestLogout", false);
power.writeConfig("show_requestLogoutAndLock", false);
power.writeConfig("show_switchUser", false);
power.writeConfig("show_suspend", false);
power.writeConfig("show_hibernate", false);
power.writeConfig("show_requestShutDown", true);
power.writeConfig("show_requestReboot", false);

// Pure black desktop, no wallpaper image.
var ds = desktops();
for (var i = 0; i < ds.length; ++i) {
    ds[i].wallpaperPlugin = "org.kde.color";
    ds[i].currentConfigGroup = ["Wallpaper", "org.kde.color", "General"];
    ds[i].writeConfig("Color", "#000000");
}
