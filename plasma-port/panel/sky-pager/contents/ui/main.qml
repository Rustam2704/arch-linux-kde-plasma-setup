// Sky Pager — whitebook's workspace strip for a Plasma panel.
// Digits 1..N in the Diablo font; the active desktop's digit is black under the
// Diablo logo fire (15-frame sheets, one per digit, 60 ms a frame) with a spinning
// pentagram on each side (8 frames). Desktops with windows are brighter.
// Click = switch, wheel = previous/next. Sheets and geometry: images/fire/index.json
// (cut by whitebook's external-assets/tools/fire-digits.py for "Diablo 18" at 144 dpi).
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.taskmanager as TaskManager

PlasmoidItem {
    id: root

    readonly property real k: Plasmoid.configuration.scale / 100      // sheet pixels -> panel pixels
    readonly property int cell: Math.round(Plasmoid.configuration.cellWidth * k)
    readonly property int frameMs: 60
    property var index: ({})                                           // images/fire/index.json
    property int frame: 0
    readonly property string fireDir: Qt.resolvedUrl("../images/fire/")

    // whitebook colours (theme.json)
    readonly property color colourActive: "#000000"
    readonly property color colourBusy: "#c6d0d9"
    readonly property color colourIdle: "#5b6b76"

    preferredRepresentation: fullRepresentation
    Layout.preferredWidth: strip.implicitWidth
    Layout.minimumWidth: strip.implicitWidth
    Layout.fillHeight: true

    TaskManager.VirtualDesktopInfo { id: desktops }

    Timer {
        interval: root.frameMs; running: root.visible && Plasmoid.status !== PlasmaCore.Types.HiddenStatus; repeat: true
        onTriggered: root.frame = (root.frame + 1) % 120
    }

    Component.onCompleted: {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", fireDir + "index.json");
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.responseText.length > 0) {
                try { root.index = JSON.parse(xhr.responseText); } catch (e) { console.warn("sky-pager: index.json:", e); }
            }
        };
        xhr.send();
    }

    function sheetFor(n) {
        var name = "flame" + (((n - 1) % 6) + 1) + "-digit" + n + ".png";
        var sheets = root.index.sheets || {};
        return sheets[name] ? { name: name, info: sheets[name] } : null;
    }

    fullRepresentation: Item {
        id: strip
        implicitWidth: row.width
        implicitHeight: parent ? parent.height : 44
        clip: false

        Row {
            id: row
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            Repeater {
                model: desktops.numberOfDesktops
                delegate: Item {
                    id: cellItem
                    required property int index
                    readonly property int number: index + 1
                    readonly property var desktopId: desktops.desktopIds[index]
                    readonly property bool active: desktops.currentDesktop === desktopId
                    readonly property var sheet: root.sheetFor(number)
                    width: root.cell
                    height: strip.height

                    // windows on this desktop -> brighter digit (whitebook: "занятые области светлее")
                    TaskManager.TasksModel {
                        id: tasks
                        filterByVirtualDesktop: true
                        virtualDesktop: cellItem.desktopId
                        filterByScreen: false
                        filterByActivity: false
                        filterMinimized: false
                    }

                    // fire behind the digit: the hole in the flames sits over the glyph
                    Image {
                        id: fire
                        visible: cellItem.active && cellItem.sheet !== null
                        source: cellItem.sheet ? root.fireDir + cellItem.sheet.name : ""
                        readonly property var info: cellItem.sheet ? cellItem.sheet.info : null
                        readonly property int fw: info ? info.width : 0
                        readonly property int fh: info ? info.height : 0
                        readonly property int frames: root.index.frames || 15
                        sourceClipRect: Qt.rect(0, (root.frame % frames) * fh, fw, fh)
                        width: fw * root.k
                        height: fh * root.k
                        smooth: true
                        x: info ? digit.x + digit.width / 2 - (info.digit_width / 2 + info.hole_x) * root.k : 0
                        y: info ? digit.y + (digit.height - info.digit_height * root.k) / 2 - info.above * root.k : 0
                        z: 0
                    }

                    // spinning pentagrams, one each side of the active digit
                    Repeater {
                        model: (cellItem.active && Plasmoid.configuration.showPentagrams && root.index.spin) ? 2 : 0
                        delegate: Image {
                            required property int index
                            readonly property int size: root.index.spin.size
                            readonly property int frames: root.index.spin.frames
                            source: root.fireDir + "spin.png"
                            sourceClipRect: Qt.rect(0, (root.frame % frames) * size, size, size)
                            width: size * root.k
                            height: size * root.k
                            smooth: true
                            y: digit.y + (digit.height - height) / 2
                            x: index === 0 ? digit.x + (digit.width - digit.contentWidth) / 2 - 6 * root.k - width
                                           : digit.x + (digit.width + digit.contentWidth) / 2 + 6 * root.k
                            z: 2
                        }
                    }

                    Text {
                        id: digit
                        anchors.centerIn: parent
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: cellItem.number
                        font.family: "Diablo"
                        font.pixelSize: Math.round(30 * root.k)
                        color: cellItem.active ? root.colourActive : (tasks.count > 0 ? root.colourBusy : root.colourIdle)
                        z: 1
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        onClicked: desktops.requestActivate(cellItem.desktopId)
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            onWheel: function (wheel) {
                var n = desktops.numberOfDesktops;
                if (n < 2) return;
                var cur = desktops.desktopIds.indexOf(desktops.currentDesktop);
                var next = wheel.angleDelta.y < 0 ? (cur + 1) % n : (cur - 1 + n) % n;
                desktops.requestActivate(desktops.desktopIds[next]);
            }
        }
    }
}
